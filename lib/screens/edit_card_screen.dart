import 'package:flutter/material.dart';
import '../models/folder_model.dart';
import '../models/card_model.dart';

class EditCardScreen extends StatelessWidget {
  final Folder folder;

  EditCardScreen({required this.folder});

  @override
  Widget build(BuildContext context) {
    TextEditingController frontController = TextEditingController();
    TextEditingController backController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Neue Karte hinzufügen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: frontController, decoration: InputDecoration(labelText: 'Vorderseite')),
            TextField(controller: backController, decoration: InputDecoration(labelText: 'Rückseite')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Neue Karte zur Liste hinzufügen
                folder.cards.add(FlashCard(
                  front: frontController.text,
                  back: backController.text,
                ));
                Navigator.pop(context);
              },
              child: Text('Speichern'),
            ),
          ],
        ),
      ),
    );
  }
}
