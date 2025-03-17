import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatelessWidget {
  final AuthService _auth = AuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _verificationController = TextEditingController();

  SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/backgrounds/background.gif"),
                fit: BoxFit.cover,
              ),
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
                      // Username
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.7),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          labelText: "Username",
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Email
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.7),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          labelText: "Email",
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Password
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
                      // Verification Code
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _verificationController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.7),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                labelText: "Verification Code",
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                            ),
                            child: const Text("60s"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                            child: const Text("Back"),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                User? user = await _auth.signUp(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                );
                                if (user != null) {
                                  Navigator.pushReplacementNamed(context, '/character-selection');
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Sign-up failed. Please try again.")),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Error: ${e.toString()}")),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
                            child: const Text("Sign Up"),
                          ),

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
