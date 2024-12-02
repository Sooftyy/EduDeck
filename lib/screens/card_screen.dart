import 'package:flutter/material.dart';
import '../models/folder_model.dart';
import '../models/card_model.dart';

class CardScreen extends StatefulWidget {
  final Folder folder;

  CardScreen({required this.folder});

  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  int _currentCardIndex = 0;
  bool _isFlipped = false; // To check if the card is flipped
  List<FlashCard> _shuffledCards = []; // Cards in random order
  int _points = 0; // Points for completed training
  bool _isLearningMode = false; // Track if we're in learning mode or not

  @override
  void initState() {
    super.initState();
    _shuffledCards = List.from(widget.folder.cards)..shuffle(); // Shuffle cards when learning starts
  }

  // Function to flip the card (show front or back)
  void flipCard() {
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  // Function to go to the next card and check training completion
  void nextCard() {
    if (_isFlipped) { // Check if the card was flipped before advancing
      if (_currentCardIndex < _shuffledCards.length - 1) {
        setState(() {
          _currentCardIndex++;
          _isFlipped = false; // Reset to front of the card when going to next
        });
      } else {
        // If all cards have been shown, the training is complete
        setState(() {
          _points += 1; // Add a point for completing the training
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Training abgeschlossen!'),
              content: Text('Du hast alle Karten einmal durchgearbeitet.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    Navigator.pop(context); // Navigate back to the previous screen
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Inform the user to flip the card first
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bitte drehe die Karte um, bevor du fortfährst.')),
      );
    }
  }

  // Function to show the dialog for adding a new card
  void showAddCardDialog() {
    final TextEditingController frontController = TextEditingController();
    final TextEditingController backController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Neue Karte erstellen'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: frontController,
                decoration: InputDecoration(hintText: 'Vorderseite (Frage)'),
              ),
              TextField(
                controller: backController,
                decoration: InputDecoration(hintText: 'Rückseite (Antwort)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () {
                final frontText = frontController.text.trim();
                final backText = backController.text.trim();
                if (frontText.isNotEmpty && backText.isNotEmpty) {
                  setState(() {
                    widget.folder.cards.add(FlashCard(
                      front: frontText,
                      back: backText,
                    ));
                    _shuffledCards = List.from(widget.folder.cards)..shuffle(); // Reshuffle after adding a new card
                  });
                  Navigator.pop(context); // Close the dialog
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Bitte Vorder- und Rückseite ausfüllen!')),
                  );
                }
              },
              child: Text('Speichern'),
            ),
          ],
        );
      },
    );
  }

  // Function to toggle learning mode
  void toggleLearningMode() {
    setState(() {
      _isLearningMode = !_isLearningMode;
      if (_isLearningMode) {
        _shuffledCards = List.from(widget.folder.cards)..shuffle(); // Shuffle cards when starting learning mode
        _currentCardIndex = 0; // Reset card index
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folder.name),
        actions: [
          IconButton(
            icon: Icon(_isLearningMode ? Icons.list : Icons.play_arrow),
            onPressed: toggleLearningMode, // Toggle between learning mode and list mode
          ),
        ],
      ),
      body: _isLearningMode
          ? (_shuffledCards.isEmpty
          ? Center(child: Text('Keine Karten im Ordner'))
          : GestureDetector(
        onTap: flipCard, // Flip the card when tapped
        child: Center(
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isFlipped
                        ? _shuffledCards[_currentCardIndex].back
                        : _shuffledCards[_currentCardIndex].front,
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 20),
                  // Show "Next Card" button, but make it gray and disabled if the card isn't flipped
                  ElevatedButton(
                    onPressed: _isFlipped ? nextCard : null, // Disabled if card is not flipped
                    style: ElevatedButton.styleFrom(
                      primary: _isFlipped ? Colors.blue : Colors.grey, // Gray if disabled
                    ),
                    child: Text('Nächste Karte'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ))
          : ListView.builder(
        itemCount: widget.folder.cards.length,
        itemBuilder: (context, index) {
          final card = widget.folder.cards[index];
          return ListTile(
            title: Text(card.front),
            subtitle: Text(card.back),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddCardDialog, // Show the dialog to add a new card
        child: Icon(Icons.add),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('Punkte: $_points', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
