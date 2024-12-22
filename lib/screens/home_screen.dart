import 'package:ecommerceapp/models/cart_item.dart';
import 'package:ecommerceapp/services/cart_service.dart';
import 'package:ecommerceapp/screens/clothing_details_screen.dart';
import 'package:ecommerceapp/screens/profil_screen.dart';
import 'package:ecommerceapp/screens/cart_screen.dart';
import 'package:ecommerceapp/widgets/addclothing_item.dart'; // Importer l'écran d'ajout
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ClothingListScreen(),
    const CartScreen(),
    UserProfileScreen(),
    const AddClothingItemScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("E-Commerce App"),
        backgroundColor: Colors.greenAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddClothingItemScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Acheter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Panier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Ajouter',
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class ClothingListScreen extends StatelessWidget {
  const ClothingListScreen({super.key});

  void addItemToCart(CartItem item, BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('cart').add(item.toMap());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Article ajouté au panier')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de l\'ajout au panier')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection('clothingItems').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Erreur de chargement des données'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Aucun article disponible'));
        }

        final clothingItems = snapshot.data!.docs;

        return GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: clothingItems.length,
          itemBuilder: (context, index) {
            final item = clothingItems[index];
            final title = item['title'] ?? 'Titre manquant';
            final imageUrl = item['imageUrl'] ?? '';
            final size = item['size'] ?? 'Taille non spécifiée';
            final price = item['price'] ??
                '0'; // Valeur par défaut si le prix est manquant
            final brand = item['brand'] ?? 'Marque non spécifiée';
            final category = item['category'] ??
                'Catégorie non spécifiée'; // Récupération de la catégorie

            // Assurez-vous que le prix est un nombre valide
            double parsedPrice = 0.0;
            try {
              parsedPrice = double.parse(price.toString());
            } catch (e) {
              parsedPrice = 0.0; // Si le prix n'est pas valide, mettez à 0
            }

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClothingDetailsScreen(
                      title: title,
                      imageUrl: imageUrl,
                      size: size,
                      price: parsedPrice.toString(),
                      brand: brand,
                      category:
                          category, // Passer la catégorie dans les détails
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                          : const Center(
                              child: Icon(Icons.image, color: Colors.grey),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "Taille: $size",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "Marque: $brand",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("\$$parsedPrice",
                              style: const TextStyle(fontSize: 16)),
                          IconButton(
                            icon: const Icon(Icons.add_shopping_cart),
                            onPressed: () {
                              addItemToCart(
                                CartItem(
                                  title: title,
                                  imageUrl: imageUrl,
                                  price: parsedPrice,
                                  size: size,
                                  quantity: 1,
                                  brand: brand,
                                ),
                                context,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
