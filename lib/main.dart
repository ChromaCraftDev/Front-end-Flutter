import 'package:chroma_craft_1/LoginPage.dart';
import 'package:chroma_craft_1/RegisterPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,//Remove Debug tag
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),
        '/browse': (context) => HomePage(),
        '/profile': (context) => HomePage(),
      
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    Center(child: Text('Configure Page')),
    Center(child: Text('Browse Page')),
    Center(child: Text('Generate Page')),
    Center(child: Text('Profile Page')),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('ChromaCraft', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              title: Text('Configure'),
              onTap: () {
                Navigator.pop(context);
                onTabTapped(0);
              },
            ),
            ListTile(
              title: Text('Browse Template'),
              onTap: () {
                Navigator.pop(context);
                onTabTapped(1);
              },
            ),
            ListTile(
              title: Text('Generate Template'),
              onTap: () {
                Navigator.pop(context);
                onTabTapped(2);
              },
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                onTabTapped(3);
              },
            ),
          ],
        ),
      ),
      body: _children[_currentIndex],
    );
  }
}
