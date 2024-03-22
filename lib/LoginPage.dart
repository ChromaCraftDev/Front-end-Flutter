import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:getwidget/getwidget.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String loadingStatus = '';
  bool _isObscure = true; // To track whether password is obscured or not

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(60.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      flex: 3,
                      child: Image.asset(
                        'Images/logo2.PNG', // Replace 'assets/logo.png' with your actual image path
                        width: 600, // Adjust width as needed
                        height: 600, // Adjust height as needed
                      ),
                    ),
                    const SizedBox(width: 300), // Add spacing between image and text boxes
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              '',
                              style: TextStyle(fontSize: 50),
                            ),
                          ),
                          const SizedBox(width: 50),
                          const Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              'LOGIN',
                              style: TextStyle(fontSize: 80, fontFamily: 'Schyler'),
                            ),
                          ),
                          const SizedBox(height: 60.0), // Add space between "LOGIN" and text fields
                          Container(
                            child: TextField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email Adress',
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                         Container(
                            child: TextField(
                              controller: passwordController,
                              obscureText: _isObscure, // Toggle this value to show/hide password
                              decoration: InputDecoration(
                                labelText: 'Password',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure; // Toggle the value to show/hide password
                                    });
                                  },
                                  icon: Opacity(
                                    opacity: 0.5, // Set the opacity value here
                                    child: Icon(_isObscure ? Icons.visibility_off : Icons.visibility,),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/resetPassword');
                                  },
                                  child: const Text(
                                    'Forgot Password ?',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.blue, // Change font color here
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 50.0),
                          ElevatedButton(
                            onPressed: isLoading ? null : () => _login(),
                            child: const Text('Login'),
                          ),
                          //------Dev only-----------------
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/config');
                              },
                              child: const Text('Developer only'),
                            ),
                          const SizedBox(height: 30.0),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                'Don\'t have an account? ',
                                style: TextStyle(fontSize: 16),
                              ),
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/register');
                                  },
                                  child: const Text(
                                    'Create an Account',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue, // Change font color here
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: isLoading,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'Images/loading.gif', // Replace 'assets/loading.gif' with the path to your custom GIF
                        width: 150, // Adjust width and height as needed
                        height: 150,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        loadingStatus,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _login() async {
  setState(() {
    isLoading = true;
    loadingStatus = 'Validating credentials...';
  });
  final email = emailController.text;
  final password = passwordController.text;

  try {
    // Set status message for validating credentials
    setState(() {
      loadingStatus = 'Validating credentials...';
    });

    final response = await Supabase.instance.client.auth.signInWithPassword(email: email, password: password);

    // Set status message for successful login
    setState(() {
      loadingStatus = 'Login successful. Redirecting to Home Page...';
      
    });
    await Future.delayed(const Duration(seconds: 1));

      // Save email to a text file
    _saveEmailToFile(email);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Login successful'),
      ),
    );
    Navigator.pushNamed(context, '/config');
    } catch (e) {
    if (e is AuthException) {
      setState(() {
      loadingStatus = 'Invalid email or password. Check your credentials and try again';
      });
      await Future.delayed(const Duration(seconds: 2));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email or password. Check your Credentials and try again'),
        ),
      );
    }else{
      setState(() {
      loadingStatus = 'An error occured !';
      });
    }
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}


void _saveEmailToFile(String email) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/userData.txt');
    await file.writeAsString(email);
  }
}