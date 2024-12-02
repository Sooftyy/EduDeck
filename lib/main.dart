import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/folder_model.dart';
import 'models/card_model.dart';
import 'package:edudeck/screens/folder_screen.dart'; // Importieren

void main() async {
  await Hive.initFlutter();

  // Hive-Adapter registrieren
  Hive.registerAdapter(FolderAdapter());
  Hive.registerAdapter(FlashCardAdapter());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduDeck',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FolderScreen(), // FolderScreen als Startbildschirm
    );
  }
}
