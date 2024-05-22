import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'custom_widgets.dart';
import 'item.dart';
import 'product.dart';
import 'main.dart'; // Asegúrate de importar donde tengas el routeObserver

class CategoryPage extends StatefulWidget {
  CategoryPage(
      {super.key, required this.title, required this.previousViewName});
  final String title;
  final String previousViewName;

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> with RouteAware {
  final ValueNotifier<int> cartItemCount = ValueNotifier<int>(0);
  String? _selectedPrice;
  String? _selectedOrder;
  final List<String> _prices = [
    'Todos',
    'Menor a \$500',
    '\$500 - \$1000',
    'Mayor a \$1000'
  ]; // Lista de precios

  final List<String> _orders = [
    'Ordenar por',
    'Lo más nuevo',
    'Precio (de menor a mayor)',
    'Precio (de mayor a menor)',
    'Nombre de A-Z',
    'Nombre Z-A'
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _loadCartItemCount();
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
    CollectionReference productsRef = FirebaseFirestore.instance.collection(
        widget.title); // Cambia el nombre de la colección según la categoría

    return Scaffold(
      backgroundColor: const Color(0xFFedeff0),
      appBar: CustomAppBar(cartItemCount: cartItemCount),
      endDrawer: CustomDrawer(previousViewName: widget.previousViewName),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.08,
                MediaQuery.of(context).size.height * 0.02,
                MediaQuery.of(context).size.width * 0.08,
                MediaQuery.of(context).size.height * 0.04,
              ),
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
                          'volver a ${widget.previousViewName.toLowerCase()}',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 32,
                      color: Color(0xFF445467),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  //!Filtros
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        //!Precios
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedPrice,
                              isExpanded: true,
                              items: _prices.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedPrice = newValue;
                                });
                              },
                              hint: const Center(
                                child: Text('Filtro'),
                              ),
                              iconSize: 0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      //!Ordenar por
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedOrder,
                              isExpanded: true,
                              items: _orders.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedOrder = newValue;
                                });
                              },
                              hint: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.arrow_upward, size: 18),
                                  Icon(Icons.arrow_downward, size: 18),
                                ],
                              ),
                              iconSize: 0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  StreamBuilder<QuerySnapshot>(
                    stream: productsRef.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      List<Product> products = snapshot.data!.docs.map((doc) {
                        return Product.fromMap(
                            doc.data() as Map<String, dynamic>, doc.id);
                      }).toList();

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          Product product = products[index];
                          return ItemWidget(
                            product: product,
                            previousViewName: widget.title,
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            CustomFooter(),
          ],
        ),
      ),
    );
  }
}

//!Widget para mostrar los items de las secciones
class ItemWidget extends StatelessWidget {
  final Product product;
  final String previousViewName;

  const ItemWidget({
    super.key,
    required this.product,
    required this.previousViewName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Item(
                  previousViewName: previousViewName,
                  product: product,
                ),
              ),
            );
          },
          child: Center(
            child: Image.network(
              product.imageUrl,
              width: double.infinity,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          product.name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '\$${product.price}',
          style: const TextStyle(
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
