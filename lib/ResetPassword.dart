import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  final supabase = SupabaseClient(
    'https://hgblhxdounljhdwemyoz.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhnYmxoeGRvdW5samhkd2VteW96Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDk4ODEwMzMsImV4cCI6MjAyNTQ1NzAzM30.kOaLOh5pGrZhAVDfSCd6pYdThxT161IOBeNSuKswZ7g',
  );

  bool isLoading = false;

  Future<void> resetPassword() async {
    setState(() {
      isLoading = true;
    });

    String email = emailController.text.trim();
    String newPassword = newPasswordController.text;

    bool isEmailValid =
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);

    if (!isEmailValid) {
      _scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid Email Address!'),
        ),
      );
      return;
    }

    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false, // prevent user from dismissing dialog
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Resetting Password'),
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

      // Update user's password in Supabase Authentication
      await supabase.auth.resetPasswordForEmail(email);
      await supabase.auth.updateUser(UserAttributes(password: newPassword));

      Navigator.pop(context); // Close loading dialog

      _scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text(
              'Your password has been successfully reset. You can now log in with your new password.'),
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      _scaffoldKey.currentState!.showSnackBar(
        SnackBar(content: Text('Failed to reset password: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reset Password'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Email Address',
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'New Password',
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  await resetPassword();
                },
                child: const Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
