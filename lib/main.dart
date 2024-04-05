import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_movil/category.dart';
import 'package:proyecto_movil/home.dart';
import 'package:proyecto_movil/item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // home: const Item(
        //   previousViewName: 'Inicio',
        //   rutaImagen: 'images/silla.jpg',
        // ));
        home: const CategoryPage(
          title: "DECORACIÓN",
        ));
  }
}
