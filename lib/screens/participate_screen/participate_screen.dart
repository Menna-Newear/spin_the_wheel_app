import 'dart:async';
import 'dart:io';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:spin_the_wheel_app/providers/full_screen_state.dart';
import 'package:spin_the_wheel_app/providers/game_state.dart';
import 'package:spin_the_wheel_app/screens/participate_screen/prize_screen.dart';
import 'package:spin_the_wheel_app/utils/spin_button.dart';
import '../../utils/background_image.dart';

class ParticipantSpinScreen extends StatefulWidget {
  const ParticipantSpinScreen({super.key});

  @override
  _ParticipantSpinScreenState createState() => _ParticipantSpinScreenState();
}

class _ParticipantSpinScreenState extends State<ParticipantSpinScreen> {
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

  Widget _buildConfettiDialog(
      BuildContext context, String title, String content) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Stack(
        children: [
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
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
                    Provider.of<GameState>(context, listen: false)
                        .confirmParticipantSelection();
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => PrizeScreen()),
                    );
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
                      style: TextStyle(fontSize: 18, color: Colors.white)),
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
    ScreenUtil.init(context, designSize: Size(1920, 1080), minTextAdapt: true);

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
                    "Round ${gameState.currentRound + 1} of 13",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.secondary),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: FortuneWheel(
                        alignment: Alignment.topCenter,
                        animateFirst: false,
                        selected: _selectedController.stream,
                        items: [
                          for (var participant in gameState.participants)
                            FortuneItem(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 35, vertical: 15),
                                  child: Text(
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    participant,
                                    style: TextStyle(

                                      fontSize: 20.sp,
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
                            child: Column(
                              children: [
                                if (!Platform.isWindows)
                                  SizedBox(
                                    height: 0,
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
                                  gameState.participants.length) {
                            gameState.pendingParticipant =
                                gameState.participants[_currentSelection!];
                            _confettiController.play();

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => _buildConfettiDialog(
                                context,
                                "Selected!",
                                "${gameState.pendingParticipant} was chosen!",
                              ),
                            );
                          }
                        },
                      )),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(bottom: 30, top: 10),
                  child: SpinButton(
                      isSpinning: _isSpinning,
                      participants: gameState.participants,
                      onSpin: (int selectedIndex) {
                        setState(() {
                          _currentSelection = selectedIndex;
                          _selectedController.add(selectedIndex);
                        });
                      })),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
