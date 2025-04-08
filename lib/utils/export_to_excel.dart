import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:spin_the_wheel_app/providers/game_state.dart';


Future<void> exportToExcel(BuildContext context,
    {required List<Map<String, dynamic>> results, required String fileName}) async {
  final gameState = Provider.of<GameState>(context, listen: false);

  try {
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];

    // Headers
    sheet.cell(CellIndex.indexByString("A1")).value = "No.";
    sheet.cell(CellIndex.indexByString("B1")).value = "Participant";
    sheet.cell(CellIndex.indexByString("C1")).value = "Prize";

    // Data
    for (int i = 0; i < results.length; i++) {
      final row = results[i];
      sheet.cell(CellIndex.indexByString("A${i + 2}")).value = i + 1;
      sheet.cell(CellIndex.indexByString("B${i + 2}")).value =
      row['participant'];
      sheet.cell(CellIndex.indexByString("C${i + 2}")).value = row['prize'];
    }

    // Get directory (Cross-platform solution)
    Directory? dir;
    if (Platform.isWindows) {
      dir = Directory('${Platform.environment['USERPROFILE']}\\Downloads');
    } else {
      dir = await getApplicationDocumentsDirectory();
    }
    // Save to Downloads (Windows)
    //final downloadsDir = await getDownloadsDirectory();
    //final filePath = '${downloadsDir?.path}\\LuckySpin_Results.xlsx';
    final filePath = '${dir.path}/$fileName.xlsx';

    // Write file
    final file = File(filePath);
    await file.writeAsBytes(excel.encode() ?? []);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Excel file saved at: $filePath')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
  }
}