import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';


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
  
  final googleSignIn = GoogleSignIn(scopes: ['email', 'profile']); // Include 'profile' scope

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
    bool isEmailValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
    bool isPasswordValid = password.length >= 6;
    final isUserAvailable = await supabase.from('users').select().eq('email', email).execute();

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

    if (isUserAvailable.data != null && isUserAvailable.data.isNotEmpty) {
      // User already exists
      _scaffoldKey.currentState!.showSnackBar(
        const SnackBar(content: Text('This email is already registered!')),
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

        // Wait before redirecting to the login page
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
          padding: const EdgeInsets.symmetric(horizontal: 60.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: Image.asset(
                        'Images/logo2.PNG', // Replace 'assets/logo.png' with your actual image path
                        width: 600, // Adjust width as needed
                        height: 600, // Adjust height as needed
                      ),
                    ),
                    const SizedBox(width: 300),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                              child: const Text(
                                'REGISTER NOW',
                                style: TextStyle(fontSize: 50, fontFamily: 'Schyler'),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                onPressed: () async {
                                  await _handleGoogleSignIn();
                                },
                                icon: Image.asset('Images/google-logo.png', width: 24, height: 24), // Replace with Google logo
                              ),
                              const SizedBox(width: 20), // Add small space between icons
                              IconButton(
                                onPressed: () async {
                                   await _handleFacebookSignIn();
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
                          const SizedBox(height: 20.0), // Add space between "LOGIN" and text fields
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

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final idToken = googleUser.serverAuthCode;
        // Use the ID token to authenticate with Supabase
        await _authenticateWithSupabase(idToken!);
      }
    } catch (error) {
      print(error); // Handle sign-in errors
    }
  }
  Future<void> _authenticateWithSupabase(String idToken) async {
    final response = await Supabase.instance.client.auth.signInWithOAuth(
      'google' as Provider,
      queryParams: {'idToken': idToken},
    );

    if (response == null) {
      throw Exception('Supabase error');
    }

    // Handle successful authentication (e.g., store user data)
  }

  Future<void> _handleFacebookSignIn() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        // Use the access token to authenticate with Supabase
        await _authenticateWithSupabase1(accessToken.token!);
      } else {
        print('Facebook login failed: ${result.status}');
      }
    } catch (error) {
      print('Facebook login error: $error');
    }
  }

  Future<void> _authenticateWithSupabase1(String accessToken) async {
    final response = await Supabase.instance.client.auth.signInWithOAuth(
      'facebook' as Provider, // Provider name for Facebook
      queryParams: {'access_token': accessToken},
    );

    if (response == null) {
      throw Exception('Supabase error');
    }

    // Handle successful authentication (e.g., store user data)
  }
}



