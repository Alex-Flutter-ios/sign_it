import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class DocumentRemoteDataSource {
  final Dio _dio;

  DocumentRemoteDataSource(this._dio);

  Future<String> convertFileToPdf(File file) async {
    final formData = FormData.fromMap({
      'kit': await MultipartFile.fromFile(
        file.path,
        filename: 'document.${file.path.split('.').last}',
      ),
    });

    final response = await _dio.post<String>(
      'https://pdfconverterkit.click/converter_kit',
      data: formData,
      options: Options(
        responseType: ResponseType.plain,
        validateStatus: (status) => status == 200,
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Server error: ${response.statusCode}');
    }

    final pdfUrl = response.data?.replaceAll('"', '');
    if (pdfUrl == null || !pdfUrl.startsWith('http')) {
      throw FormatException('Invalid PDF URL: $pdfUrl');
    }

    return pdfUrl;
  }

  Future<File> downloadPdfFile(String pdfUrl) async {
    final pdfResponse = await _dio.get<List<int>>(
      pdfUrl,
      options: Options(
        responseType: ResponseType.bytes,
        validateStatus: (status) => status == 200,
      ),
    );

    final bytes = pdfResponse.data;
    if (bytes == null || bytes.isEmpty) {
      throw Exception('Failed to download PDF file');
    }

    final tempDir = await getTemporaryDirectory();
    final outputFile =
        File('${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.pdf');
    await outputFile.writeAsBytes(bytes);

    return outputFile;
  }

  // Future<Uint8List> downloadPdfFile(String url) async {
  //   final response = await _dio.get<List<int>>(
  //     url,
  //     options: Options(responseType: ResponseType.bytes),
  //   );

  //   if (response.data == null || response.data!.isEmpty) {
  //     throw Exception('Empty PDF response');
  //   }

  //   return Uint8List.fromList(response.data!);
  // }
}
