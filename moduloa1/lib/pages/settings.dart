import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/skiing_person.png', height: 120),
            Container(height: 16),
            Container(
              width: width * .6,
              child: Slider(value: 0, onChanged: (value) => ()),
            ),
            Container(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(width * .4, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(0),
                ),
                backgroundColor: Colors.blue,
              ),
              onPressed: () => Navigator.pop(context),
              child: Text('Concluído', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
