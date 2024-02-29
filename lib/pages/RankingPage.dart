import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class RankingPage extends StatefulWidget {
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  List<ParseObject> players = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getPlayersWithTimeout();
  }

  Future<void> _getPlayers() async {
    try {
      final query = QueryBuilder(ParseObject('Player'))..orderByDescending('total_points');
      final response = await query.query();
      final List<ParseObject>? results = response.results as List<ParseObject>?;

      if (results != null) {
        setState(() {
          players = results;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Erro: A lista de jogadores é nula.');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Erro ao obter jogadores: $e');
      // Trate outros erros conforme necessário
    }
  }

  Future<void> _getPlayersWithTimeout() async {
    try {
      await Future.delayed(Duration(seconds: 2), () {
        throw TimeoutException('Tempo esgotado. Verifique sua conexão com a internet.');
      });

      await _getPlayers();
    } on TimeoutException catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Erro de Timeout: $e');
      // Exiba um SnackBar, AlertDialog ou outra forma de informar o usuário sobre o timeout.
      _showTimeoutErrorSnackBar(context, e.message);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Erro ao obter jogadores: $e');
      // Trate outros erros conforme necessário
    }
  }

  void _showTimeoutErrorSnackBar(BuildContext context, String? message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Erro: $message'),
      duration: Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ranking'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : players.isEmpty
          ? Center(child: Text('Nenhum jogador encontrado.'))
          : _buildRankingList(),
    );
  }

  Widget _buildRankingList() {
    return ListView.builder(
      itemCount: players.length,
      itemBuilder: (context, index) {
        final player = players[index];

        return ListTile(
          title: Text(player['username'] ?? 'Username não disponível'),
          subtitle: Text('Total Points: ${player['total_points'] ?? 0}'),
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
