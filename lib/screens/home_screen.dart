import 'dart:async';

import 'package:flutter/material.dart';
import 'package:roleta_animada/widgets/roleta_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // Declara o AnimationController que será usado no RoletaWidget
  AnimationController _animationController;
  // A duração em milissegundos em que a roleta vai ficar girando
  int _duration = 0;
  // A quantidade de vezes em qua a roleta irá dar voltas (1.0 == 1 volta; 1.5 == 1 volta e meia; 2.0 == 2 voltas)
  double _end = 0.0;
  // Declara o timer do tap do botão pra saber quanto tempo o usuário manteve pressionado
  Timer _tapTimer;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tapTimer.cancel();
    super.dispose();
  }

  void _start() {
    setState(() {
      // Altera a duração da animação e reinicia
      _animationController.duration = Duration(milliseconds: _duration);
      _animationController.forward(from: 0.0);
    });
  }

  void _onTapDown(TapDownDetails details) {
    // Reseta a duração sempre q o botão for tocado
    _duration = 0;
    _end = 0.0;

    // Recria o timer
    _tapTimer = Timer.periodic(Duration(milliseconds: 10), (Timer currentTimer) {
      // Verifica se a duração não ultrapassou os 5 segundos
      if (_duration < 5000) {
        // O calculo a seguir server pra aumentar a duração exponencialmente, ou seja, quanto mais tempo segurando o botão, a duração irá aumentar mais rapidamente
        _duration = ((_duration + 10) * 1.01).round();
        _end = (_end + 0.001) * 1.03;
      }
    });
  }

  void _onTapUp(TapUpDetails details) {
    // Cancela o timer e gira a roleta
    _tapTimer.cancel();
    _start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Roleta Animada'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
              child: Icon(Icons.arrow_drop_down, size: 45.0,),
            ),
            RoletaWidget(
              end: _end,
              animationController: _animationController,
              onStop: () {
                print('ANIMATION STOPPED!');
              },
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              child: RaisedButton(
                onPressed: () {},
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                padding: EdgeInsets.all(0.0),
                child: GestureDetector(
                  onTapDown: _onTapDown,
                  onTapUp: _onTapUp,
                  child: Container(
                    width: 80,
                    height: 40,
                    child: Icon(Icons.play_arrow),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8.0,),
          ],
        ),
      ),
    );
  }
}
