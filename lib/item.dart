import 'package:flutter/material.dart';

class Item extends StatefulWidget {
  final String previousViewName;
  final String rutaImagen;

  const Item({
    Key? key,
    required this.previousViewName,
    required this.rutaImagen,
  }) : super(key: key);

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  String selectedColorName = 'Ninguno';

  final List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    // Agrega más colores aquí
  ];

  final Map<Color, String> colorNames = {
    Colors.red: 'Rojo',
    Colors.green: 'Verde',
    Colors.blue: 'Azul',
    // Agrega más nombres de colores aquí
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFedeff0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'ENPUNTO',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF405357),
            decoration: TextDecoration.underline,
            decorationColor: Color(0xFF405357),
            decorationThickness: 3, // Grosor del subrayado
            letterSpacing: 3,
          ),
        ),
        actions: [
          IconButton(
            color: const Color(0xFF607D82),
            icon: const Icon(Icons.shopping_bag),
            onPressed: () {},
          ),
          Builder(
            builder: (context) => IconButton(
              color: const Color(0xFF607D82),
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    const Icon(Icons.chevron_left),
                    Text(
                      'Volver a ${widget.previousViewName}',
                      style: const TextStyle(fontSize: 17),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Image.asset(
                  widget.rutaImagen,
                  width: 300,
                  height: 300,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'SKU: id',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              ),
              const Text(
                'Titulo del producto',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                '\$Precio.00',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text('Color: $selectedColorName'),
              Wrap(
                spacing: 10.0, // Espaciado horizontal entre los círculos
                runSpacing: 10.0, // Espaciado vertical entre las filas
                children: colors.map((color) {
                  return CircleItem(
                    color: color,
                    size:
                        30.0, // Ajusta este valor para cambiar el tamaño de los círculos
                    onTap: () {
                      setState(() {
                        selectedColorName = colorNames[color] ?? 'Desconocido';
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CircleItem extends StatelessWidget {
  final Color color;
  final double size;
  final VoidCallback onTap;

  const CircleItem({
    Key? key,
    required this.color,
    required this.size,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
