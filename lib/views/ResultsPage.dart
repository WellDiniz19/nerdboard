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
      final query = QueryBuilder(ParseObject('_User'))
        ..orderByDescending('ranking');
      final response = await query.query();
      setState(() {
        players = response.results as List<ParseObject>;
      });
    } catch (e) {
      print('Erro ao obter jogadores: $e');
      // Trate o erro conforme necessário
    }
  }

  List<List<ParseObject>> realizarSorteio() {
    List<List<ParseObject>> sorteios = [];

    // Clonar a lista de jogadores para não modificar a original
    List<ParseObject> jogadoresDisponiveis = List.from(players);

    while (jogadoresDisponiveis.length >= 2) {
      final jogador1 = jogadoresDisponiveis.removeAt(0);
      final jogador2 = _sortearOponente(jogador1, jogadoresDisponiveis);
      jogadoresDisponiveis.remove(jogador2);

      sorteios.add([jogador1, jogador2]);
    }

    return sorteios;
  }

  ParseObject _sortearOponente(ParseObject jogador, List<ParseObject> jogadoresDisponiveis) {
    final random = Random();
    final index = random.nextInt(jogadoresDisponiveis.length);
    return jogadoresDisponiveis[index];
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
        final jogador1 = sorteios[index][0];
        final jogador2 = sorteios[index][1];

        return ListTile(
          title: Text('${jogador1['username']} vs ${jogador2['username']}'),
        );
      },
    );
  }
}
