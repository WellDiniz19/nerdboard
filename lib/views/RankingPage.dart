import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class RankingPage extends StatefulWidget {
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  List<ParseObject> players = [];

  @override
  void initState() {
    super.initState();
    _getPlayers();
  }

  Future<void> _getPlayers() async {
    try {
      final query = QueryBuilder(ParseObject('Player'))..orderByDescending('total_points');
      final response = await query.query();
      setState(() {
        players = response.results as List<ParseObject>;
      });
    } catch (e) {
      print('Erro ao obter jogadores: $e');
      // Trate o erro conforme necessário
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ranking'),
      ),
      body: players.isEmpty
          ? Center(child: CircularProgressIndicator())
          : _buildRankingList(),
    );
  }

  Widget _buildRankingList() {
    return ListView.builder(
      itemCount: players.length,
      itemBuilder: (context, index) {
        final player = players[index];

        return ListTile(
          title: Text(player['username']),
          subtitle: Text('Total Points: ${player['total_points']}'),
        );
      },
    );
  }

  // Função para atualizar a pontuação total ao registrar o resultado do jogo
  Future<void> _atualizarPontuacaoTotal(ParseObject jogador, bool vitoria, bool empate) async {
    try {
      int eventPoints = 0;

      if (vitoria) {
        eventPoints = 3;
      } else if (empate) {
        eventPoints = 1;
      }

      final totalPoints = jogador['total_points'] ?? 0;
      final novaPontuacao = totalPoints + eventPoints;

      jogador['total_points'] = novaPontuacao;
      await jogador.save();
    } catch (e) {
      print('Erro ao atualizar a pontuação total: $e');
      // Trate o erro conforme necessário
    }
  }
}
