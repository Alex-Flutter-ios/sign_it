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
  const DocumentsLoaded(this.documents, {this.filteredDocuments = const []});

  final List<Document> documents;
  final List<Document> filteredDocuments;
}

class DocumentProcessing extends DocumentsState {
  const DocumentProcessing();
}

class DocumentsError extends DocumentsState {
  const DocumentsError(this.message);

  final String message;
}

class DocumentConvertionProgress extends DocumentsState {
  const DocumentConvertionProgress(this.progress);

  final double progress;
}
