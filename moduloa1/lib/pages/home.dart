import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:moduloa1/controllers/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var formKey = GlobalKey<FormState>();

  startApp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? scores = prefs.getString('scores');

    if (scores != null) {
      App.scores = jsonDecode(scores);
    }
  }

  @override
  void initState() {
    startApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            SizedBox(
              width: width,
              height: height,
              child: Image.asset('assets/bg.jpg', fit: BoxFit.cover),
            ),
            Opacity(
              opacity: .3,
              child: Container(
                width: width,
                height: height,
                color: Colors.black,
              ),
            ),
            SizedBox(
              width: width,
              height: height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Go Skiing', style: TextStyle(fontSize: 32)),
                          Container(height: 16),
                          Container(
                            width: width * .6,
                            child: TextFormField(
                              controller: App.nome,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Invalid';
                                }

                                return null;
                              },

                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                                labelText: 'Player name',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(height: 24),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(width * .4, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(0),
                              ),
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                Navigator.pushNamed(context, '/game');
                              } else {}
                            },
                            child: Text(
                              'Start Game',
                              style: TextStyle(color: Colors.white),
                            ),
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
                            onPressed: () {
                              App.score = {};
                              Navigator.pushNamed(context, '/scores');
                            },
                            child: Text(
                              'Ranking',
                              style: TextStyle(color: Colors.white),
                            ),
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
                            onPressed: () =>
                                Navigator.pushNamed(context, '/settings'),
                            child: Text(
                              'Setting',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
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
