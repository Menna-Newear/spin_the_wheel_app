import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spin_the_wheel_app/providers/game_state.dart';


class ResultsCard extends StatelessWidget {
  int index;
  final List<Map<String, dynamic>> results;

  ResultsCard(
      {super.key,
       required this.results,
      required this.index});

  @override
  Widget build(BuildContext context) {
    Provider.of<GameState>(context);
    final theme = Theme.of(context);
    final result = results[index];

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: theme.primaryColor),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.primaryColor,
          foregroundColor: Colors.white,
          child: Text("${index + 1}"),
        ),
        title: Text(
          "${result['participant']}",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: theme.colorScheme.secondary),
        ),
        subtitle: Text(
          "Won: ${result['prize']}",
          style: TextStyle(color: theme.primaryColor),
        ),
      ),
    );
  }
}
