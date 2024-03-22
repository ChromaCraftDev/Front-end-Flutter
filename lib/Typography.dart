import 'dart:io';
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:getwidget/getwidget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'ConfigurePage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TypographyPage extends StatefulWidget {
  const TypographyPage({Key? key}) : super(key: key);

  @override
  _TypographyPageState createState() => _TypographyPageState();
}

class _TypographyPageState extends State<TypographyPage> {
  String email = '';
  String _firstName = '';
  String _lastName = '';
  String _selectedProfilePicture = ' ';

    @override
  void initState() {
    super.initState();
    _getEmailFromStorage();
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
        title: const Text('Typography Page'),
        actions: <Widget>[
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle, // Make the container circular
            ),
            child: IconButton(
              icon: const Icon(Icons.palette),
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const ConfigurePage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(-1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.easeInOutQuart;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle, // Make the container circular
              color: Color.fromARGB(150, 79, 55, 140),
            ),
            child: IconButton(
              icon: const Text('Tr'),
              onPressed: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0), // Add padding to the right
            child: GFButton(
              shape: GFButtonShape.pills,
              onPressed: () {
                // Implement your apply button functionality here
                if (kDebugMode) {
                  print('Apply button pressed');
                }
                },// Call _applyButtonPressed from ConfigurePage
              child: const Row(
                children: [
                  Icon(Icons.edit, color: Colors.white,),
                  SizedBox(width: 10.0),
                  Text(
                    'Apply',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: GFDrawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              decoration:
                  const BoxDecoration(color: Color.fromARGB(200, 79, 55, 140)),
              padding: const EdgeInsets.all(40.0),
              child: Image.asset(
                'Images/logo2.PNG',
                width: 1000, // Adjust width as needed
                height: 1000, // Adjust height as needed
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
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () {
                      Navigator.pushNamed(context, '/settings');
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
                // backgroundColor: Colors.blue,
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
      body: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildTextStyle('Sans Serif', 'Used for application UI.',
                const TextStyle(fontFamily: 'Sans Serif')),
            const SizedBox(height: 16),
            buildTextStyle('Serif', 'Used for documents.',
                const TextStyle(fontFamily: 'Serif')),
            const SizedBox(height: 16),
            buildTextStyle('Monospace', 'Used for code editors, and terminals.',
                const TextStyle(fontFamily: 'MonoSpace')),
          ],
        ),
      ),
    );
  }

  Widget buildTextStyle(String title, String subtitle, TextStyle style) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(fontSize: 24),
            ),
            Text(
              subtitle,
              style: const TextStyle( fontSize: 16),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: GFButton(
            color: GFColors.DARK,
            onPressed: () {
              // Add your onPressed action here
            },
            child: Text(
              'The quick brown fox jumps over the lazy dog',
              style: style.copyWith(color: Colors.white, fontSize: 18),
            ),
          )
        ),
      ],
    );
  }
}
