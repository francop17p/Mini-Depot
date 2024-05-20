import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'package:proyecto_movil/Managers.dart';
import 'package:proyecto_movil/perfil.dart';
import 'home.dart';
import 'login.dart';
import 'category.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            return badges.Badge(
              badgeContent: Text(
                cartProvider.cartItems.length.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              badgeStyle: badges.BadgeStyle(badgeColor: Colors.blue.shade300),
              badgeAnimation: const badges.BadgeAnimation.fade(
                  animationDuration: Duration(seconds: 1)),
              position: badges.BadgePosition.topEnd(top: -6, end: -3),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Provider.of<CartProvider>(context, listen: false).clearCart();
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
  const CustomDrawer({
    super.key,
  });

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
          //!Icono Loguearse o Perfil
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
                    // Si hay un usuario registrado, ir a la vista perfil
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Perfil(),
                      ),
                    );
                  } else {
                    // Si no hay un usuario registrado, ir a la vista login
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
          const CustomListTile(title: 'Inicio', rutaNavegacion: Home()),
          CustomListTile(
              title: 'Deco', rutaNavegacion: CategoryPage(title: 'DECORACIÓN')),
          CustomListTile(
              title: 'Cocina', rutaNavegacion: CategoryPage(title: 'COCINA')),
          CustomListTile(
              title: 'Recámara',
              rutaNavegacion: CategoryPage(title: 'RECÁMARA')),
          const CustomListTile(title: 'Info', rutaNavegacion: Home()),
          const CustomListTile(title: 'Contacto', rutaNavegacion: Home()),
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                // Si hay un usuario registrado, muestra el botón de cierre de sesión
                return ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Cerrar sesión'),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    // Navega a la página de inicio
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                    );
                    // Muestra un mensaje
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Has cerrado sesión')),
                    );
                  },
                );
              } else {
                // Si no hay un usuario registrado, no muestra nada
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
                        'images/visa.png', // Asegúrate de tener estas imágenes en tu carpeta de assets
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
                    icon: const Icon(Icons.facebook, color: Colors.white),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.facebook, color: Colors.white),
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
          const Text(
            '¡CHATEA CON NOSOTROS!',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
