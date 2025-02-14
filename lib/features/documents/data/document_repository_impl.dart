import 'dart:io';

import 'package:uuid/uuid.dart';

import 'datasource/local_datasource.dart';
import 'datasource/remote_datasource.dart';
import 'models/document.dart';

class DocumentRepository {
  DocumentRepository(
      {required this.localDataSource, required this.remoteDataSource});

  final DocumentLocalDataSource localDataSource;
  final DocumentRemoteDataSource remoteDataSource;

  Future<List<Document>> getDocuments() => localDataSource.getDocuments();

  Future<Document> saveDocument({
    required File file,
    required DocumentSource source,
    String? originalName,
  }) async {
    final name = _generateDocumentName(source, originalName);
    final path = await localDataSource.saveFile(file, name);

    final document = Document(
      id: Uuid().v4(),
      name: name,
      path: path,
      createdAt: DateTime.now(),
      source: source,
    );

    return localDataSource.saveDocument(document);
  }

  String _generateDocumentName(DocumentSource source, String? originalName) {
    if (originalName != null && originalName.isNotEmpty) {
      return originalName;
    }

    return 'Imported document';
    // switch (source) {
    //   case DocumentSource.scan:
    //     return 'Scan document';
    //   case DocumentSource.gallery:
    //     return 'Gallery document';
    //   case DocumentSource.files:
    //     return originalName ?? 'Imported document';
    // }
  }
}
