import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final supabase = SupabaseClient(
    'https://hgblhxdounljhdwemyoz.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhnYmxoeGRvdW5samhkd2VteW96Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDk4ODEwMzMsImV4cCI6MjAyNTQ1NzAzM30.kOaLOh5pGrZhAVDfSCd6pYdThxT161IOBeNSuKswZ7g',
  );

  Future<void> registerUser() async {
    String firstName = firstNameController.text.trim();
    String lastName = lastNameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    bool isFirstNameNotEmpty = firstName.isNotEmpty;
    bool isEmailValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
    bool isPasswordValid = password.length >= 6;

    if (!isFirstNameNotEmpty) {
      _scaffoldKey.currentState!.showSnackBar(
        SnackBar(content: Text('First Name cannot be empty!')),
      );
      return;
    }

    if (!isEmailValid) {
      _scaffoldKey.currentState!.showSnackBar(
        SnackBar(content: Text('Please enter a valid Email Address!')),
      );
      return;
    }

    if (!isPasswordValid) {
      _scaffoldKey.currentState!.showSnackBar(
        SnackBar(content: Text('Please enter a password more than 6 characters!')),
      );
      return;
    }

    if (password != confirmPassword) {
      _scaffoldKey.currentState!.showSnackBar(
        SnackBar(content: Text("Passwords you entered don't match!")),
      );
      return;
    }
    
    if(isFirstNameNotEmpty && isEmailValid && isPasswordValid && password == confirmPassword){
      try {
        // Register user using Supabase Auth
        final response = await supabase.auth.signUp(
          email: email,
          password: password,
        );

        if (response == null) {
          throw Exception('Supabase error'); // Or a custom message
        }

        // Store additional user data in Supabase database (without ID)
        final user = response.user;
        await supabase.from('users').insert({
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
        }).execute();

        _scaffoldKey.currentState!.showSnackBar(
          SnackBar(
            content: Text(
              'Registration successful! Please check your email for a verification link to complete your account.'
            ),
          ),
        );
      } catch (e) {
        _scaffoldKey.currentState!.showSnackBar(
          SnackBar(content: Text('Failed to register user: $e')),
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'REGISTER NOW',
                    style: TextStyle(fontSize: 40, fontFamily: 'Schyler'),
                  ),
                ),
                const SizedBox(height: 40.0), // Add space between "LOGIN" and text fields
                TextField(
                  controller: firstNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'First Name',
                  ),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: lastNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Last Name (Optional)',
                  ),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Email Address',
                  ),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Password',
                  ),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Confirm Password',
                  ),
                ),
                const SizedBox(height: 20.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await registerUser();
                    },
                    child: const Text('Register'),
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
