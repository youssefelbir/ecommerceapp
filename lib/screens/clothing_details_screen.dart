import 'package:flutter/material.dart';

class ClothingDetailsScreen extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String size;
  final String price;
  final String brand; // Ajout du champ brand
  final String category; // Ajout du champ category

  const ClothingDetailsScreen({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.size,
    required this.price,
    required this.brand, // Ajout du paramètre brand dans le constructeur
    required this.category, // Ajout du paramètre category dans le constructeur
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.greenAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              color:
                  Colors.grey[200], // Ajout d'une couleur de fond pour l'image
              padding: const EdgeInsets.all(16),
              child: Image.network(imageUrl, width: 200, height: 200),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color:
                    Colors.lightGreen[100], // Fond pour le détail de l'article
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Taille: $size", style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text(
                    "Prix: $price \$",
                    style: const TextStyle(fontSize: 18, color: Colors.green),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Marque: $brand",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Catégorie: $category", // Affichage de la catégorie
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Description détaillée de l'article : \nCette article est fabriqué avec des matériaux de haute qualité, offrant un confort optimal et une durabilité exceptionnelle. Il est idéal pour toutes les occasions, que ce soit pour une sortie décontractée ou une soirée plus formelle. La coupe moderne et la couleur tendance s'harmonisent parfaitement avec toutes les tenues.",
                    style: TextStyle(
                        fontSize: 16, color: Colors.black.withOpacity(0.7)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
