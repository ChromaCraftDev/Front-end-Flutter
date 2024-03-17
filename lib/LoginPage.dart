import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: TextField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Email Address',
                                contentPadding: EdgeInsets.all(10.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Password',
                                contentPadding: EdgeInsets.all(10.0),
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
                          const SizedBox(height: 30.0),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                onPressed: () {
                                  _signInWithGoogle();
                                  // TODO: Implement Google login functionality
                                },
                                icon: Image.asset('Images/google-logo.png', width: 24, height: 24), // Replace with Google logo
                              ),
                              const SizedBox(width: 20), // Add small space between icons
                              IconButton(
                                onPressed: () {
                                  // TODO: Implement Facebook login functionality
                                },
                                icon: Image.asset('Images/facebook-logo.jpg', width: 24, height: 24), // Replace with Facebook logo
                              ),
                              const SizedBox(width: 20), // Add small space between icons
                              IconButton(
                                onPressed: () {
                                  // TODO: Implement Apple login functionality
                                },
                                icon: Image.asset('Images/apple-logo.png', width: 24, height: 24), // Replace with Apple logo
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
                      const CircularProgressIndicator(),
                      const SizedBox(height: 20),
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

    if (response == null) {
      // Set status message for login failed
      setState(() {
        loadingStatus = 'Login failed. Please check your credentials and try again.';
      });
      
    } else {
      // Set status message for successful login
      setState(() {
        loadingStatus = 'Login successful. Redirecting to Home Page...';
        
      });
      await Future.delayed(Duration(seconds: 1));

        // Save email to a text file
        _saveEmailToFile(email);

      // Delay before navigating to give user time to see status message
      await Future.delayed(Duration(seconds: 1));

      Navigator.pushNamed(
        context,
        '/profile',
        arguments: {
          'email': email,
        },
      );
      Navigator.pushNamed(context, '/config');
    }
  } catch (e) {
    // Set status message for error
    setState(() {
      loadingStatus = 'An error occurred: ${e.toString()}';
    });
  } finally {
    setState(() {
      isLoading = false;
    });

    final email = emailController.text;
    final password = passwordController.text;

    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(email: email, password: password);

      if (response == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: const Text('Login failed'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful'),
          ),
        );
        Navigator.pushNamed(
          context,
          '/profile',
          arguments: {
            'name': response.user?.userMetadata?['first_name'],
            'email': email,
          },
        );
        Navigator.pushNamed(context, '/config');
      }
    } catch (e) {
      if (e is AuthException) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid email or password. Check your credentials and try again'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: ${e.toString()}'),
          ),
        );
      }
    } finally {
      setState(() {
        isLoading = false;
        loadingStatus = '';
      });
    }
  }
}
Future<void> _signInWithGoogle() async {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  try {
    // Start the Google Sign-In process
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    // Check if the user signed in successfully
    if (googleUser != null) {
      // Get the authentication token (idToken) from Google Sign-In
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String idToken = googleAuth.idToken ?? '';

      // Authenticate with Supabase using the Google idToken
      await _authenticateWithSupabase(idToken);
    }
  } catch (error) {
    print(error); // Handle sign-in errors
  }
}

Future<void> _authenticateWithSupabase(String idToken) async {
  try {
    final response = await Supabase.instance.client.auth.signInWithOAuth(
      'google' as Provider ,
        redirectTo: 'https://hgblhxdounljhdwemyoz.supabase.co/auth/v1/callback', // Replace with your redirect URL
        //accessToken: idToken, // Pass the Google idToken as the accessToken
    );

    if (response != null) {
      // Handle error
      print('Error: ${response}');
    } else {
      // Login successful
      print('Login successful');
    }
  } catch (error) {
    // Handle error
    print('Error: $error');
  }
}
void _saveEmailToFile(String email) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/userData.txt');
    await file.writeAsString(email);
  }
}