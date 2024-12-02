import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/folder_model.dart';
import 'card_screen.dart';


class FolderScreen extends StatefulWidget {
  @override
  _FolderScreenState createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  // Liste von Ordnern
  List<Folder> folders = [];

  // Box für Hive
  late Box<Folder> folderBox;

  @override
  void initState() {
    super.initState();
    loadFolders();
  }

  // Folders aus Hive laden
  void loadFolders() async {
    folderBox = await Hive.openBox<Folder>('foldersBox');
    setState(() {
      folders = folderBox.values.toList();
    });
  }

  // Neuen Ordner hinzufügen
  void addFolder(String folderName) {
    final newFolder = Folder(name: folderName);
    folderBox.add(newFolder); // In Hive speichern
    setState(() {
      folders.add(newFolder); // Lokale Liste aktualisieren
    });
  }

  // Ordner löschen Menu (Are you sure Menu)
  void showDeleteConfirmationDialog(BuildContext context, int index, Function deleteFolder) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('The folder will get permanently deleted.'),
          actions: <Widget>[
            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without doing anything
              },
              child: Text('Cancel'),
            ),
            // Delete Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                deleteFolder(index); // Run the delete function
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Ordner löschen
  void deleteFolder(int index) {
    folderBox.deleteAt(index); // Aus Hive löschen
    setState(() {
      folders.removeAt(index); // Lokale Liste aktualisieren
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Folders'),
      ),
      body: folders.isEmpty
          ? Center(
        child: Text(
          'No folders yet. Add one!',
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: folders.length,
        itemBuilder: (context, index) {
          final folder = folders[index];
          return ListTile(
            title: Text(folder.name),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                showDeleteConfirmationDialog(context, index, deleteFolder);
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CardScreen(folder: folders[index]))
              );
              print('Navigiere zu ${folder.name}');
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddFolderDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Dialog zum Hinzufügen eines Ordners
  void showAddFolderDialog(BuildContext context) {
    final TextEditingController folderNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Folder'),
          content: TextField(
            controller: folderNameController,
            decoration: InputDecoration(hintText: 'Folder Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Dialog schließen
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final folderName = folderNameController.text.trim();
                if (folderName.isNotEmpty) {
                  addFolder(folderName);
                  Navigator.pop(context); // Dialog schließen
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
