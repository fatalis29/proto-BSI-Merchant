import 'package:flutter/material.dart';
import '/utilities/report_service.dart'; // Pastikan path ini benar
import 'package:intl/intl.dart'; // Untuk format tanggal
import 'package:open_filex/open_filex.dart'; // Diperlukan untuk fungsi "Buka file"

class DownloadReportPage extends StatefulWidget {
  const DownloadReportPage({Key? key}) : super(key: key);

  @override
  _DownloadReportPageState createState() => _DownloadReportPageState();
}

class _DownloadReportPageState extends State<DownloadReportPage> {
  // --- BAGIAN LOGIKA & STATE (TIDAK ADA PERUBAHAN) ---
  final reportService = ReportService();
  DateTime? _startDate;
  DateTime? _endDate;
  final List<Map<String, dynamic>> _history = [];
  bool get _isFormValid => _startDate != null && _endDate != null;

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF007C80),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _downloadReport() async {
    try {
      final path = await reportService.downloadCsv(
        startDate: _startDate!.toIso8601String(),
        endDate: _endDate!.toIso8601String(),
      );

      setState(() {
        _history.insert(0, {
          "startDate": _startDate,
          "endDate": _endDate,
          "format": "CSV",
          "records": 1234, // placeholder
          "size": "-",
          "downloadedAt": DateTime.now(),
          "path": path,
        });
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Laporan disimpan di folder\n$path")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Gagal mengunduh laporan: $e")),
      );
    }
  }

  // --- AKHIR DARI BAGIAN LOGIKA & STATE ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Unduh Laporan",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReportFiltersCard(),
            const SizedBox(height: 24),
            _buildHistorySection(),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // HELPER WIDGETS (UNTUK MEMBANTU BUILD METHOD)
  // ==========================================================

  /// Membangun kartu UI untuk filter laporan.
  Widget _buildReportFiltersCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.description_outlined, color: Colors.black54),
              SizedBox(width: 8),
              Text("Report Filters",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const Text("Configure your report parameters below",
              style: TextStyle(color: Colors.black54, fontSize: 14)),
          const SizedBox(height: 16),
          const Text("Period", style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildDatePickerButton(isStart: true)),
              const SizedBox(width: 12),
              Expanded(child: _buildDatePickerButton(isStart: false)),
            ],
          ),
          const SizedBox(height: 16),
          const Text("Format", style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: "CSV",
            items: const [
              DropdownMenuItem(value: "CSV", child: Text("CSV")),
            ],
            onChanged: (value) {},
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildActionButton(isShare: true)),
              const SizedBox(width: 12),
              Expanded(child: _buildActionButton(isShare: false)),
            ],
          )
        ],
      ),
    );
  }

  /// Membangun UI untuk tombol pemilih tanggal.
  Widget _buildDatePickerButton({required bool isStart}) {
    final date = isStart ? _startDate : _endDate;
    final text = date == null
        ? (isStart ? "Start Date" : "End Date")
        : DateFormat('d MMM yyyy').format(date);

    return InkWell(
      onTap: () => _pickDate(isStart),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
            child: Text(text,
                style: const TextStyle(fontWeight: FontWeight.w500))),
      ),
    );
  }

  /// Membangun UI untuk tombol aksi (Bagikan/Download).
  Widget _buildActionButton({required bool isShare}) {
    return ElevatedButton(
      onPressed: _isFormValid ? (isShare ? () {} : _downloadReport) : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(isShare ? Icons.share_outlined : Icons.download_outlined,
              size: 24),
          const SizedBox(height: 4),
          Text(isShare ? "Bagikan" : "Download"),
        ],
      ),
    );
  }

  /// Membangun kartu UI untuk bagian riwayat unduhan.
  Widget _buildHistorySection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Download History",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Text("Your recent report downloads",
              style: TextStyle(color: Colors.black54, fontSize: 14)),
          const SizedBox(height: 16),
          _history.isEmpty
              ? const Center(
                  child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Text("Belum ada riwayat unduhan.",
                      style: TextStyle(color: Colors.grey)),
                ))
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    return _buildHistoryItem(_history[index]);
                  },
                )
        ],
      ),
    );
  }

  /// Membangun UI untuk setiap item di dalam daftar riwayat.
  /// FUNGSI DUPLIKAT DIHAPUS, HANYA MENYISAKAN SATU FUNGSI YANG BENAR.
  Widget _buildHistoryItem(Map<String, dynamic> item) {
    final startDate = DateFormat('d MMM yyyy').format(item['startDate']);
    final endDate = DateFormat('d MMM yyyy').format(item['endDate']);
    final downloadTime =
        DateFormat('M/d/yyyy\nh:mm a').format(item['downloadedAt']);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian kiri: info laporan
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("$startDate - $endDate",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4)),
                      child: Text(item['format'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                    const SizedBox(width: 8),
                    Text("${item['records']} records • ${item['size']}",
                        style: const TextStyle(color: Colors.black54)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Bagian kanan: waktu + tombol buka
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(downloadTime,
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              const SizedBox(height: 8),
              IconButton(
                icon: const Icon(Icons.open_in_new, size: 20),
                tooltip: "Buka file",
                onPressed: () async {
                  final path = item['path'];
                  if (path != null) {
                    await OpenFilex.open(path);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Path file tidak tersedia.")),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

