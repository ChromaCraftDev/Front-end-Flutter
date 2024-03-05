import 'package:flutter/material.dart';

class Configure extends StatefulWidget {
  const Configure({Key? key}) : super(key: key);

  @override
  _ConfigureState createState() => _ConfigureState();
}

class _ConfigureState extends State<Configure> {
  Color colorBoxColor1 = Colors.red;
  Color colorBoxColor2 = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildButton('Base', 'The most prevalent. Usually the background colour.', colorBoxColor1),
              SizedBox(height: 20), // Add some space between the buttons
              buildButton('Shade', 'Visually below the components using base colour usually used for sidebars', colorBoxColor2),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(String title, String subtitle, Color colorBoxColor) {
    return Container(
      width: 800, // adjust the width as needed
      height: 70, // adjust the height as needed
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black, // background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // rounded corners
          ),
        ),
        onPressed: () {
          // handle button press
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  colorBoxColor = colorBoxColor == Colors.red ? Colors.blue : Colors.red;
                });
              },
              child: Container(
                width: 50,
                height: 50,
                color: colorBoxColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
