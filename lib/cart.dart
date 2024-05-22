import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'custom_widgets.dart';
import 'Managers.dart';
import 'item.dart';
import 'product.dart';

class CartPage extends StatefulWidget {
  final String previousViewName;

  const CartPage({super.key, required this.previousViewName});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final ValueNotifier<int> cartItemCount = ValueNotifier<int>(0);

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      _fetchCartItems() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      CollectionReference<Map<String, dynamic>> cartRef = FirebaseFirestore
          .instance
          .collection('Usuarios')
          .doc(user.uid)
          .collection('Carrito') as CollectionReference<Map<String, dynamic>>;
      QuerySnapshot<Map<String, dynamic>> cartSnapshot = await cartRef.get();
      return cartSnapshot.docs;
    }
    return [];
  }

  Future<void> _updateCartCount() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      CollectionReference<Map<String, dynamic>> cartRef = FirebaseFirestore
          .instance
          .collection('Usuarios')
          .doc(user.uid)
          .collection('Carrito') as CollectionReference<Map<String, dynamic>>;
      QuerySnapshot<Map<String, dynamic>> cartSnapshot = await cartRef.get();
      int itemCount = cartSnapshot.docs
          .fold(0, (count, doc) => count + doc.data()['cantidad'] as int);
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('Usuarios').doc(user.uid);
      userRef.update({'cartCount': itemCount});
      cartItemCount.value = itemCount;
    }
  }

  Future<void> _updateCartItem(
      DocumentReference<Map<String, dynamic>> cartItemRef, int quantity) async {
    if (quantity > 0) {
      await cartItemRef.update({'cantidad': quantity});
    } else {
      await cartItemRef.delete();
    }
    await _updateCartCount();
  }

  @override
  void initState() {
    super.initState();
    _loadCartItemCount();
  }

  Future<void> _loadCartItemCount() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('Usuarios').doc(user.uid);
      DocumentSnapshot userSnapshot = await userRef.get();
      if (userSnapshot.exists) {
        cartItemCount.value = userSnapshot.get('cartCount') ?? 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(cartItemCount: cartItemCount),
      endDrawer: CustomDrawer(previousViewName: widget.previousViewName),
      body: FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
        future: _fetchCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('El carrito está vacío'));
          }

          List<QueryDocumentSnapshot<Map<String, dynamic>>> cartItems =
              snapshot.data!;
          double subtotal = cartItems.fold(
              0,
              (sum, item) =>
                  sum + (item['price'] as num) * (item['cantidad'] as int));
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.chevron_left,
                              size: MediaQuery.of(context).size.width * 0.04,
                            ),
                            Text(
                              'volver',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Mi carrito',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          var item = cartItems[index];
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Image.network(
                                    item['imageUrl'],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['name'],
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text('\$${item['price']}'),
                                        Text('Color: ${item['color']}'),
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () async {
                                                int newCantidad =
                                                    item['cantidad'] - 1;
                                                await _updateCartItem(
                                                  item.reference,
                                                  newCantidad,
                                                );
                                                setState(() {});
                                              },
                                              icon: const Icon(Icons.remove),
                                            ),
                                            Text(item['cantidad'].toString()),
                                            IconButton(
                                              onPressed: () async {
                                                int newCantidad =
                                                    item['cantidad'] + 1;
                                                await _updateCartItem(
                                                  item.reference,
                                                  newCantidad,
                                                );
                                                setState(() {});
                                              },
                                              icon: const Icon(Icons.add),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                      '\$${(item['price'] as num) * (item['cantidad'] as int)}'),
                                ],
                              ),
                              const Divider(),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      const TextField(
                        decoration: InputDecoration(
                          hintText: 'Ingresar código promocional',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const TextField(
                        decoration: InputDecoration(
                          hintText: 'Agregar una nota',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text('Subtotal: \$${subtotal.toStringAsFixed(2)}'),
                      const SizedBox(height: 10),
                      const Text('Calcular envío'),
                      const SizedBox(height: 10),
                      Text('Total: \$${subtotal.toStringAsFixed(2)}'),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // Acción del botón "Finalizar compra"
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: const Color(0xFF607D82),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(0)),
                            ),
                          ),
                          child: const Text('Finalizar compra'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Center(
                        child: Text(
                          'Pago seguro',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                CustomFooter(),
              ],
            ),
          );
        },
      ),
    );
  }
}
