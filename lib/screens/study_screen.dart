import 'package:flutter/material.dart';
import '../models/folder_model.dart';
import 'card_screen.dart';
import 'package:hive/hive.dart';

class StudyScreen extends StatefulWidget {
  @override
  _StudyScreenState createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  List<Folder> folders = [];
  late Box<Folder> folderBox;
  int _points = 0; // Gesamtpunktzahl für alle Ordner

  @override
  void initState() {
    super.initState();
    loadFolders();
  }

  // Laden der Ordner aus Hive
  void loadFolders() async {
    folderBox = await Hive.openBox<Folder>('foldersBox');
    setState(() {
      folders = folderBox.values.toList();
    });
  }

  // Funktion zum Starten des Lernens für einen Ordner
  void startLearning(Folder folder) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CardScreen(folder: folder),
      ),
    );
  }

  // Funktion für das abschließen des Trainings (Punkte speichern)
  void addPoints() {
    setState(() {
      _points++; // Punkt für das abgeschlossene Training
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Study Folders'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text('Punkte: $_points')),
          ),
        ],
      ),
      body: folders.isEmpty
          ? Center(child: Text('No folders available. Create one!'))
          : ListView.builder(
        itemCount: folders.length,
        itemBuilder: (context, index) {
          final folder = folders[index];
          return ListTile(
            title: Text(folder.name),
            trailing: IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: () => startLearning(folder), // Lerne-Start für den Ordner
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Hier kann der Dialog zum Hinzufügen eines neuen Ordners eingebaut werden
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
