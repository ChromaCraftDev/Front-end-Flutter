import 'package:flutter/material.dart';
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
  // Initialize Supabase instance

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 150.0),
        child: SingleChildScrollView(
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
                      const SizedBox(height: 50.0),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            // Perform login with Supabase
                            final email = emailController.text; // Get email from TextField
                            final password = passwordController.text; // Get password from TextField

                            try {
                              final response = await Supabase.instance.client.auth.signInWithPassword(email: email, password: password);

                              if (response == null) {
                                // Show Snackbar for login error
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Login failed'),
                                  ),
                                );
                              } else {
                                // Show Snackbar for successful login
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Login successful'),
                                  ),
                                );
                                // Navigate to configure page
                                Navigator.pushNamed(context, '/config');
                              }
                            } catch (e) {
                              if (e is AuthException) {
                                // Show Snackbar for invalid email or password
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Invalid email or password'),
                                  ),
                                );
                              } else {
                                // Show Snackbar for other exceptions
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('An error occurred: ${e.toString()}'),
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text('Login'),
                        ),
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
      ),
    );
  }
}
