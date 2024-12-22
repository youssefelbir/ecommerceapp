import 'package:ecommerceapp/models/cart_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartService extends ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  // Ajouter un article au panier
  Future<void> addItem(CartItem item) async {
    _cartItems.add(item);
    await _saveCartToFirestore(); // Sauvegarde des articles dans Firestore
    notifyListeners(); // Mise à jour de l'UI
  }

  // Supprimer tous les articles du panier
  void clearCart() async {
    _cartItems.clear(); // Efface tous les articles du panier
    await _saveCartToFirestore(); // Sauvegarde les modifications sur Firestore
    notifyListeners(); // Met à jour l'UI
  }

  // Sauvegarder les articles dans Firestore
  Future<void> _saveCartToFirestore() async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(
          'dummyUser'); // Remplacez 'dummyUser' par un ID d'utilisateur si nécessaire
      final cartRef = userRef.collection('cart');

      // Si le panier est vide, on le supprime de Firestore
      if (_cartItems.isEmpty) {
        await cartRef
            .doc('cartId')
            .delete(); // Effacer le panier dans Firestore
      } else {
        // Sinon, on met à jour les articles dans Firestore
        await cartRef.doc('cartId').set({
          'items': _cartItems
              .map((item) => {
                    'title': item.title,
                    'price': item.price,
                    'size': item.size,
                    'imageUrl': item.imageUrl,
                    'quantity': item.quantity,
                  })
              .toList(),
        });
      }
    } catch (e) {
      print('Erreur lors de la sauvegarde du panier dans Firestore: $e');
    }
  }

  // Calculer le prix total
  double get totalPrice {
    double total = 0;
    for (var item in _cartItems) {
      total += item.totalPrice;
    }
    return total;
  }
}
