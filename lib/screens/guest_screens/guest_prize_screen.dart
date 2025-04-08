import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spin_the_wheel_app/providers/full_screen_state.dart';
import 'package:spin_the_wheel_app/providers/game_state.dart';
import '../../utils/background_image.dart';
import 'guest_result_screen.dart';
import 'guest_screen.dart';

class GuestPrizeScreen extends StatelessWidget {
  const GuestPrizeScreen({super.key});

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
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            BackgroundImage(
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Selected Guest",
                        style: TextStyle(fontSize: 18, color: theme.primaryColor),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          gameState.guestSelectedParticipant ??
                              "No participant selected",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Prize Awarded",
                        style: TextStyle(fontSize: 18, color: theme.primaryColor),
                      ),
                      SizedBox(height: 10),
                      /*  Container(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          gameState.guestPrizes.isNotEmpty
                              ? gameState.guestPrizes[0]
                              : "No prize available",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),*/
                      Container(
                        padding: EdgeInsets.all(15),
                        child: ClipRect(
                            child: Image.asset(
                          "assets/images/${gameState.currentRound + 1}.png",
                          width: 1000,
                          height: 250,
                        )),
                      ),
                      SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {
                          gameState.confirmGuestPrizeSelection();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => gameState.isGuestGameComplete
                                  ? GuestResultsScreen()
                                  : GuestSpinScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          child: Text(
                            "CONTINUE",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController:
                    ConfettiController(duration: const Duration(seconds: 120)),
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: true,
                colors: [
                  theme.colorScheme.primary,
                  Colors.amber,
                  theme.colorScheme.secondary
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
