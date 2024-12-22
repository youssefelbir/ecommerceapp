import 'package:ecommerceapp/screens/home_screen.dart';
import 'package:ecommerceapp/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// Page principale
import 'package:provider/provider.dart';
import 'services/cart_service.dart'; // Assurez-vous d'importer votre CartService

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    // Fournir CartService à toute l'application
    ChangeNotifierProvider(
      create: (context) => CartService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My E-Commerce App',
      theme: ThemeData(
        // Mise à jour avec colorScheme au lieu d'accentColor
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal)
            .copyWith(secondary: Colors.orange), // Couleur secondaire (accent)
        visualDensity: VisualDensity.adaptivePlatformDensity,

        // Mise à jour du texte avec textTheme
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87), // Remplaçant bodyText1
          bodyMedium: TextStyle(color: Colors.black54), // Remplaçant bodyText2
          titleLarge: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black), // Remplaçant headline6
        ),

        // Personnalisation des champs de texte
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
          ),
        ),

        // Boutons
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.teal,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
