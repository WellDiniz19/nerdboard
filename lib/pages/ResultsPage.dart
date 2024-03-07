import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'dart:math';

class ResultsPage extends StatefulWidget {
  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  List<ParseObject> players = [];

  @override
  void initState() {
    super.initState();
    _getPlayers();
  }

  Future<void> _getPlayers() async {
    try {
      final query = QueryBuilder(ParseObject('_User'))..orderByDescending('ranking');
      final response = await query.query();
      setState(() {
        players = response.results as List<ParseObject>;
      });
    } catch (e) {
      print('Erro ao obter jogadores: $e');
      // Handle the error as needed
    }
  }

  List<List<ParseObject>> realizarSorteio() {
    List<List<ParseObject>> sorteios = [];

    // Clone the list of players to avoid modifying the original
    List<ParseObject> availablePlayers = List.from(players);

    while (availablePlayers.length >= 2) {
      final player1 = availablePlayers.removeAt(0);
      final player2 = _sortearOponente(player1, availablePlayers);
      availablePlayers.remove(player2);

      sorteios.add([player1, player2]);
    }

    return sorteios;
  }

  ParseObject _sortearOponente(ParseObject player, List<ParseObject> availablePlayers) {
    final random = Random();
    final index = random.nextInt(availablePlayers.length);
    return availablePlayers[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sorteio para Enfrentamento'),
      ),
      body: players.isEmpty
          ? Center(child: CircularProgressIndicator())
          : _buildSorteioList(),
    );
  }

  Widget _buildSorteioList() {
    final sorteios = realizarSorteio();

    return ListView.builder(
      itemCount: sorteios.length,
      itemBuilder: (context, index) {
        final player1 = sorteios[index][0];
        final player2 = sorteios[index][1];

        return ListTile(
          title: Text('${player1['username']} vs ${player2['username']}'),
        );
      },
    );
  }
}
