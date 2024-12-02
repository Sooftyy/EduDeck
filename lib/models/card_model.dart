import 'package:hive/hive.dart';

part 'card_model.g.dart'; // Hive-Adapter generiert.

@HiveType(typeId: 0)
class FlashCard {
  @HiveField(0)
  String front;

  @HiveField(1)
  String back;

  FlashCard({required this.front, required this.back});
}
