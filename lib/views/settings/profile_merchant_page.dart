import 'package:flutter/material.dart';

/// Model sederhana untuk profil merchant (bisa diisi dari API nanti)
class MerchantProfile {
  final String merchantId;
  final String namaMerchant;
  final String alamat;
  final String email;
  final String namaPenanggungJawab;
  final String noPonsel;
  final String nik;
  final String namaBank;
  final String noRekening;
  final String namaPemilikRekening;

  MerchantProfile({
    required this.merchantId,
    required this.namaMerchant,
    required this.alamat,
    required this.email,
    required this.namaPenanggungJawab,
    required this.noPonsel,
    required this.nik,
    required this.namaBank,
    required this.noRekening,
    required this.namaPemilikRekening,
  });
}

class ProfileMerchantPage extends StatelessWidget {
  const ProfileMerchantPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔹 Contoh data (nanti bisa diganti dari API/backend)
    final profile = MerchantProfile(
      merchantId: "0000537309",
      namaMerchant: "Toko Tiga Lebih",
      alamat: "Jl. Kedoya no.1, Kedoya Selatan, Kebon Jeruk, Jakarta Barat, 11520",
      email: "Hi.tokotigalebih@gmail.com",
      namaPenanggungJawab: "Monica Putri",
      noPonsel: "081220944627",
      nik: "120144194",
      namaBank: "Bank Syariah Indonesia",
      noRekening: "7541202046219",
      namaPemilikRekening: "Monica Putri",
    );

    return Scaffold(
      backgroundColor: Colors.grey[100], // sama dengan halaman Pengaturan
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Profil Merchant",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Bagian Profile Merchant
                const Text(
                  "PROFILE MERCHANT",
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 12),
                _buildInfoRow("Merchant ID", profile.merchantId),
                _buildInfoRow("Nama Merchant", profile.namaMerchant),
                _buildInfoRow("Alamat", profile.alamat),
                _buildInfoRow("Email", profile.email),

                const SizedBox(height: 20),

                // 🔹 Bagian Penanggung Jawab
                const Text(
                  "PENANGGUNG JAWAB",
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 12),
                _buildInfoRow("Nama", profile.namaPenanggungJawab),
                _buildInfoRow("No. Ponsel", profile.noPonsel),
                _buildInfoRow("NIK", profile.nik),

                const SizedBox(height: 20),

                // 🔹 Bagian Rekening Bank
                const Text(
                  "REKENING BANK",
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 12),
                _buildInfoRow("Nama Bank", profile.namaBank),
                _buildInfoRow("No. Rekening", profile.noRekening),
                _buildInfoRow("Nama Pemilik Rekening", profile.namaPemilikRekening),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 Helper untuk menampilkan baris informasi
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(fontSize: 14, color: Colors.black87)),
        ],
      ),
    );
  }
}
