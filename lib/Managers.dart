import 'package:flutter/foundation.dart';

//!Para manejar al usuario autenticado
class AuthManager {
  static final AuthManager _instance = AuthManager._internal();
  factory AuthManager() => _instance;
  AuthManager._internal();

  Map<String, dynamic>? _currentUser;

  Map<String, dynamic>? get currentUser => _currentUser;

  set currentUser(Map<String, dynamic>? user) {
    _currentUser = user;
  }
}

//!Para manejar el carrito de compras
class CartProvider extends ChangeNotifier {
  List<dynamic> _cartItems = [];

  List<dynamic> get cartItems => _cartItems;

  //!Agrega un item al carrito n cantidad de veces
  void addToCart(dynamic item) {
    int cantidad = item['cantidad'];
    for (var i = 0; i < cantidad; i++) {
      _cartItems.add(item);
    }
    notifyListeners();
  }

  void removeFromCart(dynamic item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  void imprimir() {
    print(_cartItems);
  }
}
