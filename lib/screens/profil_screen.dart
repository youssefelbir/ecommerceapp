import 'package:ecommerceapp/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // TextEditingController for the form fields
  final TextEditingController _anniversaireController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();
  final TextEditingController _codePostalController = TextEditingController();
  final TextEditingController _villeController = TextEditingController();

  bool _isLoading = true;

  // Function to update user data in Firebase
  Future<void> _updateUserData() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Add the user information to the "users" collection
        await FirebaseFirestore.instance.collection('users').add({
          'dateAnniversaire': _anniversaireController.text,
          'adresse': _adresseController.text,
          'codePostal': _codePostalController.text,
          'ville': _villeController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Les informations ont été ajoutées avec succès !')),
        );
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors de la mise à jour : $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil utilisateur"),
        backgroundColor: Colors.greenAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Build profile card for "Date d'anniversaire"
              _buildProfileCard("Date d'anniversaire", _anniversaireController),
              const SizedBox(height: 16),

              // Build profile card for "Adresse"
              _buildProfileCard("Adresse", _adresseController),
              const SizedBox(height: 16),

              // Build profile card for "Code Postal" with validation
              _buildProfileCard(
                "Code Postal",
                _codePostalController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length != 5) {
                    return 'Code postal invalide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Build profile card for "Ville"
              _buildProfileCard("Ville", _villeController),
              const SizedBox(height: 20),

              // Build action buttons
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  // Custom widget to build a profile card
  Widget _buildProfileCard(
    String label,
    TextEditingController controller, {
    bool readOnly = false,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          controller: controller,
          readOnly: readOnly,
          obscureText: isPassword,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  // Widget for action buttons (Add and Logout)
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: _updateUserData,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "Ajouter",
            style: TextStyle(fontSize: 16),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "Se déconnecter",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
