import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

//! Widget para crear el appbar
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ValueNotifier<int> cartItemCount;

  const CustomAppBar({super.key, required this.cartItemCount});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
