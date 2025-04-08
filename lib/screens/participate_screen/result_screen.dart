import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spin_the_wheel_app/providers/game_state.dart';
import 'package:spin_the_wheel_app/utils/results_card.dart';
import '../../providers/full_screen_state.dart';
import '../../utils/background_image.dart';
import '../../utils/export_to_excel.dart';
import '../guest_screens/guest_screen.dart';
import '../home_screen.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 120));
    _confettiController.play();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final fullscreenState = Provider.of<FullscreenState>(context, listen: false);
      FocusScope.of(context).requestFocus(fullscreenState.focusNode);
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    final fullscreenState = Provider.of<FullscreenState>(context);
    final theme = Theme.of(context);
    return  KeyboardListener(
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
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                    colors: [
                      theme.primaryColor,
                      Colors.amber,
                      theme.colorScheme.secondary
                    ],
                  ),
                ),
                Column(children: [
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
                        "Game Results",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: gameState.results.length,
                      itemBuilder: (context, index) {
                        return ResultsCard(
                          index: index,
                          results: gameState.results,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ElevatedButton.icon(
                      onPressed: () => exportToExcel(
                        context,
                        results: gameState.results,
                        fileName: 'participate Results',
                      ),
                      icon: Icon(
                        Icons.file_download,
                        color: Colors.white,
                      ),
                      label: Text("Export to Excel"),
                    ),
                  ),
                ]),
                SizedBox(height: 20),
              ],
            ),
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton(
                heroTag: 'refreshButton',
                onPressed: () {
                  gameState.resetGame();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => HomeScreen()),
                    (route) => false,
                  );
                },
                child: Icon(Icons.refresh, color: Colors.white),
              ),
              SizedBox(height: 16),
              FloatingActionButton(
                heroTag: 'guestButton',
                onPressed: () {
                  gameState.startGuestMode();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => GuestSpinScreen()),
                  );
                },
                child: Icon(Icons.person_add, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
