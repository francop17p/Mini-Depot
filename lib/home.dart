import 'package:flutter/material.dart';
import 'item.dart';
import 'custom_widgets.dart';

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

class _HomeState extends State<Home> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  final ValueNotifier<int> cartItemCount = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFedeff0),
      //!AppBar
      appBar: CustomAppBar(cartItemCount: cartItemCount),

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
        child: Column(
          children: [
            //!Contenedor con las imágenes
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.52, // Ajusta la altura del PageView aquí
                    child: Stack(
                      children: <Widget>[
                        PageView.builder(
                          controller: _pageController,
                          itemCount: images.length,
                          onPageChanged: (int page) {
                            setState(() {
                              _currentPage = page;
                            });
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return Image.network(images[index]);
                          },
                        ),
                        if (_currentPage != 0)
                          Positioned(
                            left: 10,
                            top: MediaQuery.of(context).size.height * 0.3 -
                                30, // Ajusta la posición vertical de las flechas
                            child: IconButton(
                              iconSize: 40,
                              color: Colors.white,
                              icon: const Icon(Icons.chevron_left),
                              onPressed: () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              },
                            ),
                          ),
                        if (_currentPage != 2)
                          Positioned(
                            right: 10,
                            top: MediaQuery.of(context).size.height * 0.3 -
                                30, // Ajusta la posición vertical de las flechas
                            child: IconButton(
                              iconSize: 40,
                              color: Colors.white,
                              icon: const Icon(Icons.chevron_right),
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                  //!Contenedor con el ListView
                  ListView(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(), // Deshabilita el scroll en el ListView
                    children: [
                      Container(
                        color: const Color(0xFF80A6AD),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'UNA\nMEZCLA DE\nDISEÑO Y\nCOMODIDAD',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF203040),
                                ),
                              ),
                              Text(
                                'Crea el espacio \nperfecto',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                              Divider(
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
                      const SectionWidget(
                          texto: 'DECORACIÓN', rutaNavegacion: Home()),
                      const ItemWidget(
                        rutaImagen: 'images/silla.jpg',
                        rutaNavegacion: Item(
                          previousViewName: 'Inicio',
                          rutaImagen: 'images/silla.jpg',
                        ),
                      ),
                      const SectionWidget(
                          texto: 'COCINA', rutaNavegacion: Home()),
                      const ItemWidget(
                          rutaImagen: 'images/cucharas.jpg',
                          rutaNavegacion: Home()),
                      const SectionWidget(
                          texto: 'RECÁMARA', rutaNavegacion: Home()),
                      const ItemWidget(
                          rutaImagen: 'images/Cojín.jpg',
                          rutaNavegacion: Home()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//!Widget para mostrar los elementos del menú
class CustomListTile extends StatelessWidget {
  final String title;
  final Widget rutaNavegacion;

  const CustomListTile(
      {super.key, required this.title, required this.rutaNavegacion});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => rutaNavegacion,
          ),
        );
      },
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
                style: const TextStyle(
                  fontSize: 30,
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
                fit: BoxFit
                    .cover, // Ajusta la imagen para cubrir todo el contenedor
              ),
              Positioned.fill(
                child: Container(
                  color: Colors
                      .transparent, // Para que el contenedor sea transparente
                  // Aquí puedes agregar cualquier contenido adicional que necesites
                ),
              ),
            ],
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
  'https://hips.hearstapps.com/hmg-prod/images/plantas-de-interior-resistentes-2-1543351859.jpg',
  'https://hips.hearstapps.com/hmg-prod/images/plantas-de-interior-resistentes-2-1543351859.jpg',
  'https://hips.hearstapps.com/hmg-prod/images/plantas-de-interior-resistentes-2-1543351859.jpg',
  //imagenes para probar el PageView
];
