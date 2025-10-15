import 'package:flutter/material.dart';

class QrisStikerPage extends StatelessWidget {
  const QrisStikerPage({super.key});

  void _onShare(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Fitur Bagikan belum tersedia"),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _onDownload(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("QRIS Stiker berhasil diunduh"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔹 Panel Attention di atas
        Container(
          width: double.infinity,
          color: Colors.teal.withOpacity(0.1),
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info, color: Colors.teal),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "QR pembayaran yang biasanya ditempel pada Toko, Gerobak, atau Meja Kasir.",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.teal[900],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 🔹 Panel hijau toska berisi QRIS
        Expanded(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFF01BDB1).withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "Assets/Icons/qris_stiker.png",
                    width: 280,
                    height: 280,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "SATU QRIS UNTUK SEMUA",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 🔹 Tombol Bagikan & Download
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _onShare(context),
                  icon: const Icon(Icons.share, color: Colors.teal),
                  label: const Text("Bagikan",
                      style: TextStyle(color: Colors.teal)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Colors.teal),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _onDownload(context),
                  icon: const Icon(Icons.download, color: Colors.white),
                  label: const Text("Download",
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
