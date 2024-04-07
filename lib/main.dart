import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_movil/category.dart';
import 'package:proyecto_movil/database.dart';
import 'package:proyecto_movil/home.dart';
import 'package:proyecto_movil/item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //fillDatabase();
  imprimirProductos();

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
      // home: const CategoryPage(
      //   title: "DECORACIÓN",
      // )
      home: const Home(),
    );
  }
}

void fillDatabase() async {
  var db = DatabaseHelper.instance;

  // Producto 1
  Map<String, dynamic> row = {
    DatabaseHelper.columnTitle: 'Silla de madera',
    DatabaseHelper.columnImage: 'images/Silla.jpg',
    DatabaseHelper.columnPrice: 9.99
  };
  await db.insert(row);

  // Producto 2
  row = {
    DatabaseHelper.columnTitle: 'Cuchara de madera',
    DatabaseHelper.columnImage: 'images/Cucharas.jpg',
    DatabaseHelper.columnPrice: 19.99
  };
  await db.insert(row);

  // Producto 3
  row = {
    DatabaseHelper.columnTitle: 'Cojín',
    DatabaseHelper.columnImage: 'images/Cojín.jpg',
    DatabaseHelper.columnPrice: 29.99
  };
  await db.insert(row);

  // ... puedes seguir agregando más productos de la misma manera
}

void imprimirProductos() async {
  var db = DatabaseHelper.instance;
  List<Map<String, dynamic>> allRows = await db.queryAllRows();
  allRows.forEach((row) {
    print(row);
  });
}
