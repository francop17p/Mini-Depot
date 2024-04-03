import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const Home(),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('ENPUNTO ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF405357),
              decoration: TextDecoration.underline,
              decorationColor: Color(0xFF405357),
              decorationThickness: 3, //Grosor del subrayado
              letterSpacing: 3,
            )),
        actions: [
          IconButton(
            color: const Color(0xFF607D82),
            icon: const Icon(
              Icons.shopping_bag,
            ),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            //!Contenedor con las imágenes
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height *
                        0.6, // Ajusta la altura del PageView aquí
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
                          padding: const EdgeInsets.all(10),
                          color: const Color(0xFF80A6AD),
                          child: const Text(
                            'UNA\nMEZCLA DE\nDISEÑO Y\nCOMODIDAD',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF203040),
                            ),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      const SectionWidget(texto: 'DECORACIÓN'),
                      const ItemWidget(
                          rutaImagen: 'images/silla.jpg',
                          rutaNavegacion: Home()),
                      const SectionWidget(texto: 'COCINA'),
                      const ItemWidget(
                          rutaImagen: 'images/cucharas.jpg',
                          rutaNavegacion: Home()),
                      const SectionWidget(texto: 'RECÁMARA'),
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

  const SectionWidget({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}

//!Widget para mostrar las imágenes de los productos
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
  // Agrega más URLs de imágenes si lo deseas
];
