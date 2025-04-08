import 'dart:async';
import 'dart:io';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:provider/provider.dart';
import 'package:spin_the_wheel_app/providers/full_screen_state.dart';
import 'package:spin_the_wheel_app/providers/game_state.dart';
import '../../utils/background_image.dart';
import 'guest_prize_screen.dart';

class GuestSpinScreen extends StatefulWidget {
  const GuestSpinScreen({super.key});

  @override
  _GuestSpinScreenState createState() => _GuestSpinScreenState();
}

class _GuestSpinScreenState extends State<GuestSpinScreen> {
  final StreamController<int> _selectedController = StreamController<int>();
  bool _isSpinning = false;
  int? _currentSelection;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _selectedController.close();
    _confettiController.dispose();
    super.dispose();
  }

  Widget _buildConfirmationDialog(BuildContext context, String title,
      String content, VoidCallback onConfirm) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Stack(
        children: [
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Center(
                child: Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor))),
            content: Text(content,
                textAlign: TextAlign.center, style: theme.textTheme.titleSmall),
            actions: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _confettiController.stop();
                    onConfirm();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    backgroundColor: theme.primaryColor,
                    foregroundColor: theme.colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("OK",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      )),
                ),
              ),
            ],
          ),
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context, listen: false);
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
        body: BackgroundImage(
          child: Column(
            children: [
              SizedBox(height: kToolbarHeight + 10),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Guest Round ${gameState.guestCurrentRound + 1} of 2",
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: FortuneWheel(
                      animateFirst: false,
                      selected: _selectedController.stream,
                      items: [
                        for (var participant in gameState.guestParticipants)
                          FortuneItem(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 35, vertical: 15),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  participant,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                      indicators: <FortuneIndicator>[
                        FortuneIndicator(
                          alignment: Alignment.topCenter,
                          child: Column(
                            children: [
                              if (!Platform.isWindows)
                                SizedBox(
                                  height: 120,
                                ),
                              TriangleIndicator(
                                color: theme.colorScheme.secondary,
                                width: 20.0,
                                height: 20.0,
                                elevation: 0,
                              ),
                            ],
                          ),
                        ),
                      ],
                      onAnimationStart: () =>
                          setState(() => _isSpinning = true),
                      onAnimationEnd: () {
                        setState(() => _isSpinning = false);
                        if (_currentSelection != null &&
                            _currentSelection! <
                                gameState.guestParticipants.length) {
                          final selected =
                              gameState.guestParticipants[_currentSelection!];
                          _confettiController.play();
                          showDialog(
                            context: context,
                            builder: (_) => _buildConfirmationDialog(
                              context,
                              "Selected!",
                              "$selected was chosen!",
                              () {
                                // Set pending participant and confirm selection
                                gameState.guestPendingParticipant = selected;
                                gameState.confirmGuestParticipantSelection();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => GuestPrizeScreen()),
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 30, top: 10),
                child: ElevatedButton(
                  onPressed: _isSpinning
                      ? null
                      : () {
                          if (gameState.guestParticipants.isEmpty) return;
                          _currentSelection = gameState
                              .getRandomIndex(gameState.guestParticipants);
                          _selectedController.add(_currentSelection!);
                        },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("SPIN",
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
