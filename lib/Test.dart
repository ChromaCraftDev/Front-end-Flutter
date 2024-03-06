import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ColorPickerPage(),
    );
  }
}

class ColorPickerPage extends StatefulWidget {
  @override
  _ColorPickerPageState createState() => _ColorPickerPageState();
}

class _ColorPickerPageState extends State<ColorPickerPage> {
  Color currentColor = Colors.blue; // Default color
  TextEditingController hexController = TextEditingController();

  void changeColor(Color color) {
    setState(() {
      currentColor = color;
      hexController.text = colorToHex(color);
    });
  }

  void changeColorFromHex(String hex) {
    setState(() {
      currentColor = hexToColor(hex);
    });
  }

  String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  Color hexToColor(String hex) {
    return Color(int.parse(hex.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Color Picker Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Pick a color'),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: currentColor,
                          onColorChanged: changeColor,
                          showLabel: true,
                          pickerAreaHeightPercent: 0.8,
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Done'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Open Color Picker'),
            ),
            SizedBox(height: 20),
            Text(
              'Selected Color:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Container(
              width: 100,
              height: 100,
              color: currentColor,
            ),
            SizedBox(height: 10),
            SizedBox(
              width: 150,
              child: TextField(
                controller: hexController,
                decoration: InputDecoration(
                  labelText: 'Hex Color',
                  hintText: '#RRGGBB',
                ),
                onChanged: (value) {
                  if (value.isNotEmpty && value.startsWith('#') && value.length == 7) {
                    changeColorFromHex(value);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    hexController.dispose();
    super.dispose();
  }
}
