import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'package:proyecto_movil/Managers.dart';
import 'package:proyecto_movil/contact.dart';
import 'package:proyecto_movil/perfil.dart';
import 'home.dart';
import 'login.dart';
import 'category.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'info.dart';
import 'cart.dart';
import 'contact.dart';
import 'orders.dart';

FirebaseAuth auth = FirebaseAuth.instance;

//! Widget para crear el appbar
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ValueNotifier<int> cartItemCount;

  const CustomAppBar({super.key, required this.cartItemCount});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: const Text(
        'MiniDepot',
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartPage(
                        previousViewName: 'Carrito',
                      ),
                    ),
                  ); // Navegar al carrito
                },
              ),
            );
          },
        ),
        //!Botón del menú
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
    );
  }
}

//! Widget para crear el menú lateral
class CustomDrawer extends StatelessWidget {
  final String previousViewName;

  const CustomDrawer({super.key, required this.previousViewName});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
              return ListTile(
                leading: const CircleAvatar(
                  radius: 10,
                  backgroundColor: Color(0xFF607D82),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
                title: Text(snapshot.hasData && snapshot.data != null
                    ? 'Perfil'
                    : 'Login'),
                onTap: () {
                  if (snapshot.hasData && snapshot.data != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Perfil(),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ),
                    );
                  }
                },
              );
            },
          ),
          CustomListTile(
            title: 'Inicio',
            rutaNavegacion: Home(),
            previousViewName: previousViewName,
          ),
          CustomListTile(
            title: 'Deco',
            rutaNavegacion:
                CategoryPage(title: 'Deco', previousViewName: previousViewName),
            previousViewName: previousViewName,
          ),
          CustomListTile(
            title: 'Cocina',
            rutaNavegacion: CategoryPage(
                title: 'Cocina', previousViewName: previousViewName),
            previousViewName: previousViewName,
          ),
          CustomListTile(
            title: 'Recámara',
            rutaNavegacion: CategoryPage(
                title: 'Recamara', previousViewName: previousViewName),
            previousViewName: previousViewName,
          ),
          CustomListTile(
            title: 'Info',
            rutaNavegacion: InfoPage(previousViewName: previousViewName),
            previousViewName: previousViewName,
          ),
          CustomListTile(
            title: 'Contacto',
            rutaNavegacion: ContactPage(previousViewName: previousViewName),
            previousViewName: previousViewName,
          ),
          CustomListTile(
            title: 'Pedidos',
            rutaNavegacion: OrdersPage(previousViewName: previousViewName),
            previousViewName: previousViewName,
          ),
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Cerrar sesión'),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Has cerrado sesión')),
                    );
                  },
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}

//! Widget para crear los elementos de la lista del menú lateral
class CustomListTile extends StatelessWidget {
  final String title;
  final Widget rutaNavegacion;
  final String previousViewName;

  const CustomListTile({
    super.key,
    required this.title,
    required this.rutaNavegacion,
    required this.previousViewName,
  });

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

class CustomFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: const Color(0xFF607D82),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Contáctanos',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '1-800-000-0000',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'info@misitio.com',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Aceptamos',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Image.asset(
                        'images/visa.png',
                        height: 30,
                      ),
                      SizedBox(width: 8),
                      Image.asset(
                        'images/paypal.png',
                        height: 30,
                      ),
                      SizedBox(width: 8),
                      Image.asset(
                        'images/amex.png',
                        height: 30,
                      ),
                      SizedBox(width: 8),
                      Image.asset(
                        'images/mastercard.png',
                        height: 30,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.facebook, color: Colors.white),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.twitter,
                        color: Colors.white), // Icono de Twitter
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.pinterest,
                        color: Colors.white), // Icono de Pinterest
                    onPressed: () {},
                  ),
                ],
              ),
              const Text(
                'Política de Privacidad',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Nueva sección de suscripción
          const Text(
            'Únete a nuestra lista de correo',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Ingresa tu email aquí',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  iconColor: const Color(0xFF405357),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                ),
                child: const Text('Suscríbete'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            '¡CHATEA CON NOSOTROS!',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
