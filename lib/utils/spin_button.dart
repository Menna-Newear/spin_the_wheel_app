import 'package:flutter/material.dart';

class SpinButton extends StatelessWidget {
  final bool isSpinning;
  final List<String> participants;
  final Function(int) onSpin;  // Callback when the spin action occurs
  final String buttonText;
  final Color? buttonColor;
  final Color? textColor;
  final TextStyle? textStyle;

  const SpinButton({
    Key? key,
    required this.isSpinning,
    required this.participants,
    required this.onSpin,
    this.buttonText = "SPIN", // Default to "SPIN"
    this.buttonColor,
    this.textColor,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: isSpinning
          ? null
          : () {
        if (participants.isEmpty) return;
        // Generate a random index to simulate spinning
        final int selectedIndex = _getRandomIndex(participants);
        onSpin(selectedIndex);  // Call the callback when spin happens
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        backgroundColor: buttonColor ?? theme.primaryColor,
        foregroundColor: textColor ?? theme.colorScheme.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        buttonText,
        style: textStyle ??
            TextStyle(fontSize: 20, color: textColor ?? Colors.white),
      ),
    );
  }

  // Function to generate a random index
  int _getRandomIndex(List<String> participants) {
    return (participants.isEmpty) ? 0 : (participants.length * (DateTime.now().millisecondsSinceEpoch % 1000) / 1000).floor();
  }
}
