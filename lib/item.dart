import 'package:flutter/material.dart';
import 'package:proyecto_movil/home.dart';
import 'package:badges/badges.dart' as badges;

class Item extends StatefulWidget {
  final String previousViewName;
  final String rutaImagen;

  const Item({
    super.key,
    required this.previousViewName,
    required this.rutaImagen,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  String selectedColorName = 'Ninguno';
  int cantidad = 1;
  final ValueNotifier<int> cartItemCount = ValueNotifier<int>(0);

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
  void initState() {
    super.initState();
    _cantidadController = TextEditingController(text: '1');
  }

  late TextEditingController _cantidadController;

  @override
  void dispose() {
    _cantidadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFedeff0),
      //!AppBar
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
          //!Botón del carrito
          ValueListenableBuilder<int>(
            valueListenable: cartItemCount,
            builder: (context, count, child) {
              return badges.Badge(
                badgeContent: Text(
                  count.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
                badgeStyle: badges.BadgeStyle(badgeColor: Colors.blue.shade300),
                badgeAnimation: const badges.BadgeAnimation.fade(
                    animationDuration: Duration(seconds: 1)),
                position: badges.BadgePosition.topEnd(top: -6, end: -3),
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    // Acción del botón del carrito
                  },
                ),
              );
            },
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
      //!Menú lateral
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const CircleAvatar(
                radius: 10,
                backgroundColor: Color(0xFF607D82),
                child: Icon(
                  color: Colors.white,
                  Icons.person,
                  size: 15,
                ),
              ),
              title: const Text('Entrar'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const CustomListTile(title: 'Inicio', rutaNavegacion: Home()),
            const CustomListTile(title: 'Deco', rutaNavegacion: Home()),
            const CustomListTile(title: 'Cocina', rutaNavegacion: Home()),
            const CustomListTile(title: 'Recámara', rutaNavegacion: Home()),
            const CustomListTile(title: 'Info', rutaNavegacion: Home()),
            const CustomListTile(title: 'Contacto', rutaNavegacion: Home()),
          ],
        ),
      ),
      //!Cuerpo
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
              //!Muestra los círculos de colores
              Wrap(
                spacing: 10.0, // Espaciado horizontal entre los círculos
                runSpacing: 10.0, // Espaciado vertical entre las filas
                children: colors.map((color) {
                  return CircleItem(
                    color: color,
                    size:
                        20.0, // Ajusta este valor para cambiar el tamaño de los círculos
                    onTap: () {
                      setState(() {
                        selectedColorName = colorNames[color] ?? 'Desconocido';
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 20,
              ),
              //!selector de cantidad
              const Text('Cantidad:'),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 80,
                    child: TextFormField(
                      controller: _cantidadController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 0.0),
                        suffixIcon: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.arrow_drop_up,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    cantidad++;
                                    _cantidadController.text =
                                        cantidad.toString();
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (cantidad > 1) {
                                      cantidad--;
                                      _cantidadController.text =
                                          cantidad.toString();
                                    }
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          cantidad = int.tryParse(value) ?? 1;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              //!Botón de agregar al carrito
              SizedBox(
                width: 220, // Ajusta este valor a lo que necesites
                height: 30, // Ajusta este valor a lo que necesites
                child: ElevatedButton(
                  onPressed: () {
                    cartItemCount.value += cantidad;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF607D82),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                    ),
                  ),
                  child: const Text('Agregar al carrito',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              //!Botón de comprar
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 220, // Ajusta este valor a lo que necesites
                height: 30, // Ajusta este valor a lo que necesites
                child: ElevatedButton(
                  onPressed: () {
                    // Acción del botón
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                    ),
                  ),
                  child: const Text('Realizar compra',
                      style: TextStyle(color: Colors.white)),
                ),
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
