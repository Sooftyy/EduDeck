import 'package:hive/hive.dart';
import '../models/folder_model.dart';

class LocalStorageService {
  Future<void> saveFolder(Folder folder) async {
    var box = await Hive.openBox<Folder>('folders');
    await box.add(folder);
  }

  Future<List<Folder>> getFolders() async {
    var box = await Hive.openBox<Folder>('folders');
    return box.values.toList();
  }
}
