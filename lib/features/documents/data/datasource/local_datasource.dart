import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../models/document.dart';

class DocumentLocalDataSource {
  final Box<Document> _box;

  DocumentLocalDataSource(this._box);

  Future<List<Document>> getDocuments() async {
    return _box.values.toList();
  }

  Future<Document> saveDocument(Document document) async {
    await _box.put(document.id, document);
    return document;
  }

  Future<String> saveFile(File file, String name) async {
    final appDir = await getApplicationDocumentsDirectory();
    final newFile = File('${appDir.path}/$name');
    await newFile.writeAsBytes(await file.readAsBytes());
    if (await newFile.exists()) {
      debugPrint('File saved successfully: ${newFile.path}');
    } else {
      debugPrint('Failed to save file: ${newFile.path}');
    }
    return newFile.path;
  }

  Future<void> deleteDocument(String id) async {
    final keyToDelete = _box.keys.firstWhere(
      (key) => (_box.get(key) as Document).id == id,
      orElse: () => null,
    );
    if (keyToDelete != null) {
      _box.delete(keyToDelete);
      final taskList = _box.values.map((e) => e).toList();
      debugPrint('TASKS IN BOX: ${taskList.length}');
    }
  }
}
