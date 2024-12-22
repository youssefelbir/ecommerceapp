import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddClothingItemScreen extends StatefulWidget {
  const AddClothingItemScreen({super.key});

  @override
  _AddClothingItemScreenState createState() => _AddClothingItemScreenState();
}

class _AddClothingItemScreenState extends State<AddClothingItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _imageLinkController =
      TextEditingController(); // Controller for the image link
  String _detectedCategory = "Unknown";

  // Fonction pour ajouter l'article dans Firestore
  Future<void> _addItem() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Vérifier si l'URL de l'image est fournie
        String imageUrl = _imageLinkController.text.trim();
        if (imageUrl.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Veuillez entrer un lien d'image.")),
          );
          return;
        }

        // Ajouter l'article dans Firestore
        await FirebaseFirestore.instance.collection('clothingItems').add({
          'title': imageUrl, // L'URL de l'image est ajoutée comme titre
          'category': _detectedCategory,
          'brand': _brandController.text,
          'size': _sizeController.text,
          'price': double.parse(_priceController.text),
          'imageUrl': imageUrl, // Ajouter l'URL de l'image
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vêtement ajouté avec succès !")),
        );

        // Réinitialiser le formulaire et l'état
        _formKey.currentState!.reset();
        setState(() {
          _imageLinkController.clear();
          _detectedCategory = "Unknown";
        });
      } catch (e) {
        print("Erreur lors de l'ajout de l'article : $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors de l'ajout du vêtement.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Veuillez remplir tous les champs correctement.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un Vêtement"),
        backgroundColor: Colors.greenAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Champ de texte pour le titre
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Titre',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un titre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Champ de texte pour la taille
                TextFormField(
                  controller: _sizeController,
                  decoration: InputDecoration(
                    labelText: 'Taille',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une taille';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Champ de texte pour le prix
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Prix',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un prix';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Veuillez entrer un prix valide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Champ de texte pour la marque
                TextFormField(
                  controller: _brandController,
                  decoration: InputDecoration(
                    labelText: 'Marque',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une marque';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // DropdownButton pour la catégorie
                DropdownButton<String>(
                  value: _detectedCategory,
                  onChanged: (String? newValue) {
                    setState(() {
                      _detectedCategory = newValue!;
                    });
                  },
                  items: <String>[
                    'Unknown',
                    'T-shirt',
                    'Pantalon',
                    'Veste',
                    'Accessoire'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16.0),

                // Champ de texte pour entrer le lien de l'image
                TextFormField(
                  controller: _imageLinkController,
                  decoration: InputDecoration(
                    labelText: 'Lien de l\'image',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un lien d\'image';
                    }
                    if (!Uri.parse(value).isAbsolute) {
                      return 'Veuillez entrer un lien valide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Bouton pour ajouter l'article
                Center(
                  child: ElevatedButton(
                    onPressed: _addItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Ajouter le Vêtement"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
