import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spin_the_wheel_app/providers/full_screen_state.dart';
import 'package:spin_the_wheel_app/providers/game_state.dart';
import 'package:spin_the_wheel_app/utils/export_to_excel.dart';
import 'package:spin_the_wheel_app/utils/results_card.dart';
import '../../utils/background_image.dart';
import '../home_screen.dart';

class GuestResultsScreen extends StatefulWidget {
  const GuestResultsScreen({super.key});

  @override
  _GuestResultsScreenState createState() => _GuestResultsScreenState();
}

class _GuestResultsScreenState extends State<GuestResultsScreen> {
  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    final theme = Theme.of(context);
    final fullscreenState =
    Provider.of<FullscreenState>(context, listen: false);
    return KeyboardListener(
        focusNode: fullscreenState.focusNode,
        autofocus: true,
        onKeyEvent: (KeyEvent event) {
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        fullscreenState.handleEscapeKey(event);
      }
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        fullscreenState.handleEnterKey(event);
      }
    },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          body: BackgroundImage(
            child: Column(
              children: [
                SizedBox(height: kToolbarHeight + 20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "Guest Results (2 Rounds Completed)",
                      style: theme.textTheme.labelLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: gameState.guestResults.length,
                    itemBuilder: (context, index) {
                      return ResultsCard(index: index, results: gameState.guestResults,);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ElevatedButton.icon(
                    onPressed: () => exportToExcel(
                      context,
                      results: gameState.guestResults,
                      fileName: "Guest Result",
                    ),
                    label: Text("Export to Excel"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20, top: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => HomeScreen()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("Back to Home"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
