import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerceapp/screens/home_screen.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailAddressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkUserLoggedIn();
  }

  Future<void> _checkUserLoggedIn() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading =
            true; // Le processus de connexion commence, active le mode chargement
      });

      try {
        // Essayer de se connecter avec l'email et le mot de passe
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailAddressController.text.trim(),
          password: _passwordController.text.trim(),
        );
        // Une fois connecté, naviguer vers l'écran d'accueil
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } on FirebaseAuthException catch (e) {
        // Si une erreur se produit lors de l'authentification, afficher un message d'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Login failed')),
        );
      } finally {
        setState(() {
          _isLoading =
              false; // Désactiver le mode de chargement lorsque la tentative de connexion est terminée
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Retirer le focus du clavier si l'utilisateur tape à l'extérieur des champs de texte
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 110, 20, 110),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 9, 9, 96)),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Please sign in to continue.',
                  style: TextStyle(
                      fontSize: 30, color: Color.fromARGB(255, 11, 44, 85)),
                ),
                const SizedBox(height: 40),
                // Champ email
                TextFormField(
                  controller: _emailAddressController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                // Champ mot de passe
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: TextButton(
                      onPressed: () {
                        // Implémentez la logique pour le mot de passe oublié ici si nécessaire
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Bouton de connexion
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : _login, // Désactive le bouton pendant le chargement
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors
                                  .white) // Afficher un indicateur de chargement pendant la connexion
                          : const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('LOGIN'),
                                SizedBox(width: 5),
                                Icon(Icons.arrow_forward, size: 24.0),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const SizedBox(
          height: 40,
          child: Center(
            child: Text(
              'Powered by Elbir Youssef',
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.black, fontStyle: FontStyle.italic),
            ),
          ),
        ),
      ),
    );
  }
}
