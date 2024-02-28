// ignore_for_file: file_names
import 'package:flutter/material.dart' show AppBar, BuildContext, Column, CrossAxisAlignment, EdgeInsets, ElevatedButton, InputDecoration, MainAxisAlignment, Navigator, Padding, Scaffold, SizedBox, StatelessWidget, Text, TextButton, TextField, Widget;

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const TextField(
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 20.0),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement login functionality
                Navigator.pushNamed(context, '/config');
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 10.0),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Create an Account'),
            ),
          ],
        ),
      ),
    );
  }
}
