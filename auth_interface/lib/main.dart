import 'package:flutter/material.dart';

// Import des écrans depuis le dossier screens
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';

// Point de départ de l'application
void main() {
  runApp(const MyApp());
}

// Widget principal (StatelessWidget : pas d'état qui change)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Mon App d'Authentification",
      theme: ThemeData(primarySwatch: Colors.blue),

      // Named routes : un nom pour chaque page (meilleure maintenabilité)
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
      },

      // Page affichée au démarrage.
      // Ne pas utiliser `home` en même temps que la route '/'.
      initialRoute: '/login',
    );
  }
}
//statless==> build
//stateful==> classe
//scaffold:liste et les objets 
//TP2: page denregistrement : page de creation de compte w norbet bin boutton sinscrire et la page 
//routage cest comment on fait le lien entre les pages quon en clique 
//named route: cest un nom quon donne a la page w on fait le lien avec ce nom :maintenabilité
// final bch na7mi les arguments
