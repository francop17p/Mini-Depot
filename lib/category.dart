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
  String? _selectedOrder;
  final List<String> _prices = [
    'Todos',
    'Menor a \$500',
    '\$500 - \$1000',
    'Mayor a \$1000'
  ]; // Lista de precios

  final List<String> _orders = [
    'Ordenar por',
    'Lo mas nuevo',
    'Precio (de menor a mayor)',
    'Precio (de mayor a menor)',
    'Nombre de A-Z',
    'Nombre Z-A'
  ];

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
      ),
    );
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
