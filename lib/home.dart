import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    // Rutas de navegación
    routes: {
      '/home': (context) => const Home(),
    },
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
            const CustomListTile(title: 'Inicio', route: '/home'),
            const CustomListTile(title: 'Deco', route: '/home'),
            const CustomListTile(title: 'Cocina', route: '/home'),
            const CustomListTile(title: 'Recámara', route: '/home'),
            const CustomListTile(title: 'Info', route: '/home'),
            const CustomListTile(title: 'Contacto', route: '/home'),
          ],
        ),
      ),
      body: const Center(
        child: Text('Contenido de la aplicación'),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String title;
  final String route;

  const CustomListTile({super.key, required this.title, required this.route});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }
}
