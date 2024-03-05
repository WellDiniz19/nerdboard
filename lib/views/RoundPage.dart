import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class RoundPage extends StatefulWidget {
  final String player1Name;
  final String player2Name;

  RoundPage({required this.player1Name, required this.player2Name});

  @override
  _RoundPageState createState() => _RoundPageState();
}

class _RoundPageState extends State<RoundPage> {
  TextEditingController _missionPointsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Round'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Oponentes: ${widget.player1Name} vs ${widget.player2Name}'),
            SizedBox(height: 20),
            TextField(
              controller: _missionPointsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Mission Points'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _salvarResultadoJogo();
              },
              child: Text('Salvar Resultado'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _salvarResultadoJogo() async {
    try {
      final missionPoints = int.parse(_missionPointsController.text);
      final player1 = await _buscarJogador(widget.player1Name);
      final player2 = await _buscarJogador(widget.player2Name);


      // Registre o resultado do jogo no Parse Server
      final gameRound = GameRound();
      gameRound['player1'] = player1;
      gameRound['player2'] = player2;
      gameRound['mission_points'] = missionPoints;
      gameRound['victory_player1'] =
          _verificarVitoria(player1, player2, missionPoints);
      await gameRound.save();

      // Navegue para a tela de Ranking
      Navigator.pushReplacementNamed(context, '/ranking');
    } catch (e) {
      print('Erro ao salvar resultado do jogo: $e');
      // Trate o erro conforme necessário
    }
  }

  Future<ParseObject> _buscarJogador(String username) async {
    try {
      final query = QueryBuilder(ParseObject('Player'))
        ..whereEqualTo('username', username);
      final response = await query.query();
      return response.results!.first as ParseObject;
    } catch (e) {
      print('Erro ao buscar jogador: $e');
      // Trate o erro conforme necessário
      throw e;
    }
  }

  bool _verificarVitoria(
      ParseObject player1, ParseObject player2, int missionPoints) {
    // Lógica para verificar vitória com base nos missionPoints
    return player1['mission_points'] > player2['mission_points'];
  }
}
