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
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
            child: ListView(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // Deshabilita el scroll en el ListView
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
                const ItemWidget(
                  rutaImagen: 'images/silla.jpg',
                  rutaNavegacion: Item(
                    previousViewName: 'Inicio',
                    rutaImagen: 'images/silla.jpg',
                  ),
                ),
                const ItemWidget(
                  rutaImagen: 'images/silla.jpg',
                  rutaNavegacion: Item(
                    previousViewName: 'Inicio',
                    rutaImagen: 'images/silla.jpg',
                  ),
                ),
                const ItemWidget(
                  rutaImagen: 'images/silla.jpg',
                  rutaNavegacion: Item(
                    previousViewName: 'Inicio',
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
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Título del producto', // Línea para el título del producto
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Precio del producto', // Línea para el precio del producto
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
