import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_movil/Managers.dart';
import 'package:proyecto_movil/category.dart';
import 'package:proyecto_movil/registroHelper.dart';
import 'item.dart';
import 'custom_widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'product.dart';
import 'main.dart'; // Asegúrate de importar donde tengas el routeObserver

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with RouteAware {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  final ValueNotifier<int> cartItemCount = ValueNotifier<int>(0);

  Future<Product?> fetchProduct(String category) async {
    var collection = FirebaseFirestore.instance.collection(category);
    var querySnapshot = await collection.limit(1).get();
    if (querySnapshot.docs.isNotEmpty) {
      var doc = querySnapshot.docs.first;
      return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    loadCurrentUser();
    _loadCartItemCount();
  }

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

  void loadCurrentUser() async {
    User? currentUser = auth.currentUser;
    if (currentUser == null) {
      print('No hay usuario logueado');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFedeff0),
      //!AppBar
      appBar: CustomAppBar(cartItemCount: cartItemCount),

      //!Menú lateral
      endDrawer: CustomDrawer(previousViewName: 'Inicio'),
      //!Cuerpo
      body: SingleChildScrollView(
        child: Column(
          children: [
            //!Contenedor con las imágenes
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                children: <Widget>[
                  CarouselSlider(
                    options: CarouselOptions(
                      aspectRatio: 1.5,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 6),
                      viewportFraction: 1.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                    ),
                    items: images.map((image) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Image.asset(
                            image,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                          );
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  //!Contenedor con el ListView
                  ListView(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(), // Deshabilita el scroll en el ListView
                    children: [
                      Container(
                        color: const Color(0xFF80A6AD),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'UNA\nMEZCLA DE\nDISEÑO Y\nCOMODIDAD',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.08,
                                  color: const Color(0xFF203040),
                                ),
                              ),
                              Text(
                                'Crea el espacio \nperfecto',
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.06,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                              const Divider(
                                color: Color(0xFF607d82),
                                thickness: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SectionWidget(
                        texto: 'DECORACIÓN',
                        rutaNavegacion: CategoryPage(
                          title: 'Deco',
                          previousViewName: 'Inicio',
                        ),
                      ),
                      FutureBuilder<Product?>(
                        future: fetchProduct('Deco'),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasData) {
                            Product product = snapshot.data!;
                            return ItemWidget(
                              product: product,
                            );
                          } else {
                            return const Text(
                                'No se encontró producto en la categoría "Deco"');
                          }
                        },
                      ),
                      SectionWidget(
                          texto: 'COCINA',
                          rutaNavegacion: CategoryPage(
                            title: 'Cocina',
                            previousViewName: 'Inicio',
                          )),
                      FutureBuilder<Product?>(
                        future: fetchProduct('Cocina'),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasData) {
                            Product product = snapshot.data!;
                            return ItemWidget(
                              product: product,
                            );
                          } else {
                            return const Text(
                                'No se encontró producto en la categoría "Cocina"');
                          }
                        },
                      ),
                      SectionWidget(
                          texto: 'RECÁMARA',
                          rutaNavegacion: CategoryPage(
                            title: 'Recamara',
                            previousViewName: 'Inicio',
                          )),
                      FutureBuilder<Product?>(
                        future: fetchProduct('Recamara'),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasData) {
                            Product product = snapshot.data!;
                            return ItemWidget(
                              product: product,
                            );
                          } else {
                            return const Text(
                                'No se encontró producto en la categoría "Recamara"');
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            CustomFooter(), // footer
          ],
        ),
      ),
    );
  }
}

//!Widget para mostrar el titulo de las secciones
class SectionWidget extends StatelessWidget {
  final String texto;
  final Widget rutaNavegacion;

  const SectionWidget(
      {super.key, required this.texto, required this.rutaNavegacion});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => rutaNavegacion,
          ),
        );
      },
      child: Column(
        children: [
          Container(
            height: 180,
            padding: const EdgeInsets.all(10),
            color: const Color(0xFF80A6AD),
            child: Center(
              child: Text(
                texto,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width *
                      0.09, // Ajusta este valor para cambiar el tamaño del texto
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

//!Widget para mostrar los items de las secciones
class ItemWidget extends StatelessWidget {
  final Product product;

  const ItemWidget({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Item(
                  previousViewName: 'Inicio',
                  product: product,
                ),
              ),
            );
          },
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height *
                    0.75, // Ajusta este valor para cambiar la altura
                width: MediaQuery.of(context).size.width, //
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            product.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '\$${product.price}',
            style: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

final List<String> images = [
  'images/Macetas.jpg',
  'images/Silla2.jpg',
  'images/Espejo.jpg',
];
