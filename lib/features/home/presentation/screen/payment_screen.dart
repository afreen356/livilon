import 'package:flutter/material.dart';
import 'package:livilon/features/home/presentation/screen/dimension_screen.dart';
import 'package:livilon/features/home/presentation/screen/home_screen.dart';
import 'package:lottie/lottie.dart';

class PaymentSuccess extends StatelessWidget {
  const PaymentSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                Lottie.network(
                  'https://lottie.host/5c09846e-0f86-4fd2-8e0f-df3e0d780015/bAGmD18dit.json',
                  height: 250,
                  width: 350),
                   const Text('Successfully ordered',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
              ],
            ),
          ),
         const SizedBox(height: 20,),
         
           Container(
                    width: 200,
                    decoration: BoxDecoration(
                        color: getButtonColor(),
                        borderRadius: BorderRadius.circular(2)),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (Route<dynamic> route) => false,
                );
                      },
                      child: const Text(
                        "Continue Shopping",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
        ],
      ),
    );
  }
}
