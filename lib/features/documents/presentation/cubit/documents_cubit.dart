import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/document_repository_impl.dart';
import '../../data/models/document.dart';

part 'documents_state.dart';

class DocumentsCubit extends Cubit<DocumentsState> {
  DocumentsCubit(this.repository) : super(DocumentsInitial());

  final DocumentRepository repository;
  List<Document> _allDocuments = [];
  List<Document> _filteredDocuments = [];

  void searchDocuments(String query) {
    if (state is! DocumentsLoaded) return;

    _filteredDocuments = _allDocuments
        .where((doc) => doc.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    emit(DocumentsLoaded(_allDocuments, filteredDocuments: _filteredDocuments));
  }

  Future<void> loadDocuments() async {
    emit(DocumentsLoading());
    try {
      final documents = await repository.getDocuments();
      emit(DocumentsLoaded(documents));
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }

  Future<void> scanDocument() async {
    try {
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
    // Реализация сканирования с помощью библиотеки (например: scanbot_sdk)
    throw UnimplementedError();
  }

  Future<File> _pickImage() async {
    final picker = ImagePicker();
    final result = await picker.pickImage(source: ImageSource.gallery);
    if (result == null) throw Exception('No image selected');
    return File(result.path);
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
    emit(DocumentProcessing(file.path));

    try {
      if (_needsConversion(file)) {
        final convertedFile = await _convertFile(file);
        await repository.saveDocument(
          file: convertedFile,
          source: source,
          originalName: file.path.split('/').last,
        );
      } else {
        await repository.saveDocument(
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
    final dio = Dio();
    final formData = FormData.fromMap({
      'kit': await MultipartFile.fromFile(file.path),
    });

    final response = await dio.post(
      'https://pdfconverterkit.click/converter_kit',
      data: formData,
    );

    if (response.statusCode != 200) throw Exception('Conversion failed');

    final tempDir = await getTemporaryDirectory();
    final outputFile =
        File('${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.pdf');
    await outputFile.writeAsBytes(response.data);

    return outputFile;
  }
}
