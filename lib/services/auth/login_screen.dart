import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animate_do/animate_do.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onShowRegister;
  final VoidCallback onForgotPassword;

  const LoginScreen({
    super.key,
    required this.onShowRegister,
    required this.onForgotPassword,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Future<void> _login() async {
  //   if (!_formKey.currentState!.validate()) return;

  //   setState(() => _isLoading = true);

  //   try {
  //     String email = _loginController.text;

  //     // Vérifier si l'utilisateur a entré un username plutôt qu'un email
  //     if (!email.contains('@')) {
  //       // Chercher l'email correspondant au username
  //       final userDoc = await FirebaseFirestore.instance
  //           .collection('users')
  //           .where('username', isEqualTo: _loginController.text.toLowerCase())
  //           .limit(1)
  //           .get();

  //       if (userDoc.docs.isEmpty) {
  //         throw FirebaseAuthException(
  //           code: 'user-not-found',
  //           message: "Nom d'utilisateur non trouvé",
  //         );
  //       }

  //       email = userDoc.docs.first.get('email');
  //     }

  //     // Connexion avec email/password
  //     final userCredential =
  //         await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: email,
  //       password: _passwordController.text,
  //     );

  //     // Vérifier le type d'utilisateur
  //     final userDoc = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userCredential.user!.uid)
  //         .get();

  //     if (userDoc.exists) {
  //       final userType = userDoc.data()?['role'];
  //       if (userType != 'client') {
  //         // Déconnecter l'utilisateur s'il n'est pas un client
  //         await FirebaseAuth.instance.signOut();
  //         throw Exception(
  //             'Ce compte n\'est pas autorisé sur l\'application mobile');
  //       }
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     setState(() => _isLoading = false);
  //     String message = "Une erreur est survenue";

  //     if (e.code == 'user-not-found') {
  //       message = 'Aucun utilisateur trouvé avec ces identifiants';
  //     } else if (e.code == 'wrong-password') {
  //       message = 'Mot de passe incorrect';
  //     }

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(message)),
  //     );
  //   } catch (e) {
  //     setState(() => _isLoading = false);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(e.toString())),
  //     );
  //   }
  // }
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      String email = _loginController.text;
      // Vérifier si l'utilisateur a entré un username plutôt qu'un email
      if (!email.contains('@')) {
        // Chercher l'email correspondant au username
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: _loginController.text.toLowerCase())
            .limit(1)
            .get();
        if (userDoc.docs.isEmpty) {
          throw FirebaseAuthException(
            code: 'user-not-found',
            message: "Nom d'utilisateur non trouvé",
          );
        }
        email = userDoc.docs.first.get('email');
      }
      // Vérifier le type d'utilisateur avant la connexion
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      if (userDoc.docs.isNotEmpty) {
        final userType = userDoc.docs.first.data()['role'];
        if (userType != 'client') {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Ce compte n\'est pas autorisé sur l\'application mobile'),
              backgroundColor: Colors.red,
            ),
          );
          return;
          // throw Exception(
          //     'Ce compte n\'est pas autorisé sur l\'application mobile');
        }
      }
      // Connexion avec email/password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      String message = "Une erreur est survenue";
      if (e.code == 'invalid-credential') {
        message = "Email ou mot de passe incorrect !";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: TextButton(
        onPressed: widget.onForgotPassword,
        child: const Text('Mot de passe oublié ?'),
      ),
    );
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 100),
                FadeInDown(
                  duration: const Duration(milliseconds: 800),
                  child: Image.asset(
                    'assets/images/house.png',
                    height: 120,
                  ),
                ),
                const SizedBox(height: 48),
                FadeInLeft(
                  duration: const Duration(milliseconds: 800),
                  child: Text(
                    'Connexion',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                FadeInUp(
                  duration: const Duration(milliseconds: 800),
                  child: TextFormField(
                    controller: _loginController,
                    decoration: InputDecoration(
                      labelText: "Email ou nom d'utilisateur",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez entrer votre email ou nom d'utilisateur";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                FadeInUp(
                  duration: const Duration(milliseconds: 800),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre mot de passe';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 24),
                FadeInUp(
                  duration: const Duration(milliseconds: 800),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Se connecter'),
                  ),
                ),
                const SizedBox(height: 16),
                FadeInUp(
                  duration: const Duration(milliseconds: 800),
                  child: TextButton(
                    onPressed: widget.onShowRegister,
                    child: const Text("Pas encore de compte ? S'inscrire"),
                  ),
                ),
                const SizedBox(height: 16),
                FadeInUp(
                  duration: const Duration(milliseconds: 800),
                  child: TextButton(
                    onPressed: widget.onForgotPassword,
                    child: const Text('Mot de passe oublié ?'),
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
