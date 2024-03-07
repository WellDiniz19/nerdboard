import 'dart:async';
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
      final query = QueryBuilder(ParseObject('Player'))
        ..orderByDescending('total_points');
      final response = await query.query();
      setState(() {
        players = response.results as List<ParseObject>;
      });
    } catch (e) {
      print('Erro ao obter jogadores: $e');
      // Handle the error as needed
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
          title: Text(player['username'] ?? 'Username não disponível'),
          subtitle: Text('Total Points: ${player['total_points'] ?? 0}'),
        );
      },
    );
  }

  // Function to update the total score when recording the game result
  Future<void> _updateTotalScore(
      ParseObject player, bool win, bool draw) async {
    try {
      int eventPoints = 0;

      if (win) {
        eventPoints = 3;
      } else if (draw) {
        eventPoints = 1;
      }

      final totalPoints = player['total_points'] ?? 0;
      final newScore = totalPoints + eventPoints;

      player['total_points'] = newScore;
      await player.save();
    } catch (e) {
      print('Error updating total score: $e');
      // Handle the error as needed
    }
  }
}
