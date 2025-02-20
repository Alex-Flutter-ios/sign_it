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

  Future<void> deleteDocument(String documentId) async {
    final document = _box.get(documentId);
    if (document != null) {
      // final file = File(document.path);
      // if (await file.exists()) {
      //   await file.delete();
      // }
      await _box.delete(documentId);
    }
  }
}
