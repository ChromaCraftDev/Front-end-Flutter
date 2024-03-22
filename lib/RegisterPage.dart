
import 'package:chromacraft/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:getwidget/getwidget.dart';

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
  String loadingStatus = '';
  bool _isObscure = true; // To track whether password is obscured or not
  bool _isConfirmObscure = true; // To track whether confirm password is obscured or not

  @override
  Widget build(BuildContext context) {
    final ThemeNotifier themeNotifier = context.read<ThemeNotifier>();
    final String logoImagePath = themeNotifier.currentTheme.brightness == Brightness.dark
        ? 'Images/logo.PNG'
        : 'Images/logo2.PNG';
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          Flexible(
                            flex: 3,
                            child: Image.asset(
                              logoImagePath, // Use the determined logo image path
                              width: 600,
                              height: 600,
                            ),
                          ),
                          const SizedBox(width: 300),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Center(
                                    child: Text(
                                      'REGISTER NOW',
                                      style: TextStyle(fontSize: 50, fontFamily: 'Schyler'),
                                    ),
                                  ),
                                const SizedBox(height: 20.0), // Add space between "LOGIN" and text fields
                                TextField(
                                  controller: firstNameController,
                                  decoration: const InputDecoration(
                                    labelText: 'First Name',
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                TextField(
                                  controller: lastNameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Last Name (Optional)',
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                TextField(
                                  controller: emailController,
                                  decoration: const InputDecoration(
                                    labelText: 'Email Address',
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                TextField(
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
                                      icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility), // Toggle icon based on password visibility
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                TextField(
                                  controller: confirmPasswordController,
                                  obscureText: _isConfirmObscure, // Toggle this value to show/hide confirm password
                                  decoration: InputDecoration(
                                    labelText: 'Confirm Password',
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isConfirmObscure = !_isConfirmObscure; // Toggle the value to show/hide confirm password
                                        });
                                      },
                                      icon: Icon(_isConfirmObscure ? Icons.visibility_off : Icons.visibility), // Toggle icon based on confirm password visibility
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : () => registerUser(),
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
                        width: 200, // Adjust width and height as needed
                        height: 200,
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
            ]
          )
        ),
      ),
    );
  }

  Future<void> registerUser() async {
    setState(() {
      isLoading = true;
      loadingStatus = 'Please Wait! Validating Credentials!';
    });

    String firstName = firstNameController.text.trim();
    String lastName = lastNameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text;
    String ImageID = 'https://drive.google.com/uc?export=download&id=1eJHO1ewFgmXIZRU358hD5oPi_GRGOGwb';
    String confirmPassword = confirmPasswordController.text;

    bool isFirstNameNotEmpty = firstName.isNotEmpty;
    bool isEmailValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
    bool isPasswordValid = password.length >= 6;
    final isUserAvailable = await supabase.from('users').select().eq('email', email).execute();

    if (!isFirstNameNotEmpty) {
      _scaffoldKey.currentState!.showSnackBar(
        const SnackBar(content: Text('First Name cannot be empty!')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    if (!isEmailValid) {    
      _scaffoldKey.currentState!.showSnackBar(
        const SnackBar(content: Text('Please enter a valid Email Address!')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    if (!isPasswordValid) {
      _scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
            content: Text('Please enter a password more than 6 characters!')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    if (password != confirmPassword) {
      _scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
            content: Text("Passwords you entered don't match!")),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    if (isUserAvailable.data != null && isUserAvailable.data.isNotEmpty) {
      // User already exists
      _scaffoldKey.currentState!.showSnackBar(
        const SnackBar(content: Text('This email is already registered!')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }
    if (isFirstNameNotEmpty &&
        isEmailValid &&
        isPasswordValid &&
        password == confirmPassword) {
      try {
        
      setState(() {
        loadingStatus = 'Please Wait! Validating Credentials!';
      });

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
          'image_id': ImageID,
        }).execute();

        setState(() {
          loadingStatus = 'Registration successful. Please check your email for the verification link...';
        });
        await Future.delayed(Duration(seconds: 4));

        // Redirect to the login page upon successful registration
        Navigator.pushNamed(context, '/login'); // Replace the current page with the login page

        setState(() {
          isButtonDisabled = true;
        });
      } catch (e) {
        setState(() {
          loadingStatus = 'Registration Failed...';
        });        
        await Future.delayed(Duration(seconds: 4));
      } finally {
        setState(() {
          isLoading = false;
          isButtonDisabled = false;
        });
      }
    }
  }
}



