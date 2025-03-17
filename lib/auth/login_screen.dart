import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import '../auth/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  final AuthService _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/backgrounds/background.gif",
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Taskun",
                  style: TextStyle(
                    fontFamily: 'PixelFont',
                    fontSize: 48,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.7),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          labelText: "Username",
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Password Input
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.7),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          labelText: "Password",
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 10),
                      // Forgot Password & Sign Up Links
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text("Forgot Password?", style: TextStyle(color: Colors.white)),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SignupScreen()),
                              );
                            },
                            child: const Text("Create Account", style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Log In Button
                      ElevatedButton(
                        onPressed: () async {
                          User? user = await _auth.signIn(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                          );
                          if (user != null) {
                            DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
                            if (userDoc.exists && userDoc.data() != null) {
                              var userData = userDoc.data() as Map<String, dynamic>?;

                              if (userData != null && userData['character'] != null) {
                                Navigator.pushReplacementNamed(context, '/home');
                              } else {
                                Navigator.pushReplacementNamed(context, '/character-selection');
                              }
                            } else {
                              Navigator.pushReplacementNamed(context, '/character-selection');
                            }

                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Login failed. Please try again.")),
                            );
                          }
                        },
                        child: const Text('Login'),
                      ),
                      const SizedBox(height: 10),
                      const Text("Log in with other apps", style: TextStyle(color: Colors.white)),
                      const SizedBox(height: 10),
                      // Social Media Icons
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.facebook, color: Colors.blue, size: 40),
                          SizedBox(width: 20),
                          Icon(Icons.apple, color: Colors.white, size: 40),
                          SizedBox(width: 20),
                          Icon(Icons.dark_mode, color: Colors.black, size: 40),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}