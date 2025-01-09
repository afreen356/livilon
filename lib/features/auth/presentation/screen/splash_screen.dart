
import 'package:flutter/material.dart';
import 'package:livilon/features/auth/presentation/screen/user_login.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.blueGrey[300]),
        ),
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              // height: size.height * 0.10,
              //   width: size.width * 0.8,
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2)),
              child: Padding(
                padding: const EdgeInsets.only(right: 40),
                child: Image.asset(
                  'assets/sofa/sofa.png',
                  height: double.infinity,
                  width: double.infinity,
                ),
              ),
            ),
          ),
        ),
        const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 80),
              child: Text(
                'At Livilon,\nWe craft custom sofas\ntailored to your style,\nusing high-quality\nmaterials for lasting\ncomfort and beauty',
                style: TextStyle(
                  // fontSize: size.width * 0.046, // Responsive font size
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Positioned Forward Button
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const UserLoginScreen(),
                    ),
                  );
                },
                child: Container(
                  height: 40,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.blueGrey[600],
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
