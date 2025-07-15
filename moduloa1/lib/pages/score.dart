import 'package:flutter/material.dart';
import 'package:moduloa1/controllers/app.dart';

class Score extends StatefulWidget {
  const Score({super.key});

  @override
  State<Score> createState() => _ScoreState();
}

class _ScoreState extends State<Score> {
  @override
  void initState() {
    App.scores.sort((a, b) => b['tempo'].compareTo(a['tempo']));
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true, title: Text('Rankings')),
      body: SizedBox(
        width: width,
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: App.scores.isEmpty
              ? Center(child: Text('No Ranking'))
              : Column(
                  children: [
                    for (int i = 0; i < App.scores.length; i++)
                      if (App.score['coin'] == null)
                        ListTile(
                          leading: Text((i + 1).toString()),
                          title: Text(App.scores[i]['player']),
                          subtitle: Text(App.scores[i]['coin'].toString()),
                          trailing: Text(
                            '${(App.scores[i]['tempo'] ~/ 60).toString().padLeft(2, '0')}:${(App.scores[i]['tempo'] % 60).toString().padLeft(2, '0')}',
                          ),
                        )
                      else if (App.scores[i] == App.score)
                        ListTile(
                          leading: Text(
                            (i + 1).toString(),
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          title: Text(
                            App.scores[i]['player'],
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            App.scores[i]['coin'].toString(),
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Text(
                            '${(App.scores[i]['tempo'] ~/ 60).toString().padLeft(2, '0')}:${(App.scores[i]['tempo'] % 60).toString().padLeft(2, '0')}',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      else
                        ListTile(
                          leading: Text((i + 1).toString()),
                          title: Text(App.scores[i]['player']),
                          subtitle: Text(App.scores[i]['coin'].toString()),
                          trailing: Text(
                            '${(App.scores[i]['tempo'] ~/ 60).toString().padLeft(2, '0')}:${(App.scores[i]['tempo'] % 60).toString().padLeft(2, '0')}',
                          ),
                        ),
                  ],
                ),
        ),
      ),
    );
  }
}
