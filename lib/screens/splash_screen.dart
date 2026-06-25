import 'package:flutter/material.dart';
import 'dart:async';
import 'language_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the next screen after a delay
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LanguageSelectionScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    const Color darkBg = Color(0xFF355456);
    const Color greenAccent = Color(0xFF29A887);
    const Color peachColor = Color(0xFFFBE0D0);
    const Color darkText = Color(0xFF224345);

    return Scaffold(
      backgroundColor: darkBg,
      body: Column(
        children: [
          // Top Illustration Section
          Expanded(
            flex: 75,
            child: Stack(
              children: [
                // Abstract shape top left (circle + line)
                Positioned(
                  top: 20,
                  left: -20,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: greenAccent, width: 15),
                    ),
                  ),
                ),
                Positioned(
                  top: 80,
                  left: 20,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: greenAccent,
                    ),
                  ),
                ),

                // Plus sign
                const Positioned(
                  top: 150,
                  left: 60,
                  child: Icon(
                    Icons.add,
                    color: greenAccent,
                    size: 60,
                    weight: 800,
                  ),
                ),

                // Heart
                const Positioned(
                  top: 280,
                  left: 40,
                  child: Icon(
                    Icons.favorite,
                    color: greenAccent,
                    size: 100,
                  ),
                ),

                // Main Face shape (Peach)
                Positioned(
                  top: 200,
                  right: -30,
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: const BoxDecoration(
                      color: peachColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(80),
                        bottomLeft: Radius.circular(40),
                      ),
                    ),
                  ),
                ),

                // Hair / Cap (Green Circle)
                Positioned(
                  top: 90,
                  right: 50,
                  child: Container(
                    width: 240,
                    height: 240,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: greenAccent,
                    ),
                  ),
                ),
                
                // Hair accessories (top right)
                Positioned(
                  top: 70,
                  right: 40,
                  child: Transform.rotate(
                    angle: 0.5,
                    child: Container(
                      width: 40,
                      height: 40,
                      color: peachColor,
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  right: 80,
                  child: Container(
                    width: 30,
                    height: 40,
                    color: peachColor,
                  ),
                ),

                // Eye
                Positioned(
                  top: 270,
                  right: 120,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      width: 15,
                      height: 15,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: greenAccent,
                      ),
                    ),
                  ),
                ),

                // Bottom arched shape
                Positioned(
                  bottom: -20,
                  right: 60,
                  child: Container(
                    width: 100,
                    height: 120,
                    decoration: const BoxDecoration(
                      color: peachColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
                    ),
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: greenAccent,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom White Section
          Expanded(
            flex: 25,
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Custom Outlined Plus Logo
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 30,
                              height: 10,
                              decoration: BoxDecoration(
                                border: Border.all(color: greenAccent, width: 2),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            Container(
                              width: 10,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: greenAccent, width: 2),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            // Cover the middle intersection to make it hollow
                            Container(
                              width: 6,
                              height: 6,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      const Text(
                        'Medcare',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: darkText,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
