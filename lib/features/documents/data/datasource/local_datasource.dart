import 'dart:io';

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
    final result = await _box.put(document.id, document);
    return document;
  }

  Future<String> saveFile(File file, String name) async {
    final appDir = await getApplicationDocumentsDirectory();
    final newFile = File('${appDir.path}/$name');
    await newFile.writeAsBytes(await file.readAsBytes());
    return newFile.path;
  }
}
