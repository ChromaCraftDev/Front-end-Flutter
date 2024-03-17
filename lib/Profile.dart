import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences package
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final supabase = SupabaseClient(
    'https://hgblhxdounljhdwemyoz.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhnYmxoeGRvdW5samhkd2VteW96Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDk4ODEwMzMsImV4cCI6MjAyNTQ1NzAzM30.kOaLOh5pGrZhAVDfSCd6pYdThxT161IOBeNSuKswZ7g',
  );
  String email = 'you cant get the email from ';
  String _firstName = 'Developer';
  String _lastName = 'mode';
  String _selectedProfilePicture =
      'https://drive.google.com/uc?export=download&id=1eJHO1ewFgmXIZRU358hD5oPi_GRGOGwb'; // Default profile picture URL

  final List<String> _profilePictures = [
    'https://drive.google.com/uc?export=download&id=13XPOdVXjqjFaEI7msMXVcGAkWILdIZq_',
    'https://drive.google.com/uc?export=download&id=1nJLwE5MeRKVqQunfbiR9lPQLn2xLcVTD',
    'https://drive.google.com/uc?export=download&id=1lnEUE7oa-kqDImhxUMtIi7p5p2TFmWRn',
    'https://drive.google.com/uc?export=download&id=1OpragTe3MAC_7E7XhmcSfQ2_c95Y7CJ7',
    'https://drive.google.com/uc?export=download&id=19hHPgEizywoT9PM3_vecfKP65h0_udXs',
    'https://drive.google.com/uc?export=download&id=1RSRAu31Q0u5kROWRNuAmh8Yv5jql0t7s',
    'https://drive.google.com/uc?export=download&id=1YvKazKAzFxT9JcWYZMk6RPEkdx-YNs36',
    'https://drive.google.com/uc?export=download&id=1OWUueu1kKEqwHW4TB0uYpu_SnSemaePY',
    'https://drive.google.com/uc?export=download&id=1IL7qmR824YwOQCkwHbpE106y3bBVw640',
    'https://drive.google.com/uc?export=download&id=1bhMBtctgfzz20r1M0TufxHTFHMBIP2rG',
    'https://drive.google.com/uc?export=download&id=17qYOh_VA6IR6FXR4H13zGY4Y8wsxvk9T',
    'https://drive.google.com/uc?export=download&id=1icwODDS8YcDHejC3oxuLlgZSuN7pnQHo',
    'https://drive.google.com/uc?export=download&id=1JuLHM76WNDpGIUN64WxXrqNooiqgDN4C',
    'https://drive.google.com/uc?export=download&id=1lkcfBB-arVshVRBwZqdKXzB-hDjTmkJ1',
    'https://drive.google.com/uc?export=download&id=1HmCtA-ZE1FhvyjrWtl_A0DorwFqhDYRg',
    'https://drive.google.com/uc?export=download&id=1Rsdu1yLfXntZ0lZj1enBTeY6VXwPY4zc',
    'https://drive.google.com/uc?export=download&id=1MTdU3k33pMl4PP3TJQ4wfsbokZ8lTbln',
    'https://drive.google.com/uc?export=download&id=12Npi0igO9H_7vgI-xxCGZvp3ANbo0FG1',
    'https://drive.google.com/uc?export=download&id=1z1-1VI5JLIveA-hY2yj7XVidbWRXlD-d',
    'https://drive.google.com/uc?export=download&id=1StJudLV0E0u_84ohMVmYICOWFDb3Llh0',
    // Add more profile picture URLs as needed
  ];

  @override
  void initState() {
    super.initState();
    _getEmailFromStorage();
    _loadSelectedProfilePicture(); // Load selected profile picture URL from shared preferences
  }

  Future<void> _getEmailFromStorage() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/userData.txt');
      final savedEmail = await file.readAsString();
      setState(() {
        email = savedEmail;
      });
      _getUserData();
      _loadSelectedProfilePicture();
    } catch (e) {
      print('Error reading email from file: $e');
    }
  }

Future<void> _getUserData() async {
  try {
    final response = await Supabase.instance.client
        .from('users')
        .select('first_name , last_name')
        .eq('email',email);

    if (response != null && response.isNotEmpty) {
      final user = response[0];
      setState(() {
        _firstName = user['first_name'] as String;
        if (user['last_name'] as String == null) {
          _lastName = " ";
        }else{
          _lastName = user ['last_name'] as String;
        }
      });
    } else {
      print('No user data found for this email: $email');
    }
  } catch (e) {
    print('Error fetching user data: $e');
  }
}

  Future<void> _logout() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/userData.txt');
      await file.delete();
      // Navigate to login page
      Navigator.pushNamed(context, '/login');
    } catch (e) {
      print('Error deleting files: $e');
    }
  }

  void _changeProfilePicture(String newProfilePicture) {
    
    setState(() {
        _selectedProfilePicture = newProfilePicture;
        _saveSelectedProfilePicture(_selectedProfilePicture);
    });
    Navigator.of(context).pop(); // Close the dialog
  }

  Future<void> _saveSelectedProfilePicture(String newProfilePicture) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedProfilePicture', newProfilePicture);

    // Save image ID to a text file
    try {
        await supabase.from('users').update({
          'image_id' : newProfilePicture,})
          .match({'email': email})
          .execute();
    } catch (e) {
      print('Error saving image ID to file: $e');
    }
  }

  Future<void> _loadSelectedProfilePicture() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedProfilePicture = prefs.getString('selectedProfilePicture');
    if (savedProfilePicture != null) {
      setState(() {
        _selectedProfilePicture = savedProfilePicture;
      });
    }

    // Load image ID from text file
    try {
      final response = await Supabase.instance.client
        .from('users')
        .select('image_id')
        .eq('email',email);

        final user = response[0];
      setState(() {
          _selectedProfilePicture = user['image_id'] as String;

      });
    } catch (e) {
      print('Error loading image ID from file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100.0,
        title: const Text('Profile'),
      ),
      drawer:Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(200, 79, 55, 140),
              ),
              child: Image.asset(
                'Images/logo2.PNG', // Replace with your image path
                width: 300, // Specify width as needed
                height: 300, // Specify height as needed
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Configure'),
                    onTap: () {
                      Navigator.pushNamed(context, '/config');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.web),
                    title: const Text('Browse Template'),
                    onTap: () {
                      Navigator.pushNamed(context, '/browse');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.create),
                    title: const Text('Generate Template'),
                    onTap: () {
                      Navigator.pushNamed(context, '/ai');
                    },
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(_selectedProfilePicture),
                      ),
                      const SizedBox(width: 5), // Add some spacing between image and text
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '$_firstName $_lastName',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            email,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Change Profile Picture'),
                      content: Container(
                        width: 400, // Width of the dialog
                        height: 300,
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: _profilePictures.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                _changeProfilePicture(_profilePictures[index]);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      NetworkImage(_profilePictures[index]),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
              child: CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(_selectedProfilePicture),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '$_firstName $_lastName',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              email,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _logout,
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
