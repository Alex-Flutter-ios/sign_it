import 'package:hive_flutter/hive_flutter.dart';

import '../../features/documents/data/models/document.dart';

class DocumentAdapter extends TypeAdapter<Document> {
  @override
  final int typeId = 0;

  @override
  Document read(BinaryReader reader) {
    return Document(
      id: reader.read(),
      name: reader.read(),
      path: reader.read(),
      createdAt: DateTime.parse(reader.read()),
      source: DocumentSource.values[reader.read()],
    );
  }

  @override
  void write(BinaryWriter writer, Document obj) {
    writer.write(obj.id);
    writer.write(obj.name);
    writer.write(obj.path);
    writer.write(obj.createdAt.toIso8601String());
    writer.write(obj.source.index);
  }
}
