import 'package:flutter/material.dart';
import 'package:flutter/material.dart'; // N-importiw l-maktaba mte3 Material Design bech nestamlo les widgets (boutons, textes, etc.).

// El widget el ra2isi mte3 l-app (statique ma yetbaddalch)
class MyApp extends StatelessWidget {// StatelessWidget 5ater ma fihch état yetbaddal.tekhdem bl methode build() bech t-affichi l-arbre mte3 les widgets.
  const MyApp({super.key});

  @override
  //pour faire l'arbre des widgets "build"
  Widget build(BuildContext context) {
    return MaterialApp(
      //ce sont des arguments només
      title: "Mon App d'Authentification", // Titre mte3 l-application.
      theme: ThemeData(primarySwatch: Colors.blue), // El couleur el ra2isia mte3 l-app (azra9).
      home: const LoginScreen(), // El écran el louwel eli y-t afficher (écran de connexion).
    );
  }
}

// Écran de connexion (StatefulWidget 5ater fih état yetbaddal kifma l-chargement w l-mot de passe)
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();// Y-3ayt lel classe mte3 l'état (state) mte3 l'écran de connexion.
}

class _LoginScreenState extends State<LoginScreen> {// Classe mte3 l'état (state) mte3 l'écran de connexion. Houni n7otou les variables w les fonctions eli y-baddlou w y-3aytou 3lihom.
  // Contrôleur bech na9rou w n-controlew el texte eli y-ktebo l-user fel champ Email.listener mte3 el champ email.
  final _emailController = TextEditingController();
  
  // Contrôleur bech na9rou w n-controlew el texte eli y-ktebo l-user fel champ Mot de passe.
  final _passwordController = TextEditingController();
  
  // Boolean bech n-verifiw ken l-app t-charger (w9t nenzel 3la "Se connecter").
  bool _isLoading = false;
  
  // Boolean bech n-cacheriw wala n-affichiwiw el mot de passe (true = masqué b les points).
  bool _obscureText = true; 

  // Fonction t-verifii l-format mte3 l'email s7i7 wala la (b Regex).
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Fonction t-executiw w9t l-user nenzel 3la boutoun "Se connecter".
  void _handleLogin() {
    final email = _emailController.text.trim(); // Y-na77i l-espaces el zeyda men l'email.
    final password = _passwordController.text; // Y-jib l-mot de passe.

    // Ken l-email wala l-mot de passe fari8in:
    if (email.isEmpty || password.isEmpty) {
      _showDialog('Erreur', 'Veuillez remplir tous les champs');
      return;
    }
    
    // Ken l-email format mte3o ghalat:
    if (!_isValidEmail(email)) {
      _showDialog('Erreur', 'Veuillez entrer un email valide');
      return;
    }

    // Y-7ot _isLoading b true bech y-affichi el loader (cercle de chargement).
    //setState() est utilisé pour notifier Flutter que l'état du widget a changé et qu'il doit reconstruire l'interface utilisateur. Ici, il met _isLoading à true pour indiquer que le processus de connexion est en cours.
    setState(() => _isLoading = true);

    // N-simuliw connexion mtaé server b délai mte3 2 ثواني.
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return; // Verifiation ken el widget mazal mawjoud fel écran.
      setState(() => _isLoading = false); // Y-na77i el chargement.
      
      // Y-affichi message de succès w y-vider les champs ken nzel 3la OK.
      _showDialog(
        'Succès',
        'Connexion réussie ! Bienvenue ${_emailController.text}',
        onOk: () {
          _emailController.clear();
          _passwordController.clear();
        },
      );
    });
  }

  // Fonction wa7da n-stamlouha bech n-affichiwiw el Boîte de Dialogue (AlertDialog) lel erreur wela succès.
  void _showDialog(String title, String message, {VoidCallback? onOk}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title), // Titre mte3 el boîte (Erreur / Succès).
        content: Text(message), // El message el d5el.
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Y-sekker el boîte.
              onOk?.call(); // Y-executi l'action optionnelle (kif vider les champs).
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Background gris fte7.
      body: SafeArea( // Y-2kked elli l-contenu ma y-jiouch fo9 l-bar mte3 l-téléphone.
        child: Padding(
          padding: const EdgeInsets.all(24.0), // Marge mta3 24 pixel mel kol blassa.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Y-centeri l-3nasir verticalement.
            children: [
              // Titre "Connexion"
              const Text(
                'Connexion',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 40), // Espacement bin el titre w l-champ louwel.
              
              // Champ mte3 l'Email
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress, // Clavier special email.
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'entrez@votre.email',
                  prefixIcon: Icon(Icons.email), // Icône zrafa 3el isar.
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              
              // Champ mte3 Mot de passe
              TextField(
                controller: _passwordController,
                obscureText: _obscureText, // Y-cacher wela y-affichi el mot de passe.
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  hintText: 'Entrez votre mot de passe',
                  prefixIcon: const Icon(Icons.lock), // Icône cadenas 3el isar.
                  
                  // Bouton 3el imin bech y-baddal visibilité l-mot de passe (3in halba / mesdouda)
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText; // Y-9leb el état mel true lel false w el 3aks.
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              
              // Condition ternaire: Ken _isLoading true y-affichi loader, sinon y-affichi el boutoun.
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _handleLogin, // Y-3ayt lel fonction mte3 l-connexion w9t nenzel.
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        child: Text('Se connecter',
                            style: TextStyle(fontSize: 18)),
                      ),
                    ),
              const SizedBox(height: 20),
              
              // Bouton textuel bech y-creer compte (y-affichi SnackBar)
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Fonctionnalité d'inscription à venir !"),
                    ),
                  );
                },
                child: const Text('Créer un compte',
                    style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Y-na77i l-contrôleurs men el mémoire w9t el widget yetna77i bech may-sirch memory leak.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
//statless==> build
//stateful==> classe
//scaffold:liste et les objets 
//TP2: page denregistrement : page de creation de compte w norbet bin boutton sinscrire et la page 
//routage cest comment on fait le lien entre les pages quon en clique 
//named route: cest un nom quon donne a la page w on fait le lien avec ce nom :maintenabilité
// final bch na7mi les arguments

