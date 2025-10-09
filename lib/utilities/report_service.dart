import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:file_saver/file_saver.dart';

class ReportService {
  final Dio _dio = Dio();

  /// Mengunduh CSV dari server dan menyimpannya ke folder Download publik.
  /// Return: String path file hasil simpan.
  Future<String> downloadCsv({
    required String startDate,
    required String endDate,
  }) async {
    try {
      // Ambil file dari server
      final response = await _dio.get(
        "https://devi.cayangqu.com/tes1.php",
        options: Options(responseType: ResponseType.bytes),
      );

      // Konversi response ke bytes
      final Uint8List bytes = Uint8List.fromList(response.data);

      // Simpan ke folder Download publik via Scoped Storage
      final filePath = await FileSaver.instance.saveFile(
        name: "laporan_${DateTime.now().millisecondsSinceEpoch}",
        bytes: bytes,
        ext: "csv",
        mimeType: MimeType.csv,
      );

      return filePath; // ✅ return path string
    } catch (e) {
      throw Exception("Gagal mengunduh file CSV: $e");
    }
  }
}
