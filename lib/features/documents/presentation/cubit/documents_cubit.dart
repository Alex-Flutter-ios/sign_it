import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:printing/printing.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/document_repository_impl.dart';
import '../../data/models/document.dart';

import 'package:mime/mime.dart';

import 'package:path/path.dart' as p;

part 'documents_state.dart';

class DocumentsCubit extends Cubit<DocumentsState> {
  DocumentsCubit(this.repository) : super(DocumentsInitial());

  final DocumentRepository repository;
  List<Document> allDocuments = [];
  List<Document> filteredDocuments = [];

  void searchDocuments(String query) {
    if (state is! DocumentsLoaded) {
      return;
    }

    final lowerQuery = query.toLowerCase();
    filteredDocuments = allDocuments
        .where((doc) => doc.name.toLowerCase().contains(lowerQuery))
        .toList();

    emit(DocumentsLoaded(allDocuments, filteredDocuments: filteredDocuments));
  }

  Future<void> loadDocuments() async {
    try {
      emit(DocumentsLoading());
      final documents = await repository.getDocuments();
      allDocuments.clear();
      allDocuments = List.from(documents);
      filteredDocuments.clear();
      emit(DocumentsLoaded(documents));
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }

  Future<void> scanDocument() async {
    try {
      emit(DocumentProcessing());
      final file = await _scanDocument();
      if (file != null) {
        final originalName = p.basename(file.path);
        await _processFile(file, DocumentSource.scan, originalName);
      }
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }

  Future<void> pickFromGallery() async {
    try {
      emit(DocumentProcessing());
      final file = await _pickImage();
      if (file != null) {
        final originalName = p.basename(file.path);
        await _processFile(file, DocumentSource.gallery, originalName);
      }
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }

  Future<void> pickFromFiles() async {
    try {
      emit(DocumentProcessing());
      final file = await _pickFile();
      if (file != null) {
        final originalName = p.basename(file.path);
        await _processFile(file, DocumentSource.files, originalName);
      }
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }

  Future<File?> _scanDocument() async {
    try {
      final config = DocumentScannerConfiguration(
        multiPageEnabled: false,
        cancelButtonTitle: "Cancel",
      );
      final result = await ScanbotSdkUi.startDocumentScanner(config);

      // if (result.operationResult != OperationResult.SUCCESS ||
      //     result.operationResult != OperationResult.CANCELED ||
      //     result.pages.isEmpty) {
      //   // throw Exception("Error scanning document");
      // }
      if (result.operationResult == OperationResult.SUCCESS) {
        final filePath =
            result.pages.first.documentPreviewImageFileUri?.path ?? '';
        return File(filePath);
      }
    } catch (e) {
      print("Scan error: $e");
    }
    return null;
  }

  Future<File?> _pickImage() async {
    try {
      final result = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (result == null) throw Exception('No image selected');
      return File(result.path);
    } catch (e) {
      debugPrint('No image selected');
    }
    return null;
  }

  Future<File?> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx'],
      );
      if (result != null) {
        return File(result.files.single.path!);
      }
    } catch (e) {
      debugPrint('No file selected');
    }
    return null;
  }

  Future<void> _processFile(
    File file,
    DocumentSource source,
    String? originalName,
  ) async {
    emit(DocumentProcessing());
    try {
      final needsConversion = _needsConversion(file);
      final baseName = p.basenameWithoutExtension(originalName ?? 'Converted');
      final finalName = '$baseName.pdf';
      File documentFile;

      if (needsConversion) {
        documentFile = await _convertFile(file);
        await repository.saveDocument(
          file: documentFile,
          source: source,
          originalName: documentFile.path.split('/').last,
        );
      } else {
        await repository.saveDocument(
          file: file,
          source: source,
          originalName: finalName,
        );
      }

      await loadDocuments();
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }

  bool _needsConversion(File file) {
    final mimeType = lookupMimeType(file.path);
    return mimeType != 'application/pdf';
  }

  Future<File> _convertFile(File file) async {
    try {
      await _validateFile(file);
      final pdfFile = await repository.convertFileToPdf(file);
      return pdfFile;
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  Future<void> _validateFile(File file) async {
    if (!await file.exists()) {
      throw Exception('Source file does not exist');
    }
    if (await file.length() == 0) {
      throw Exception('Source file is empty');
    }
  }

  Future<void> shareDocument(Document doc) async {
    try {
      final file = File(doc.path);
      if (!file.existsSync()) {
        throw Exception("File didn't found: ${doc.path}");
      }

      Share.shareXFiles([XFile(doc.path)]);
    } catch (e) {
      emit(DocumentsError('Sharing error: $e'));
    }
  }

  Future<void> printDocument(Document doc) async {
    try {
      final file = File(doc.path);
      if (!file.existsSync()) {
        throw Exception("File didn't found: ${doc.path}");
      }

      final bytes = await file.readAsBytes();

      await Printing.layoutPdf(
        onLayout: (format) async => bytes,
      );
    } catch (e) {
      emit(DocumentsError('Printing error: $e'));
    }
  }

  Future<void> deleteDocument(String documentId) async {
    emit(DocumentProcessing());
    try {
      await repository.deleteDocument(documentId);
      await loadDocuments();
      if (state is DocumentsLoaded) {
        emit(DocumentsLoaded(allDocuments));
      }
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }
}
