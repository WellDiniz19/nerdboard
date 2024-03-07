import 'dart:async';

import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:nerdboard/models/GameRound.dart';
import 'package:provider/provider.dart';

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
  void dispose() {
    _missionPointsController.dispose();
    super.dispose();
  }

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
                _salvarResultadoJogo(context);
              },
              child: Text('Salvar Resultado'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _salvarResultadoJogo(BuildContext context) async {
    try {
      final missionPoints = int.parse(_missionPointsController.text);
      final player1 = await _buscarJogador(widget.player1Name);
      final player2 = await _buscarJogador(widget.player2Name);

      // Use the GameRoundProvider to save the result
      final gameRoundProvider = Provider.of<GameRoundProvider>(context, listen: false);
      await gameRoundProvider.saveGameRound(player1, player2, missionPoints);

      // Navigate to the Ranking page
      Navigator.pushReplacementNamed(context, '/ranking');
    } catch (e) {
      print('Erro ao salvar resultado do jogo: $e');
      // Handle the error more effectively (e.g., show a dialog to the user)
    }
  }

  Future<ParseObject?> _buscarJogador(String username) async {
    try {
      final query = QueryBuilder(ParseObject('Player'))..whereEqualTo('username', username);
      final response = await _queryWithTimeout(query, Duration(seconds: 2));

      if (response.results != null && response.results!.isNotEmpty) {
        return response.results!.first as ParseObject;
      } else {
        throw Exception('Jogador não encontrado');
      }
    } catch (e) {
      print('Erro ao buscar jogador: $e');
      // Handle the error more effectively (e.g., show a dialog to the user)
      rethrow;
    }
  }

  Future<ParseResponse> _queryWithTimeout(QueryBuilder query, Duration timeout) async {
    final Completer<ParseResponse> completer = Completer();
    Timer(timeout, () {
      completer.completeError(TimeoutException('Tempo esgotado. Verifique sua conexão com a internet.'));
    });

    try {
      final response = await query.query();
      completer.complete(response);
    } catch (e) {
      completer.completeError(e);
    }

    return completer.future;
  }
}

class GameRoundProvider extends ChangeNotifier {
  Future<void> saveGameRound(ParseObject? player1, ParseObject? player2, int missionPoints) async {
    try {
      if (player1 == null || player2 == null) {
        throw Exception('Jogadores não encontrados');
      }

      final gameRound = GameRound(player1: player1, player2: player2, missionPoints: missionPoints);
      await gameRound.GameRoundSave();
      notifyListeners();
    } catch (e) {
      print('Erro ao salvar resultado do jogo: $e');
      // Handle the error as needed
    }
  }
}
