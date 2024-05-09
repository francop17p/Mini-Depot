import 'package:flutter/material.dart';
import 'package:proyecto_movil/item.dart';
import 'custom_widgets.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({super.key, required this.title});
  final String title;

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final ValueNotifier<int> cartItemCount = ValueNotifier<int>(0);
  String? _selectedPrice;

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
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Text('Filtrar por precio:'),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Filtrar por precio'),
                                content: DropdownButton<String>(
                                  value: _selectedPrice,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedPrice = newValue;
                                    });
                                  },
                                  items: <String>[
                                    'Todos',
                                    'Menor a \$500',
                                    '\$500 - \$1000',
                                    'Mayor a \$1000'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text('Seleccionar'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                ItemWidget(
                  rutaImagen: 'images/Silla.jpg',
                  rutaNavegacion: Item(
                    previousViewName: widget.title,
                    //!Cambiar por el nombre de la categoría
                    rutaImagen: 'images/Silla.jpg',
                  ),
                ),
                ItemWidget(
                  rutaImagen: 'images/Silla.jpg',
                  rutaNavegacion: Item(
                    previousViewName: widget.title,
                    rutaImagen: 'images/silla.jpg',
                  ),
                ),
                ItemWidget(
                  rutaImagen: 'images/Silla.jpg',
                  rutaNavegacion: Item(
                    previousViewName: widget.title,
                    rutaImagen: 'images/Silla.jpg',
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
              SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.75, // Ajusta este valor para cambiar la altura
                width: MediaQuery.of(context).size.width, //
                child: Image.asset(
                  rutaImagen,
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
