import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_movil/category.dart';
import 'package:proyecto_movil/firebase_options.dart';
import 'package:proyecto_movil/home.dart';
import 'package:proyecto_movil/item.dart';
import 'package:proyecto_movil/login.dart';
import 'package:proyecto_movil/passRecovery.dart';
import 'package:proyecto_movil/registro.dart';
import 'package:proyecto_movil/registroHelper.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_movil/Managers.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorObservers: [routeObserver],
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Home());
    // home: CategoryPage(
    //   title: "DECORACIÓN",
    // ));
    //home: const Home());
  }
}
