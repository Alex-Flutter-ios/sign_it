import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';

import '../../data/document_repository_impl.dart';
import '../../data/models/document.dart';

part 'documents_state.dart';

class DocumentsCubit extends Cubit<DocumentsState> {
  DocumentsCubit(this.repository) : super(DocumentsInitial());

  final DocumentRepository repository;
  List<Document> allDocuments = [];
  List<Document> filteredDocuments = [];

  void searchDocuments(String query) {
    if (state is! DocumentsLoaded) return;

    filteredDocuments = allDocuments
        .where((doc) => doc.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    emit(DocumentsLoaded(allDocuments, filteredDocuments: filteredDocuments));
  }

  Future<void> loadDocuments() async {
    try {
      emit(DocumentsLoading());
      final documents = await repository.getDocuments();
      allDocuments.clear();
      allDocuments = List.from(documents);
      emit(DocumentsLoaded(documents));
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }

  Future<void> scanDocument() async {
    try {
      emit(DocumentProcessing());
      final file = await _scanDocument();
      await _processFile(file, DocumentSource.scan);
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }

  Future<void> pickFromGallery() async {
    try {
      final file = await _pickImage();
      await _processFile(file, DocumentSource.gallery);
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }

  Future<void> pickFromFiles() async {
    try {
      final file = await _pickFile();
      await _processFile(file, DocumentSource.files);
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }

  Future<File> _scanDocument() async {
    try {
      final config = DocumentScannerConfiguration(
        multiPageEnabled: false,
        cancelButtonTitle: "Cancel",
      );
      final result = await ScanbotSdkUi.startDocumentScanner(config);

      if (result.operationResult != OperationResult.SUCCESS ||
          result.pages.isEmpty) {
        throw Exception("Error scanning document");
      }

      final filePath =
          result.pages.first.documentPreviewImageFileUri?.path ?? '';
      return File(filePath);
    } catch (e) {
      print("Scan error: $e");
      throw Exception("Error scanning document");
    }
  }

  Future<File> _pickImage() async {
    try {
      final result = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (result == null) throw Exception('No image selected');
      return File(result.path);
    } catch (e) {
      throw Exception('No image selected');
    }
  }

  Future<File> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx'],
    );
    if (result == null) throw Exception('No file selected');
    return File(result.files.single.path!);
  }

  Future<void> _processFile(File file, DocumentSource source) async {
    emit(DocumentProcessing());

    try {
      final needsConversion = _needsConversion(file);

      if (needsConversion) {
        final convertedFile = await _convertFile(file);
        final conversioResult = await repository.saveDocument(
          file: convertedFile,
          source: source,
          originalName: file.path.split('/').last,
        );
      } else {
        final saveConversioResult = await repository.saveDocument(
          file: file,
          source: source,
          originalName: file.path.split('/').last,
        );
      }

      await loadDocuments();
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }

  bool _needsConversion(File file) {
    final extension = file.path.split('.').last.toLowerCase();
    return extension != 'pdf';
  }

  Future<File> _convertFile(File file) async {
    try {
      final dio = Dio();
      final formData = FormData.fromMap({
        'kit': await MultipartFile.fromFile(file.path),
      });

      final response = await dio.post(
        'https://pdfconverterkit.click/converter_kit',
        data: formData,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode != 200) throw Exception('Conversion failed');

      final tempDir = await getTemporaryDirectory();
      final outputFile =
          File('${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.pdf');
      await outputFile.writeAsBytes(response.data);

      return outputFile;
    } catch (e) {
      throw Exception('Conversion failed: $e');
    }
  }
}
