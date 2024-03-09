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

  bool isLoading = false;
  bool isButtonDisabled = false;

  Future<void> registerUser() async {
    setState(() {
      isLoading = true;
    });

    String firstName = firstNameController.text.trim();
    String lastName = lastNameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    bool isFirstNameNotEmpty = firstName.isNotEmpty;
    bool isEmailValid =
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
    bool isPasswordValid = password.length >= 6;

    if (!isFirstNameNotEmpty) {
      _scaffoldKey.currentState!.showSnackBar(
        const SnackBar(content: Text('First Name cannot be empty!')),
      );
      return;
    }

    if (!isEmailValid) {
      _scaffoldKey.currentState!.showSnackBar(
        const SnackBar(content: Text('Please enter a valid Email Address!')),
      );
      return;
    }

    if (!isPasswordValid) {
      _scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
            content: Text('Please enter a password more than 6 characters!')),
      );
      return;
    }

    if (password != confirmPassword) {
      _scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
            content: const Text("Passwords you entered don't match!")),
      );
      return;
    }
    if (isFirstNameNotEmpty &&
        isEmailValid &&
        isPasswordValid &&
        password == confirmPassword) {
      try {
        // Show loading dialog
        showDialog(
          context: context,
          barrierDismissible: false, // prevent user from dismissing dialog
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text('Registering'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text('Please wait...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
          },
        );

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

        Navigator.pop(context); // Close loading dialog

        _scaffoldKey.currentState!.showSnackBar(
          const SnackBar(
            content: Text(
                'Registration successful! Please check your email for a verification link to complete your account.'),
          ),
        );

        // Wait for 2 seconds before redirecting to the login page
        await Future.delayed(const Duration(milliseconds: 650));

        // Redirect to the login page upon successful registration
        Navigator.pushReplacementNamed(context, '/login'); // Replace the current page with the login page

        setState(() {
          isButtonDisabled = true;
        });
      } catch (e) {
        Navigator.pop(context); // Close loading dialog
        _scaffoldKey.currentState!.showSnackBar(
          SnackBar(content: Text('Failed to register user: $e')),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
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
              children: <Widget>[
                Row(
                  children: [
                    SizedBox(
                      width: 700, // Adjust the width as needed
                      child: Image.asset(
                        'Images/logo2.PNG', // Add your image path
                        height: 800,
                        // Add more properties if needed
                      ),
                    ),
                    const SizedBox(width: 200),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                              child: const Text(
                                'REGISTER NOW',
                                style: TextStyle(fontSize: 50, fontFamily: 'Schyler'),
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
                              onPressed: isButtonDisabled
                                  ? null
                                  : () async {
                                      await registerUser();
                                    },
                              child: const Text('Register'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}