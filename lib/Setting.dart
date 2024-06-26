
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_notifier.dart';

class SettingsContent extends StatefulWidget {
  const SettingsContent({super.key});

  @override
  _SettingsContentState createState() => _SettingsContentState();
}

class _SettingsContentState extends State<SettingsContent> {
  String _selectedTheme = '    System Default';

  @override
  Widget build(BuildContext context) {
    final ThemeNotifier themeNotifier = context.read<ThemeNotifier>();
    final String logoImagePath = themeNotifier.currentTheme.brightness == Brightness.dark
        ? 'Images/logo.PNG'
        : 'Images/logo2.PNG';

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'System',
            style: Theme.of(context).textTheme.headline6,
          ),
          const Divider(), // Title bar before theme setting
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Theme',
                style: Theme.of(context).textTheme.headline6,
              ),
              Container(
                width: 180,
                child: DropdownButton<String>(
                  value: _selectedTheme,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedTheme = newValue!;
                      if (_selectedTheme == '    Dark') {
                        themeNotifier.toggleTheme(true);
                      } else if (_selectedTheme == '    Light') {
                        themeNotifier.toggleTheme(false);
                      } else if (_selectedTheme == '    System Default') {
                        themeNotifier.setSystemDefaultTheme();
                      }
                    });
                  },
                  items: <String>['    System Default', '    Dark', '    Light']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Center(
                        child: Text(
                          value,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(
              height: 20), // Add some space between dropdown and preview image
          // Display preview image based on selected theme
          Container(
            alignment: Alignment.center,
            child: Image.asset(
              logoImagePath,
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
