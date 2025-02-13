part of 'documents_cubit.dart';

sealed class DocumentsState {
  const DocumentsState();
}

class DocumentsInitial extends DocumentsState {
  const DocumentsInitial();
}

class DocumentsLoading extends DocumentsState {
  const DocumentsLoading();
}

class DocumentsLoaded extends DocumentsState {
  final List<Document> documents;
  final List<Document> filteredDocuments;

  const DocumentsLoaded(this.documents, {this.filteredDocuments = const []});
}

class DocumentProcessing extends DocumentsState {
  final String fileName;

  const DocumentProcessing(this.fileName);
}

class DocumentsError extends DocumentsState {
  final String message;

  const DocumentsError(this.message);
}

class DocumentConvertionProgress extends DocumentsState {
  final double progress;

  const DocumentConvertionProgress(this.progress);
}
