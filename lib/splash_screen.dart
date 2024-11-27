import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon/Image
          const Center(
            child: Icon(
              Icons.star,
              color: Colors.white,
              size: 100,
            ),
          ),
          const SizedBox(height: 40),

          // Title
          const Text(
            "Explore the app",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),

          // Subtitle
          const Text(
            "Now your Tunisian stock markets are in one place\nand always under control",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 40),

          // Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              children: [
                // Login Button
                TextButton(
                  onPressed: () {
                    // Navigate to Login Page
                    Navigator.pushNamed(context, '/login');
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text("Login"),
                ),
                const SizedBox(height: 10),

                // Sign-Up Button
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Sign-Up Page
                    Navigator.pushNamed(context, '/signup');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5A4FF3), // Purple color
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text("Sign Up"),
                ),
                const SizedBox(height: 20),

                // Browse as Guest Button
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Home Page as Guest
                    Navigator.pushNamed(context, '/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 183, 79, 243), // Green accent
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text("Browse as Guest"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
