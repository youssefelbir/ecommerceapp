import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  double get totalAmount {
    double total = 0.0;
    for (var item in _cartItems) {
      total +=
          item.totalPrice; // Utiliser la méthode totalPrice pour chaque article
    }
    return total;
  }

  void addItem(CartItem item) {
    final existingIndex = _cartItems.indexWhere(
        (prod) => prod.title == item.title && prod.size == item.size);
    if (existingIndex >= 0) {
      // Si l'élément existe déjà, augmentez la quantité ou ajustez le prix
      _cartItems[existingIndex].price += item.price;
    } else {
      _cartItems.add(item);
    }
    notifyListeners(); // Notifie les écouteurs pour actualiser l'UI
  }

  void removeItem(CartItem item) {
    _cartItems.remove(item);
    notifyListeners(); // Notifie les écouteurs après suppression
  }

  void clear() {
    _cartItems.clear();
    notifyListeners(); // Notifie les écouteurs après réinitialisation du panier
  }
}
