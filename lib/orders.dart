import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'custom_widgets.dart';

class OrdersPage extends StatefulWidget {
  final String previousViewName;

  const OrdersPage({super.key, required this.previousViewName});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final ValueNotifier<int> cartItemCount = ValueNotifier<int>(0);

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
  void initState() {
    super.initState();
    _loadCartItemCount();
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      _fetchOrders() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      CollectionReference<Map<String, dynamic>> ordersRef = FirebaseFirestore
          .instance
          .collection('Usuarios')
          .doc(user.uid)
          .collection('orders');
      QuerySnapshot<Map<String, dynamic>> ordersSnapshot =
          await ordersRef.get();
      return ordersSnapshot.docs;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(cartItemCount: cartItemCount),
      endDrawer: CustomDrawer(previousViewName: 'Pedidos'),
      body: FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
        future: _fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay pedidos realizados'));
          }

          List<QueryDocumentSnapshot<Map<String, dynamic>>> orders =
              snapshot.data!;
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
                        'Mis pedidos',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          var order = orders[index];
                          var orderData = order.data();
                          var orderItems = List<Map<String, dynamic>>.from(
                              orderData['items']);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pedido ${index + 1}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: orderItems.length,
                                itemBuilder: (context, itemIndex) {
                                  var item = orderItems[itemIndex];
                                  return ListTile(
                                    title: Text(item['name']),
                                    subtitle:
                                        Text('Cantidad: ${item['cantidad']}'),
                                    trailing: Text(
                                        '\$${(item['price'] as num) * (item['cantidad'] as int)}'),
                                  );
                                },
                              ),
                              const Divider(),
                            ],
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
          );
        },
      ),
    );
  }
}
