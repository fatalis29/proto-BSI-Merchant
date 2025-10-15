import 'package:flutter/material.dart';
import '/utilities/report_service.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';

class DownloadReportPage extends StatefulWidget {
  const DownloadReportPage({Key? key}) : super(key: key);

  @override
  _DownloadReportPageState createState() => _DownloadReportPageState();
}

class _DownloadReportPageState extends State<DownloadReportPage> {
  final reportService = ReportService();
  DateTime? _startDate;
  DateTime? _endDate;
  final List<Map<String, dynamic>> _history = [];
  bool get _isFormValid => _startDate != null && _endDate != null;
  bool _isLoading = false;

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF007C80)),
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
    if (!_isFormValid || _isLoading) return;

    setState(() => _isLoading = true);

    try {
      final String? path = await reportService.downloadCsv(
        startDate: _startDate!.toIso8601String(),
        endDate: _endDate!.toIso8601String(),
      );

      if (path != null) {
        setState(() {
          _history.insert(0, {
            "startDate": _startDate,
            "endDate": _endDate,
            "format": "CSV",
            "records": 1234,
            "size": "-",
            "downloadedAt": DateTime.now(),
            "path": path,
          });
        });

        if (!mounted) return;

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 28),
                SizedBox(width: 12),
                Text("Berhasil!"),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("File berhasil disimpan di folder Download"),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.teal[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    path.split('/').last,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Tutup"),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await OpenFilex.open(path);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF007C80)),
                child: Text("Buka"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 28),
              SizedBox(width: 12),
              Text("Gagal"),
            ],
          ),
          content: Text("Gagal mengunduh laporan: $e"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Tutup"),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
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

  Widget _buildReportFiltersCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.description_outlined, color: Colors.black54),
              SizedBox(width: 8),
              Text("Report Filters", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const Text("Configure your report parameters below", style: TextStyle(color: Colors.black54, fontSize: 14)),
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
            items: const [DropdownMenuItem(value: "CSV", child: Text("CSV"))],
            onChanged: (value) {},
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

  Widget _buildDatePickerButton({required bool isStart}) {
    final date = isStart ? _startDate : _endDate;
    final text = date == null ? (isStart ? "Start Date" : "End Date") : DateFormat('d MMM yyyy').format(date);

    return InkWell(
      onTap: () => _pickDate(isStart),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: date != null ? Color(0xFF007C80) : Colors.transparent, width: 2),
        ),
        child: Center(
          child: Text(text, style: TextStyle(fontWeight: FontWeight.w500, color: date != null ? Colors.black : Colors.black54)),
        ),
      ),
    );
  }

  Widget _buildActionButton({required bool isShare}) {
    final isDownloading = !isShare && _isLoading;

    return ElevatedButton(
      onPressed: _isFormValid && !_isLoading ? (isShare ? null : _downloadReport) : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: _isFormValid && !isShare ? Color(0xFF007C80) : Colors.grey[300],
        foregroundColor: _isFormValid && !isShare ? Colors.white : Colors.black54,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: isDownloading
          ? const SizedBox(
              height: 40,
              child: Center(
                child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(isShare ? Icons.share_outlined : Icons.download_outlined, size: 24),
                const SizedBox(height: 4),
                Text(isShare ? "Bagikan" : "Download"),
              ],
            ),
    );
  }

  Widget _buildHistorySection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Download History", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Text("Your recent report downloads", style: TextStyle(color: Colors.black54, fontSize: 14)),
          const SizedBox(height: 16),
          _history.isEmpty
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: Column(
                      children: [
                        Icon(Icons.history, size: 64, color: Colors.grey[300]),
                        SizedBox(height: 12),
                        Text("Belum ada riwayat unduhan.", style: TextStyle(color: Colors.grey[500], fontSize: 14)),
                      ],
                    ),
                  ),
                )
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

  Widget _buildHistoryItem(Map<String, dynamic> item) {
    final startDate = DateFormat('d MMM yyyy').format(item['startDate']);
    final endDate = DateFormat('d MMM yyyy').format(item['endDate']);
    final downloadTime = DateFormat('d/M/yyyy h:mm a').format(item['downloadedAt']);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("$startDate - $endDate", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: Colors.green[100], borderRadius: BorderRadius.circular(4)),
                      child: Text(item['format'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.green[800])),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text("${item['records']} records", style: const TextStyle(color: Colors.black54, fontSize: 12), overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(downloadTime, style: TextStyle(color: Colors.grey[600], fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.open_in_new, size: 22),
            tooltip: "Buka file",
            color: Color(0xFF007C80),
            padding: EdgeInsets.all(8),
            constraints: BoxConstraints(),
            onPressed: () async {
              final path = item['path'];
              if (path != null) {
                await OpenFilex.open(path);
              }
            },
          ),
        ],
      ),
    );
  }
}