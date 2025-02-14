import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class DocumentRemoteDataSource {
  DocumentRemoteDataSource(this._dio);

  final Dio _dio;

  Future<File> convertToPdf(File file) async {
    final formData = FormData.fromMap({
      'kit': await MultipartFile.fromFile(file.path),
    });

    final response = await _dio.post(
      'https://pdfconverterkit.click/converter_kit',
      data: formData,
      onSendProgress: (sent, total) {},
    );

    final tempDir = await getTemporaryDirectory();
    final outputFile = File(
        '${tempDir.path}/converted_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await outputFile.writeAsBytes(response.data);
    return outputFile;
  }
}
