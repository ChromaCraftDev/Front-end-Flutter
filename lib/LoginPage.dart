// ignore_for_file: file_names
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(80.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Image asset widget without SizedBox
            Image.asset(
              'Images/logo2.PNG', // Replace 'assets/logo.png' with your actual image path
              width: 600, // Adjust width as needed
              height: 600, // Adjust height as needed
            ),
            const SizedBox(width: 50), // Add spacing between image and text boxes
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      style: TextStyle(fontSize: 80,fontFamily: 'Schyler',),
                    ),
                  ),
                  const SizedBox(height: 60.0), // Add space between "LOGIN" and text fields
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
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
                    child: const TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                        contentPadding: EdgeInsets.all(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement login functionality
                        Navigator.pushNamed(context, '/config');
                      },
                      child: const Text('Login'),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                    mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}
