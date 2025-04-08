

import 'dart:io';
import 'dart:math';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class GameState extends ChangeNotifier {
  // Main game properties
  List<String> participants = [
    "احمد خليل",
    "ايناس حسين",
    "محمد بدوى",
    "مايكل هنرى",
    "امير",
    "اسامة",
    "احمد مهران",
    "احمد شاكر",
    "ادهم",
    "خالد طه",
    "محمد شاهين",
    "مصطفى قاسم",
    "اسراء",
    "احمد نوير",
    "منة احمد"
  ];
  List<String> prizes = [
    "1000",
    "1000",
    "1000",
    "2500",
    "2500",
    "2500",
    "2500",
    "5000",
    "5000",
    "5000",
    "7000",
    "7000",
    "10000"
  ];
  List<Map<String, String>> results = [];
  int currentRound = 0;
  String? selectedParticipant;
  String? selectedPrize;
  String? pendingParticipant;
  String? pendingPrize;

  // Guest mode properties
  List<String> guestParticipants = [
    "محمد ايمن",
    "مصلح رجب",
    "احمد سمير",
    "عبدالرحمن",
    "احمد حمدى",
    "محمود توفيق",
    "كريم"
  ];
  List<String> guestPrizes = ["1000", "1000"];
  List<Map<String, String>> guestResults = [];
  int guestCurrentRound = 0;
  String? guestPendingParticipant;
  String? guestPendingPrize;

  String? guestSelectedParticipant;
  String? guestSelectedPrize;
  bool isGuestMode = false;

  // Main game methods
  void confirmParticipantSelection() {
    if (pendingParticipant != null) {
      participants.remove(pendingParticipant);
      selectedParticipant = pendingParticipant;
      pendingParticipant = null;
      notifyListeners();
    }
  }

  void confirmPrizeSelection() {
    if (selectedParticipant != null && prizes.isNotEmpty) {
      selectedPrize = prizes[0];
      results
          .add({"participant": selectedParticipant!, "prize": selectedPrize!});
      prizes.removeAt(0);
      selectedParticipant = null;
      currentRound++;
      notifyListeners();
    }
  }

  bool get isGameOver => currentRound >= 13 || prizes.isEmpty;

  void resetGame() {
    participants = [
      "احمد خليل",
      "ايناس حسين",
      "محمد بدوى",
      "مايكل هنرى",
      "امير",
      "اسامة",
      "احمد مهران",
      "احمد شاكر",
      "ادهم",
      "خالد طه",
      "محمد شاهين",
      "مصطفى قاسم",
      "اسراء",
      "احمد نوير",
      "منة احمد"
    ];
    prizes = [
      "1000",
      "1000",
      "1000",
      "2500",
      "2500",
      "2500",
      "2500",
      "5000",
      "5000",
      "5000",
      "7000",
      "7000",
      "10000"
    ];
    results.clear();
    currentRound = 0;
    selectedParticipant = null;
    selectedPrize = null;
    pendingParticipant = null;
    pendingPrize = null;
    notifyListeners();
  }

  // Guest mode methods
  void startGuestMode() {
    isGuestMode = true;
    List<String> guestParticipants = [
      "محمد ايمن",
      "مصلح رجب",
      "احمد سمير",
      "عبدالرحمن",
      "احمد حمدى",
      "محمود توفيق",
      "كريم"
    ];
    List<String> guestPrizes = ["1000", "1000"];
    guestResults.clear();
    guestCurrentRound = 0;
    guestSelectedParticipant = null;
    guestSelectedPrize = null;
    notifyListeners();
  }

  void confirmGuestParticipantSelection() {
    if (guestPendingParticipant != null) {
      guestParticipants.remove(guestPendingParticipant);
      guestSelectedParticipant = guestPendingParticipant;
      guestPendingParticipant = null;
      notifyListeners();
    }
  }

  void confirmGuestPrizeSelection() {
    if (guestSelectedParticipant != null && guestPrizes.isNotEmpty) {
      guestSelectedPrize = guestPrizes[0];
      guestResults.add({
        "participant": guestSelectedParticipant!,
        "prize": guestSelectedPrize!
      });
      guestPrizes.removeAt(0);
      guestSelectedParticipant = null;
      guestCurrentRound++;
      notifyListeners();

      if (!isGuestGameComplete) {
        guestSelectedParticipant = null;
      }
    }
  }

  bool get isGuestGameComplete => guestCurrentRound >= 2;

  int getRandomIndex(List list) => Random().nextInt(list.length);

  Future<void> exportGuestResultsToExcel() async {
    try {
      // Create a new Excel document
      final excel = Excel.createExcel();
      final sheet = excel['Guest Results'];

      // Add headers with styling
      final CellStyle headerStyle = CellStyle(
        backgroundColorHex: "#EE3035",
        fontColorHex: "#FFFFFF",
        bold: true,
      );

      sheet.cell(CellIndex.indexByString('A1')).value = 'Round';
      sheet.cell(CellIndex.indexByString('A1')).cellStyle = headerStyle;

      sheet.cell(CellIndex.indexByString('B1')).value = 'Participant';
      sheet.cell(CellIndex.indexByString('B1')).cellStyle = headerStyle;

      sheet.cell(CellIndex.indexByString('C1')).value = 'Prize';
      sheet.cell(CellIndex.indexByString('C1')).cellStyle = headerStyle;

      // Add data rows
      for (int i = 0; i < guestResults.length; i++) {
        final result = guestResults[i];
        sheet.cell(CellIndex.indexByString('A${i + 2}')).value = i + 1;
        sheet.cell(CellIndex.indexByString('B${i + 2}')).value = result['participant'];
        sheet.cell(CellIndex.indexByString('C${i + 2}')).value = result['prize'];
      }

      // Auto-size columns
      sheet.setColAutoFit(0);
      sheet.setColAutoFit(1);
      sheet.setColAutoFit(2);

      // Get the Downloads directory path
      final downloadsDir = await getDownloadsDirectory();
      if (downloadsDir == null) {
        throw Exception('Could not access Downloads directory');
      }

      // Create file path
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${downloadsDir.path}\\Guest_Results_$timestamp.xlsx';
      final file = File(filePath);

      // Save file
      final excelBytes = excel.encode();
      if (excelBytes == null) {
        throw Exception('Failed to encode Excel data');
      }

      await file.writeAsBytes(excelBytes, flush: true);

      // Open the file
      final result = await OpenFile.open(filePath);
      if (result.type != ResultType.done) {
        throw Exception('Failed to open file: ${result.message}');
      }

    } catch (e) {
      print('Export error: $e');
      rethrow;
    }
  }



}