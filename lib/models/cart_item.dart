import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String title;
  double price;
  final String size;
  final int quantity; // Vous pouvez ajouter une quantité si nécessaire
  final String imageUrl;
  final String brand; // Ajout de la marque

  CartItem({
    required this.title,
    required this.price,
    required this.size,
    this.quantity = 1, // Valeur par défaut de la quantité
    required this.imageUrl,
    required this.brand, // Ajout du paramètre brand
  });

  // Getter pour le prix total
  double get totalPrice {
    return price * quantity; // Calcul du prix total en fonction de la quantité
  }

  // Créer un CartItem à partir des données Firestore
  factory CartItem.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data()
        as Map<String, dynamic>; // Récupérer les données du document Firestore

    final title =
        data['title'] ?? 'Titre manquant'; // Valeur par défaut si manquante
    final price = (data['price'] is num)
        ? (data['price'] as num).toDouble()
        : 0.0; // Vérifier et convertir le prix
    final size = data['size'] ?? 'Taille non spécifiée'; // Valeur par défaut
    final quantity = data['quantity'] ?? 1; // Valeur par défaut
    final imageUrl = data['imageUrl'] ?? ''; // Valeur par défaut si manquante
    final brand = data['brand'] ?? 'Marque non spécifiée'; // Ajout de la marque

    return CartItem(
      title: title,
      price: price,
      size: size,
      quantity: quantity,
      imageUrl: imageUrl,
      brand: brand, // Ajout du paramètre brand
    );
  }

  // Méthode pour convertir l'objet CartItem en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'size': size,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'brand': brand, // Ajout du paramètre brand
    };
  }
}
