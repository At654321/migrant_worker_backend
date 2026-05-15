import 'package:flutter/material.dart';
import 'dart:async';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;

  late Animation<double> scaleAnimation;

  late Animation<double> opacityAnimation;

  @override
  void initState() {

    super.initState();

    controller = AnimationController(

      vsync: this,

      duration:
      const Duration(seconds: 2),
    );

    scaleAnimation = Tween<double>(

      begin: 0.5,

      end: 1.0,

    ).animate(

      CurvedAnimation(

        parent: controller,

        curve: Curves.elasticOut,
      ),
    );

    opacityAnimation = Tween<double>(

      begin: 0,

      end: 1,

    ).animate(controller);

    controller.forward();

    Timer(

      const Duration(seconds: 4),

          () {

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(

            builder: (context) =>
            const LoginScreen(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {

    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        width: double.infinity,

        decoration: const BoxDecoration(

          gradient: LinearGradient(

            colors: [

              Color(0xFFFF9933),

              Color(0xFFFFFFFF),

              Color(0xFF138808),
            ],

            begin: Alignment.topLeft,

            end: Alignment.bottomRight,
          ),
        ),

        child: Center(

          child: FadeTransition(

            opacity: opacityAnimation,

            child: ScaleTransition(

              scale: scaleAnimation,

              child: Column(

                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [

                  Container(

                    padding:
                    const EdgeInsets.all(25),

                    decoration: BoxDecoration(

                      color: Colors.white,

                      borderRadius:
                      BorderRadius.circular(30),

                      boxShadow: const [

                        BoxShadow(

                          blurRadius: 20,

                          color: Colors.black26,

                          offset: Offset(0, 10),
                        ),
                      ],
                    ),

                    child: const Icon(

                      Icons.engineering,

                      size: 100,

                      color: Colors.orange,
                    ),
                  ),

                  const SizedBox(
                    height: 40,
                  ),

                  const Text(

                    "NAMASTE WORKER 🙏",

                    style: TextStyle(

                      fontSize: 34,

                      fontWeight:
                      FontWeight.bold,

                      color: Colors.black87,

                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  const Text(

                    "Welcome To Migrant Worker App",

                    style: TextStyle(

                      fontSize: 18,

                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(
                    height: 40,
                  ),

                  const CircularProgressIndicator(
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}