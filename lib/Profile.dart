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
  String _email = 'you cant get the email from ';
  String _firstName = 'Developer';
  String _lastName = 'mode';
  String _selectedProfilePicture =
      'https://static.vecteezy.com/system/resources/thumbnails/009/734/564/small_2x/default-avatar-profile-icon-of-social-media-user-vector.jpg'; // Default profile picture URL

  final List<String> _profilePictures = [
    'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?cs=srgb&dl=pexels-mohamed-abdelghaffar-771742.jpg&fm=jpg',
    'https://wallpapers.com/images/featured/cool-profile-picture-87h46gcobjl5e4xu.jpg',
    'https://imgv3.fotor.com/images/blog-richtext-image/10-profile-picture-ideas-to-make-you-stand-out.jpg',
    'https://static.vecteezy.com/system/resources/thumbnails/009/209/212/small/neon-glowing-profile-icon-3d-illustration-vector.jpg',
    'https://w0.peakpx.com/wallpaper/979/89/HD-wallpaper-purple-smile-design-eye-smily-profile-pic-face.jpg',
    'https://static.vecteezy.com/system/resources/thumbnails/001/991/212/small/avatar-profile-pink-neon-icon-brick-wall-background-colour-neon-icon-vector.jpg',
    'https://i.pinimg.com/564x/00/9e/10/009e1061d2c4c46c2e48d21bdb41becb.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRtsqj52oiZx9rBGAcIU_8gjGntvorvWai2P67-0agznp_uomCVdFwxPcfdHXvvVDOD7c&usqp=CAU',
    'https://e0.pxfuel.com/wallpapers/89/756/desktop-wallpaper-emoji-black-theme-smile.jpg',
    'https://w0.peakpx.com/wallpaper/903/252/HD-wallpaper-man-on-fire-heat-whatsapp-valuable-post-science-dp-profile-pic-vip-whatsapp-profile-pic-display-thumbnail.jpg',
    // Add more profile picture URLs as needed
  ];

  @override
  void initState() {
    super.initState();
    _getUserData();
    _getEmailFromStorage();
    _loadSelectedProfilePicture(); // Load selected profile picture URL from shared preferences
  }

  Future<void> _getEmailFromStorage() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/userData.txt');
      final savedEmail = await file.readAsString();
      setState(() {
        _email = savedEmail;
      });
    } catch (e) {
      print('Error reading email from file: $e');
    }
  }

  Future<void> _getUserData() async {
    try {
      final response = await Supabase.instance.client
          .from('users')
          .select('first_name, last_name')
          .eq('email', _email)
          .single()
          .execute();

      final user = response.data;

      if (user != null) {
        setState(() {
          _firstName = user['first_name'];
          _lastName = user['last_name'];
        });
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
    _saveSelectedProfilePicture(newProfilePicture);
    setState(() {
      _selectedProfilePicture = newProfilePicture;
    });
    Navigator.of(context).pop(); // Close the dialog
  }

  Future<void> _saveSelectedProfilePicture(String newProfilePicture) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedProfilePicture', newProfilePicture);

    // Save image ID to a text file
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/image_id.txt');
      await file.writeAsString(newProfilePicture);
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
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/image_id.txt');
      String savedImageId = await file.readAsString();
      setState(() {
        _selectedProfilePicture = savedImageId;
      });
    } catch (e) {
      print('Error loading image ID from file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            {};
    final name = args['name'] ?? '';

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100.0,
        title: const Text('Profile'),
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Center(child: Text('$_firstName $_lastName')),
              accountEmail: Center(child: Text(_email)),
              currentAccountPicture: GestureDetector(
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
                                    radius: 50,
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
                  radius: 40,
                  backgroundImage: NetworkImage(_selectedProfilePicture),
                ),
              ),
              decoration: const BoxDecoration(
                color: Color.fromARGB(200, 79, 55, 140),
              ),
              otherAccountsPictures: <Widget>[],
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
                  ListTile(
                    leading: const Icon(Icons.account_circle),
                    title: const Text('Profile'),
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
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
              _email,
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
