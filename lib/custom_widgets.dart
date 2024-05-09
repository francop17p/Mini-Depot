import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'home.dart';
import 'login.dart';
import 'category.dart';

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
                  // Acción del botón del carrito
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
  const CustomDrawer({super.key});

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
          //!Icono Entrar
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
              //ir a la vista login
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Login(),
                ),
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
