// import 'package:animated_splash_screen/animated_splash_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:nest_f/services/auth/auth_wrapper.dart';

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedSplashScreen(
//       splash: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Lottie.asset(
//             "assets/animations/house.json",
//             width: 200,
//             height: 200,
//             fit: BoxFit.cover,
//           ),
//           const Spacer(), // Ajoute de l’espace flexible entre l’animation et le texte
//           const Text(
//             "Nest F",
//             style: TextStyle(
//               fontSize: 32,
//               fontWeight: FontWeight.bold,
//               color: Colors.blueAccent,
//             ),
//           ),
//           const Spacer(), // Ajoute de l’espace flexible sous le texte
//         ],
//       ),
//       nextScreen: const AuthWrapper(),
//       duration: 3500,
//       backgroundColor: Colors.white,
//       centered: true,
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nest_f/screens/auth/auth_wrapper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 10),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const AuthWrapper())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Lottie.asset(
                'assets/animations/house.json',
                fit: BoxFit.cover,
                width: 400,
                height: 400,
                repeat: true,
              ),
            ),
            // const Center(
            //   child: Text(
            //     "Nest F",
            //     style: TextStyle(
            //         fontSize: 24,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.blueAccent),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
