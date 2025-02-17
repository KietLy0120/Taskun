import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  final AuthService _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/background.gif",
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Taskun",
                  style: TextStyle(
                    fontFamily: 'PixelFont',
                    fontSize: 48,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(20),
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
                      SizedBox(height: 10),
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
                      SizedBox(height: 10),
                      // Forgot Password & Sign Up Links
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Text("Forgot Password?", style: TextStyle(color: Colors.white)),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SignupScreen()),
                              );
                            },
                            child: Text("Create Account", style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      // Log In Button
                      ElevatedButton(
                        onPressed: () async {
                          User? user = await _auth.signIn(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                          );
                          if (user != null) {
                            Navigator.pushReplacementNamed(context, '/home');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Login failed. Please try again.")),
                            );
                          }
                        },
                        child: Text('Login'),
                      ),
                      SizedBox(height: 10),
                      Text("Log in with other apps", style: TextStyle(color: Colors.white)),
                      SizedBox(height: 10),
                      // Social Media Icons
                      Row(
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
