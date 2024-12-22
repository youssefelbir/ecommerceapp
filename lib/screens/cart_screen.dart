import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/models/cart_item.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Panier"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              // Vider le panier
              _clearCart(context);
            },
            tooltip: 'Vider le panier',
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('cart').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
                child: Text('Erreur de chargement des articles'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Votre panier est vide'));
          }

          final cartItems = snapshot.data!.docs.map((doc) {
            return CartItem.fromFirestore(doc);
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: item.imageUrl.isNotEmpty
                      ? Image.network(item.imageUrl,
                          width: 50, height: 50, fit: BoxFit.cover)
                      : const Icon(Icons.image, size: 50),
                  title: Text(
                    item.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(
                    'Taille: ${item.size}',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${item.totalPrice} \$',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                            fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      IconButton(
                        icon: const Icon(Icons.remove_shopping_cart),
                        onPressed: () {
                          _removeItemFromCart(context, item);
                        },
                        color: Colors.red,
                        tooltip: 'Supprimer cet article',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Fonction pour supprimer tous les articles du panier depuis Firestore
  void _clearCart(BuildContext context) async {
    try {
      final cartRef = FirebaseFirestore.instance.collection('cart');
      final cartSnapshot = await cartRef.get();

      if (cartSnapshot.docs.isNotEmpty) {
        for (var doc in cartSnapshot.docs) {
          await doc.reference.delete(); // Supprimer chaque document
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Panier vidé')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Le panier est déjà vide')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la suppression du panier: $e')),
      );
    }
  }

  // Fonction pour supprimer un article du panier
  Future<void> _removeItemFromCart(BuildContext context, CartItem item) async {
    try {
      final cartRef = FirebaseFirestore.instance.collection('cart');
      final cartSnapshot =
          await cartRef.where('title', isEqualTo: item.title).get();

      if (cartSnapshot.docs.isNotEmpty) {
        for (var doc in cartSnapshot.docs) {
          await doc.reference.delete();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Article supprimé du panier')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Article non trouvé dans le panier')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Erreur lors de la suppression de l\'article : $e')),
      );
    }
  }
}
