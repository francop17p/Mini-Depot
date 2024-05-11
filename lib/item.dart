import 'package:flutter/material.dart';
import 'package:proyecto_movil/home.dart';
import 'custom_widgets.dart';
import 'package:photo_view/photo_view.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:proyecto_movil/Managers.dart';
import 'package:provider/provider.dart';

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
  bool _isExpanded = true;
  bool _isExpanded2 = true;

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
        //!AppBar
        appBar: CustomAppBar(cartItemCount: cartItemCount),

        //!Menú lateral
        endDrawer: const CustomDrawer(),
        //!Cuerpo
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.08,
              MediaQuery.of(context).size.height * 0.02,
              MediaQuery.of(context).size.width * 0.08,
              MediaQuery.of(context).size.height * 0.04,
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              //!Volver a la vista anterior
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
              //!Ampliar imagen al hacer clic
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      backgroundColor: Colors.transparent,
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          PhotoView(
                            imageProvider: AssetImage(widget.rutaImagen),
                            backgroundDecoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Center(
                  child: Image.asset(
                    widget.rutaImagen,
                    width: double.infinity,
                  ),
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
                    size: 20.0,
                    onTap: () {
                      setState(() {
                        selectedColorName = colorNames[color] ?? 'Desconocido';
                      });
                    },
                    isSelected: selectedColorName == colorNames[color],
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 20,
              ),
              //!selector de cantidad
              //todo: Esta esta opción con el paquete input_quantity o regresar a el código anterior
              const Text('Cantidad:'),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 80,
                    child: InputQty(
                      decoration: const QtyDecorationProps(
                          qtyStyle: QtyStyle.btnOnRight,
                          orientation: ButtonOrientation.vertical),
                      initVal: cantidad,
                      minVal: 1,
                      onQtyChanged: (value) {
                        setState(() {
                          cantidad = value;
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
                width: double.infinity,
                height: MediaQuery.of(context).size.width * 0.08,
                child: ElevatedButton(
                  onPressed: () {
                    Provider.of<CartProvider>(context, listen: false)
                        .addToCart({
                      'item': 'Título del producto',
                      'cantidad': cantidad,
                      // Agrega más información del artículo si es necesario
                    });
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
                width: double.infinity,
                height: MediaQuery.of(context).size.width * 0.08,
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
              const SizedBox(
                height: 20,
              ),
              //!Descripción
              const Text(
                  'Descripción del producto. Lugar ideal para agregar más información sobre tu producto. A los clientes les gusta saber qué están comprando de antemano.'),
              const SizedBox(
                height: 20,
              ),
              //!Información del producto
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  title: const Text('INFORMACIÓN DEL PRODUCTO'),
                  trailing: Icon(_isExpanded ? Icons.remove : Icons.add),
                  onExpansionChanged: (isExpanded) {
                    setState(() {
                      _isExpanded = isExpanded;
                    });
                  },
                  children: const [
                    ListTile(
                      title: Text(
                        'Detalle del producto. Lugar ideal para agregar más información sobre tu producto como su tamaño, materiales, instrucciones de uso y mantenimiento. También es un buen espacio para explicar lo especial que es tu producto y sus beneficios. A los compradores les gusta saber lo que van a recibir antes de comprarlo, así que proporciona toda la información posible para que puedan comprar con seguridad y confianza.',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //!Política de devolución y reembolso
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  title: const Text('POLÍTICA DE DEVOLUCIÓN Y REEMBOLSO'),
                  trailing: Icon(_isExpanded2 ? Icons.remove : Icons.add),
                  onExpansionChanged: (isExpanded2) {
                    setState(() {
                      _isExpanded2 = isExpanded2;
                    });
                  },
                  children: const [
                    ListTile(
                      title: Text(
                        'Política de devolución y reembolso. Lugar ideal para explicar a tus clientes qué hacer si no están satisfechos con su compra. Tener una política de reembolso o cambio clara es una gran manera de generar confianza y garantizar que tus clientes compren con seguridad.',
                      ),
                    ),
                  ],
                ),
              )
            ]),
          ),
        ));
  }
}

class CircleItem extends StatelessWidget {
  final Color color;
  final double size;
  final VoidCallback onTap;
  final bool isSelected;

  const CircleItem({
    Key? key,
    required this.color,
    required this.size,
    required this.onTap,
    this.isSelected = false,
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
          border: Border.all(
            color: isSelected ? Colors.black : Colors.transparent,
            width: isSelected ? 1.0 : 0.0,
          ),
        ),
      ),
    );
  }
}
