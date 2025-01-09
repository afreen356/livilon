import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:livilon/features/auth/presentation/screen/splash_screen.dart';
import 'package:livilon/features/home/presentation/screen/home_screen.dart';

class LogoScreen extends StatefulWidget {
  const LogoScreen({super.key});

  @override
  State<LogoScreen> createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation animation;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    animation = Tween(begin: 0.0, end: 1.0).animate(animationController)
      ..addListener(() {
        setState(() {});
      });

    navigateBasedOnSignInStatus(context);

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        // Background with gradient and a classy overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blueGrey.shade400,
                Colors.blueGrey.shade300,
                Colors.blueGrey.shade200,
              ],
            ),
          ),
          child: Center(
            child: ShaderMask(
              child: const Text(
                'Livilon',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              shaderCallback: (rect) {
                return LinearGradient(stops: [
                  animation.value - 0.5,
                  animation.value,
                  animation.value + 0.5
                ], colors: [
                  Colors.white,
                  Colors.lightBlueAccent.shade200,
                  //  Colors.tealAccent.shade200,

                  Colors.cyanAccent.shade400,
                ]).createShader(rect);
              },
            ),
          ),
        ),
      ]),
    );
  }

  Future<bool> isUserSignedIn() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return true;
    }

    return false;
  }

  Future<void> navigateBasedOnSignInStatus(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));
    bool isSignedIn = await isUserSignedIn();
    if (isSignedIn) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SplashScreen()));
    }
  }
}
