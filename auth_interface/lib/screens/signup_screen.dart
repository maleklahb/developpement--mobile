
import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Contrôleurs des champs
  final TextEditingController _firstNameController =
      TextEditingController();
  final TextEditingController _lastNameController =
      TextEditingController();
  final TextEditingController _emailController =
      TextEditingController();
  final TextEditingController _passwordController =
      TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Messages d'erreur
  String? _emailError;
  String? _passwordError;
  String? _confirmError;

  static final RegExp _emailRegex =
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  // Validation email en temps réel
  void _validateEmail() {
    final email = _emailController.text.trim();

    setState(() {
      _emailError = email.isNotEmpty &&
              !_emailRegex.hasMatch(email)
          ? 'Email invalide'
          : null;
    });
  }

  // Validation des mots de passe
  void _validatePasswords() {
    final p = _passwordController.text;
    final c = _confirmPasswordController.text;

    setState(() {
      _passwordError =
          p.isNotEmpty && p.length < 6
              ? 'Au moins 6 caractères'
              : null;

      _confirmError = c.isNotEmpty && c != p
          ? 'Les mots de passe ne correspondent pas'
          : null;
    });
  }

  bool get _hasErrors =>
      _emailError != null ||
      _passwordError != null ||
      _confirmError != null;

  // INSCRIPTION AVEC SQLITE
  Future<void> _handleSignUp() async {
    final String firstName =
        _firstNameController.text.trim();

    final String lastName =
        _lastNameController.text.trim();

    final String email =
        _emailController.text.trim();

    final String password =
        _passwordController.text;

    final String confirmPassword =
        _confirmPasswordController.text;

    // 1. Vérifier les champs
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showErrorDialog(
          'Veuillez remplir tous les champs');
      return;
    }

    // 2. Vérifier l'email
    if (!_emailRegex.hasMatch(email)) {
      _showErrorDialog(
          'Veuillez entrer un email valide');
      return;
    }

    // 3. Vérifier la longueur du mot de passe
    if (password.length < 6) {
      _showErrorDialog(
          'Le mot de passe doit contenir au moins 6 caractères');
      return;
    }

    // 4. Vérifier la confirmation
    if (password != confirmPassword) {
      _showErrorDialog(
          'Les mots de passe ne correspondent pas');
      return;
    }

    // 5. Activer le chargement
    setState(() {
      _isLoading = true;
    });

    try {
      // 6. Enregistrer l'utilisateur dans SQLite
      await DatabaseHelper.instance.registerUser(
        firstName,
        lastName,
        email,
        password,
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      // 7. Afficher le succès
      _showSuccessDialog();

    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      // Email déjà utilisé ou autre erreur
      _showErrorDialog(
        'Cet email existe déjà ou une erreur est survenue.',
      );
    }
  }

  // DIALOGUE ERREUR
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Erreur d'inscription"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // DIALOGUE SUCCÈS
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Inscription réussie !'),
          content: Text(
            'Bienvenue ${_firstNameController.text.trim()} ! '
            'Votre compte a été créé avec succès.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToLogin();
              },
              child: const Text('Se connecter'),
            ),
          ],
        );
      },
    );
  }

  // RETOUR À LOGIN
  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text('Créer un compte'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),

            child: Column(
              children: [
                const SizedBox(height: 20),

                // Icône
                const Icon(
                  Icons.person_add,
                  size: 60,
                  color: Colors.blue,
                ),

                const SizedBox(height: 20),

                // Titre
                const Text(
                  'Inscription',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),

                const SizedBox(height: 30),

                // PRÉNOM
                TextField(
                  controller: _firstNameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Prénom',
                    hintText: 'Votre prénom',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),

                const SizedBox(height: 15),

                // NOM
                TextField(
                  controller: _lastNameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Nom',
                    hintText: 'Votre nom',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),

                const SizedBox(height: 15),

                // EMAIL
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => _validateEmail(),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'votre@email.com',
                    prefixIcon: const Icon(Icons.email),
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    errorText: _emailError,
                  ),
                ),

                const SizedBox(height: 15),

                // MOT DE PASSE
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => _validatePasswords(),
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    hintText: 'Au moins 6 caractères',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword =
                              !_obscurePassword;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    errorText: _passwordError,
                  ),
                ),

                const SizedBox(height: 15),

                // CONFIRMATION MOT DE PASSE
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  textInputAction: TextInputAction.done,
                  onChanged: (_) => _validatePasswords(),
                  onSubmitted: (_) => _handleSignUp(),
                  decoration: InputDecoration(
                    labelText: 'Confirmer le mot de passe',
                    hintText: 'Retapez votre mot de passe',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword =
                              !_obscureConfirmPassword;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    errorText: _confirmError,
                  ),
                ),

                const SizedBox(height: 30),

                // BOUTON INSCRIPTION
                _isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _hasErrors
                              ? null
                              : _handleSignUp,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 15,
                            ),
                            child: Text(
                              "S'inscrire",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),

                const SizedBox(height: 20),

                // RETOUR LOGIN
                TextButton(
                  onPressed: _navigateToLogin,
                  child: const Text(
                    'Déjà un compte ? Se connecter',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
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

  // LIBÉRER LES CONTRÔLEURS
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }
}
