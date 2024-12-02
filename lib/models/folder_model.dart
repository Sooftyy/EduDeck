import 'package:hive/hive.dart';
import 'card_model.dart';

part 'folder_model.g.dart';

@HiveType(typeId: 1)
class Folder {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<FlashCard> cards; // Keine `final` und keine `const` Liste

  // Konstruktor mit veränderlicher Liste
  Folder({required this.name, List<FlashCard>? cards})
      : cards = cards ?? []; // Standard: leere Liste
}
