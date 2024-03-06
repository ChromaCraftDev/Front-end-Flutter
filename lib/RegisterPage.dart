import 'package:flutter/material.dart';
//import 'package:your_database_package'; // import your database package

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key});

  @override
  Widget build(BuildContext context) {
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    void registerUser() {
      String firstName = firstNameController.text.trim();
      String lastName = lastNameController.text.trim();
      String email = emailController.text.trim();
      String password = passwordController.text;
      String confirmPassword = confirmPasswordController.text;

      bool isFirstNameNotEmpty = firstName.isNotEmpty;

      // Validate email format
      bool isEmailValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);

      // Check password length
      bool isPasswordValid = password.length >= 6;

      if(!isFirstNameNotEmpty){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('First Name cannot be empty!')));
      }

      if (!isEmailValid) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid Email Address!')));
      }
      if(!isPasswordValid){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a password more than 6 characters!')));
      }
      
      if (!(password == confirmPassword)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Passwords you entered doesn't match!")));
      }
      if (isEmailValid && isPasswordValid && password == confirmPassword && isFirstNameNotEmpty) {
        // Save data into the database
        // Example:
        // YourDatabase.saveUser(firstName, lastName, email, password);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registration successful!')));
      }
    }

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
                      onPressed: registerUser,
                      child: const Text('Register'),
                    ),
                  ),
                  const SizedBox(height: 20.0),
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
