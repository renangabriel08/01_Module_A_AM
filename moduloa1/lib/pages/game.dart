import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:moduloa1/controllers/app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> with TickerProviderStateMixin {
  final playerBg = AudioPlayer();
  final playerPlayer = AudioPlayer();
  final playerCoin = AudioPlayer();
  final playerGameOver = AudioPlayer();

  int segndos = 0;
  int moedas = 10;
  Timer? timer;
  bool pause = false;
  bool perdeu = false;
  bool invencivel = false;

  double altura = 100.0;
  double coinSize = 30.0;
  double playerSize = 80.0;
  double obstaculoSize = 50.0;

  Offset playePosition = Offset(0, 0);

  AnimationController? controllerObstaculo;
  AnimationController? controllerArvore;
  AnimationController? controllerSalto;
  AnimationController? controllerCoin;
  Animation? leftObstaculo;
  Animation? leftArvore;
  Animation? leftCoin;
  Animation? salto;

  List arvores = [0, 1];

  double width = 0;
  double height = 0;

  pular() async {
    if (!pause && !perdeu) {
      await playerPlayer.play(AssetSource('jump.wav'));

      controllerSalto!.addListener(() {
        if (controllerSalto!.isCompleted) {
          controllerSalto!.reverse();
        }

        setState(() {});
      });
      controllerSalto!.forward();
    }
  }

  colidirMoeda() async {
    if (!pause && !perdeu) {
      moedas++;

      controllerCoin!.value = 0;
      await Future.delayed(const Duration(milliseconds: 500));
      animacaoCoin();
      setState(() {});

      await playerCoin.play(AssetSource('coin.wav'));
    }
  }

  colidirObstaculo() async {
    if (!invencivel) {
      perdeu = true;
      controllerCoin!.stop();
      controllerObstaculo!.stop();
      controllerArvore!.stop();
      playerBg.stop();
      await playerGameOver.play(AssetSource('game_over.wav'));
      Vibration.vibrate();

      App.score = {'player': App.nome.text, 'coin': moedas, 'tempo': segndos};
      App.scores.add(App.score);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('scores', jsonEncode(App.scores));

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Game Over'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Player Name: ${App.nome.text}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Container(height: 8),
                Row(
                  children: [
                    Image.asset('assets/coin.png', height: 16),
                    Container(width: 4),
                    Text(
                      moedas.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(height: 8),
                Text(
                  'Time: ${(segndos ~/ 60).toString().padLeft(2, '0')}:${(segndos % 60).toString().padLeft(2, '0')}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                segndos = 0;
                moedas = 10;
                timer?.cancel();
                pause = false;
                perdeu = false;

                startApp();
                Navigator.pop(context);
                setState(() {});
              },
              child: Text('Restart'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (route) => false,
                );
                Navigator.pushNamed(context, '/scores');
              },
              child: Text('Go To Ranks'),
            ),
          ],
        ),
      );
      setState(() {});
    }
  }

  pauseStart() {
    if (!perdeu) {
      pause = !pause;

      if (pause) {
        playerBg.pause();
        controllerCoin!.stop();
        controllerObstaculo!.stop();
        controllerArvore!.stop();
      } else {
        playerBg.resume();
        controllerCoin!.forward();
        controllerObstaculo!.forward();
        controllerArvore!.forward();
      }

      setState(() {});
    }
  }

  animacaoSalto() {
    controllerSalto = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    salto = Tween<double>(
      begin: 0,
      end: 90,
    ).animate(CurvedAnimation(parent: controllerSalto!, curve: Curves.linear));
  }

  animacaoObstaculo() {
    controllerObstaculo = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    leftObstaculo =
        Tween<double>(
          begin: width + obstaculoSize,
          end: -obstaculoSize,
        ).animate(
          CurvedAnimation(parent: controllerObstaculo!, curve: Curves.linear),
        );

    controllerObstaculo!.addListener(() {
      if (controllerObstaculo!.isCompleted) {
        controllerObstaculo!.repeat();
      }

      if (salto != null) {
        if (salto!.value < obstaculoSize &&
            leftObstaculo!.value <=
                (width / 2) - (playerSize / 2) + (obstaculoSize + 10) &&
            leftObstaculo!.value >=
                (width / 2) - (playerSize / 2) - (obstaculoSize / 2)) {
          colidirObstaculo();
        }
      }

      setState(() {});
    });
    controllerObstaculo!.forward();
  }

  animacaoArvore() {
    controllerArvore = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    leftArvore = Tween<double>(
      begin: width,
      end: -width,
    ).animate(CurvedAnimation(parent: controllerArvore!, curve: Curves.linear));

    controllerArvore!.addListener(() {
      if (controllerArvore!.isCompleted) {
        controllerArvore!.repeat();
      }

      setState(() {});
    });
    controllerArvore!.forward();
  }

  animacaoCoin() async {
    if (!pause && !perdeu) {
      controllerCoin = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
      );

      await Future.delayed(const Duration(milliseconds: 500));
      leftCoin = Tween<double>(
        begin: width + obstaculoSize,
        end: -obstaculoSize,
      ).animate(CurvedAnimation(parent: controllerCoin!, curve: Curves.linear));

      controllerCoin!.addListener(() {
        if (controllerCoin!.isCompleted) {
          controllerCoin!.repeat();
        }

        if (salto != null) {
          if (salto!.value < 80 &&
              leftCoin!.value <=
                  (width / 2) - (playerSize / 2) + (coinSize + 10)) {
            colidirMoeda();
          }
        }

        setState(() {});
      });
      await controllerCoin!.forward();
    }
  }

  iniciarAnimacao() async {
    await Future.delayed(const Duration(seconds: 1));

    animacaoSalto();
    animacaoObstaculo();
    animacaoCoin();
    animacaoArvore();
  }

  iniciarTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!pause && !perdeu) {
        segndos++;
        setState(() {});
      }
    });
  }

  startApp() async {
    Vibration.vibrate();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      width = MediaQuery.of(context).size.width;
      height = MediaQuery.of(context).size.height;

      iniciarAnimacao();
      iniciarTimer();

      await playerBg.play(AssetSource('bgm.mp3'));
    });
  }

  invencibilidade() async {
    if (!invencivel && moedas > 0) {
      invencivel = true;
      moedas--;
      setState(() {});
      await Future.delayed(const Duration(seconds: 1));
      invencibilidade();
    } else {
      invencivel = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    startApp();
    super.initState();
  }

  @override
  void dispose() {
    controllerObstaculo?.dispose();
    controllerCoin?.dispose();
    timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => pular(),
        onLongPress: () => invencibilidade(),
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              //Background
              SizedBox(
                width: width,
                height: height,
                child: Image.asset('assets/bg.jpg', fit: BoxFit.cover),
              ),

              //Arvores
              Positioned(
                bottom: 0,
                left: leftArvore?.value ?? width + obstaculoSize,
                child: SizedBox(
                  width: width,
                  height: altura * 4,
                  child: Image.asset('assets/trees.png'),
                ),
              ),

              //Obstaculos
              Positioned(
                bottom: altura - 10,
                left: leftObstaculo?.value ?? width + obstaculoSize,
                child: SizedBox(
                  width: obstaculoSize,
                  height: obstaculoSize,
                  child: Image.asset('assets/obstacle.png'),
                ),
              ),

              //Coins
              Positioned(
                bottom: altura + 10,
                left: leftCoin?.value ?? width + coinSize,
                child: SizedBox(
                  width: coinSize,
                  height: coinSize,
                  child: Image.asset('assets/coin.png'),
                ),
              ),

              //chão
              Positioned(
                bottom: 0,
                child: Container(
                  width: width,
                  height: altura,
                  color: Colors.white,
                ),
              ),

              //Player
              Positioned(
                bottom: salto?.value != null
                    ? altura - 10 + salto!.value
                    : altura - 10,
                left: (width / 2) - (playerSize / 2),
                child: SizedBox(
                  width: playerSize,
                  height: playerSize,
                  child: Image.asset('assets/skiing_person.png'),
                ),
              ),

              //Bg pause
              if (pause || perdeu)
                Opacity(
                  opacity: .4,
                  child: Container(
                    width: width,
                    height: height,
                    color: Colors.black,
                    child: Center(
                      child: Text(
                        'Game suspended...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

              //Btn pause
              Positioned(
                top: 30,
                child: Container(
                  width: width,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => pauseStart(),
                          icon: Icon(
                            pause ? Icons.play_arrow : Icons.pause,
                            color: Colors.black,
                            size: 40,
                          ),
                        ),

                        if (invencivel)
                          Text(
                            'Modo de invencibilidade',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                        //Dados do jogo
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Player Name: ${App.nome.text}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(height: 4),
                            Row(
                              children: [
                                Image.asset('assets/coin.png', height: 16),
                                Container(width: 4),
                                Text(
                                  moedas.toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Container(height: 4),
                            Text(
                              'Tempo: ${(segndos ~/ 60).toString().padLeft(2, '0')}:${(segndos % 60).toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
