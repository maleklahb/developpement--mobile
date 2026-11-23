import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true; // Pour masquer/afficher le mot de passe

 
Future<void> _handleLogin() async {
  final String email = _emailController.text.trim();
  final String password = _passwordController.text;

  // Vérifier les champs
  if (email.isEmpty || password.isEmpty) {
    _showErrorDialog('Veuillez remplir tous les champs');
    return;
  }

  // Vérifier le format email
  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
      .hasMatch(email)) {
    _showErrorDialog('Veuillez entrer un email valide');
    return;
  }

  // Afficher le chargement
  setState(() {
    _isLoading = true;
  });

  try {
    // Vérifier les informations dans SQLite
    final bool success =
        await DatabaseHelper.instance.loginUser(
      email,
      password,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (success) {
      // Connexion réussie
      _showSuccessDialog();
    } else {
      // Identifiants incorrects
      _showErrorDialog(
        'Email ou mot de passe incorrect',
      );
    }
  } catch (e) {
    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    _showErrorDialog(
      'Erreur lors de la connexion : $e',
    );
  }
}


  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erreur'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Succès'),
          content: Text(
            'Connexion réussie ! Bienvenue ${_emailController.text.trim()}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _emailController.clear();
                _passwordController.clear();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Méthode pour naviguer vers l'écran d'inscription
  void _navigateToSignUp() {
    Navigator.pushNamed(context, '/signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          // Permet de scroller si le clavier cache des éléments
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo ou icône
                const Icon(Icons.account_circle, size: 80, color: Colors.blue),
                const SizedBox(height: 20),

                // Titre
                const Text(
                  'Connexion',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 40),

                // Champ Email
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'entrez@votre.email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // Champ Mot de passe avec œil pour masquer/afficher
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _handleLogin(),
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    hintText: 'Entrez votre mot de passe',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),

                // Bouton de connexion
                _isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity, // Prend toute la largeur
                        child: ElevatedButton(
                          onPressed: _handleLogin,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              'Se connecter',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 20),

                // Séparateur
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text('Ou'),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 20),

                // Bouton pour s'inscrire
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _navigateToSignUp,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        'Créer un compte',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}