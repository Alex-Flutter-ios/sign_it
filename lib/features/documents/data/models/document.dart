enum DocumentSource { scan, gallery, files }

class Document {
  final String id;
  final String name;
  final String path;
  final DateTime createdAt;
  final DocumentSource source;

  Document({
    required this.id,
    required this.name,
    required this.path,
    required this.createdAt,
    required this.source,
  });
}
