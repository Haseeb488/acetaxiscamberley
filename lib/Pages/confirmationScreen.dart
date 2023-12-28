import 'package:acetaxiscamberley/Pages/BookTaxi.dart';
import 'package:acetaxiscamberley/Pages/fareCalculator.dart';
import 'package:acetaxiscamberley/Pages/home.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class ConfirmationScreen extends StatefulWidget {
  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward(); // Start the fade-in animation


    // Execute the function after a delay of 2 seconds
    Future.delayed(Duration(seconds: 8), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home (
          ),
        ),
      );
    });

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Lottie.asset(
                    'assets/confirmation.json',
                    repeat: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: FadeAnimatedTextKit(
                    isRepeatingAnimation: false,
                    duration:Duration(seconds: 8),
                    textStyle: TextStyle(
                      color: Colors.amber,
                      fontSize: 18,
                      fontFamily: "Arial Black",
                    ),
                    text: [
                      "Thank you for booking a ride with AceTaxisCamberley. Your request is being processed, and one of our representatives will contact you shortly to confirm the details.",
                    ],
                    textAlign: TextAlign.center,
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
