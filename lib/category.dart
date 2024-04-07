import 'package:flutter/material.dart';
import 'package:proyecto_movil/item.dart';
import 'custom_widgets.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key, required this.title});
  final String title;

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final ValueNotifier<int> cartItemCount = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFedeff0),
        //!AppBar
        appBar: CustomAppBar(cartItemCount: cartItemCount),
        //!Menú lateral
        endDrawer: const CustomDrawer(),

        //!Cuerpo
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(50, 4, 50, 50),
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 32,
                    color: Color(0xFF445467),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ItemWidget(
                  rutaImagen: 'images/silla.jpg',
                  rutaNavegacion: Item(
                    previousViewName: widget.title,
                    //!Cambiar por el nombre de la categoría
                    rutaImagen: 'images/silla.jpg',
                  ),
                ),
                ItemWidget(
                  rutaImagen: 'images/silla.jpg',
                  rutaNavegacion: Item(
                    previousViewName: widget.title,
                    rutaImagen: 'images/silla.jpg',
                  ),
                ),
                ItemWidget(
                  rutaImagen: 'images/silla.jpg',
                  rutaNavegacion: Item(
                    previousViewName: widget.title,
                    rutaImagen: 'images/silla.jpg',
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

//!Widget para mostrar los items de las secciones
class ItemWidget extends StatelessWidget {
  final String rutaImagen;
  final Widget rutaNavegacion;

  const ItemWidget(
      {super.key, required this.rutaImagen, required this.rutaNavegacion});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => rutaNavegacion,
              ),
            );
          },
          child: Stack(
            children: [
              Image.asset(
                rutaImagen,
                fit: BoxFit.cover,
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
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Título del producto',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Precio del producto',
            style: TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

// class CategoryPage extends StatefulWidget {
//   const CategoryPage({super.key, required this.title});
//   final String title;

//   @override
//   State<CategoryPage> createState() => _CategoryPageState();
// }

// class _CategoryPageState extends State<CategoryPage> {
//   final ValueNotifier<int> cartItemCount = ValueNotifier<int>(0);
//   late Future<List<Product>> products;

//   @override
//   void initState() {
//     super.initState();
//     products = getProducts();
//   }

//   Future<List<Product>> getProducts() async {
//     var db = DatabaseHelper.instance;
//     List<Map<String, dynamic>> productMaps = await db.queryAllRows();
//     return productMaps
//         .map((productMap) => Product(
//               id: productMap[DatabaseHelper.columnId],
//               title: productMap[DatabaseHelper.columnTitle],
//               image: productMap[DatabaseHelper.columnImage],
//               price: productMap[DatabaseHelper.columnPrice],
//             ))
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFedeff0),
//       appBar: CustomAppBar(cartItemCount: cartItemCount),
//       endDrawer: const CustomDrawer(),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(50, 4, 50, 50),
//           child: FutureBuilder<List<Product>>(
//             future: products,
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 return ListView(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   children: snapshot.data!
//                       .map((product) => ItemWidget(product: product))
//                       .toList(),
//                 );
//               } else if (snapshot.hasError) {
//                 return Text('Error: ${snapshot.error}');
//               } else {
//                 return CircularProgressIndicator();
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// class Product {
//   final int id;
//   final String title;
//   final String image;
//   final double price;

//   Product(
//       {required this.id,
//       required this.title,
//       required this.image,
//       required this.price});
// }

// class ItemWidget extends StatelessWidget {
//   final Product product;

//   const ItemWidget({Key? key, required this.product}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => Item(
//                   previousViewName: 'Inicio',
//                   rutaImagen: product.image,
//                 ),
//               ),
//             );
//           },
//           child: Stack(
//             children: [
//               Image.asset(
//                 product.image,
//                 fit: BoxFit.cover,
//               ),
//               Positioned.fill(
//                 child: Container(
//                   color: Colors.transparent,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 10,
//         ),
//         Align(
//           alignment: Alignment.centerLeft,
//           child: Text(
//             product.title,
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//         ),
//         Align(
//           alignment: Alignment.centerLeft,
//           child: Text(
//             'Precio: ${product.price}',
//             style: TextStyle(fontSize: 16),
//           ),
//         ),
//         const SizedBox(
//           height: 10,
//         ),
//       ],
//     );
//   }
// }
