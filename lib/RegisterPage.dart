// ignore_for_file: file_names
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
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
                      'REGISTER NOW',
                      style: TextStyle(fontSize: 50,fontFamily: 'Schyler',),
                    ),
                  ),
                  const SizedBox(height: 50.0), // Add space between "LOGIN" and text fields
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'First Name',
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
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Last Name',
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
                        hintText: 'Confirm Password',
                        contentPadding: EdgeInsets.all(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement login functionality
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text('Register'),
                    ),
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
