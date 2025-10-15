import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';

class ReportService {
  final Dio _dio = Dio();
  final mediaStorePlugin = MediaStore();

  Future<String?> downloadCsv({
    required String startDate,
    required String endDate,
  }) async {
    try {
      final response = await _dio.get(
        "https://devi.cayangqu.com/tes1.php",
        options: Options(responseType: ResponseType.bytes),
      );

      final Uint8List bytes = Uint8List.fromList(response.data);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = "laporan_$timestamp.csv";

      if (Platform.isAndroid) {
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/$fileName');
        await tempFile.writeAsBytes(bytes);

        final savedUri = await mediaStorePlugin.saveFile(
          tempFilePath: tempFile.path,
          dirType: DirType.download,
          dirName: DirName.download,
        );

        if (savedUri != null) {
          final displayPath = "/storage/emulated/0/Download/$fileName";
          return displayPath;
        } else {
          throw Exception("Gagal menyimpan file");
        }
      } else {
        throw Exception("Platform tidak didukung");
      }
    } catch (e) {
      rethrow;
    }
  }
}