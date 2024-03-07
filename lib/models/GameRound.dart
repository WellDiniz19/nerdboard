import 'package:parse_server_sdk/parse_server_sdk.dart';

class GameRound {
  final ParseObject player1;
  final ParseObject player2;
  final int missionPoints;

  GameRound({
    required this.player1,
    required this.player2,
    required this.missionPoints,
  });

  Future<void> GameRoundSave() async {
    try {
      final roundObject = ParseObject('GameRound')
        ..set('player1', player1)
        ..set('player2', player2)
        ..set('missionPoints', missionPoints);

      await roundObject.save();
    } catch (e) {
      print('Error saving GameRound: $e');
      // Handle the error as needed
      rethrow;
    }
  }
}
