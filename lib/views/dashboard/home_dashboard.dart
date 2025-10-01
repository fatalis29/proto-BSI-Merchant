import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../settings/settings_page.dart';
import '../history/transaction_history_page.dart';
import '../transaction/qris_transaction_page.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  String _tanggal = "";

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null).then((_) {
      if (mounted) {
        setState(() {
          _tanggal = DateFormat("d MMMM", "id_ID").format(DateTime.now());
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan Stack untuk menumpuk background dan konten utama
      body: Stack(
        children: [
          // ==========================================================
          // LAYER 1: BACKGROUND GRADASI
          // ==========================================================
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFB8E6E1),
                  Color(0xFFD4F1E8),
                  Color(0xFFF5F0E8),
                  Color.fromARGB(255, 213, 230, 230),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.3, 0.5, 1.0],
              ),
            ),
          ),

          // ==========================================================
          // LAYER 2: KONTEN UTAMA
          // ==========================================================
          SafeArea(
            child: Column(
              children: [
                // 🔹 AppBar custom (tetap di atas, tidak ikut scroll)
                _buildCustomAppBar(),

                // 🔹 Konten yang bisa di-scroll
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        // Panel Pendapatan
                        _buildIncomePanelOriginal(),

                        const SizedBox(height: 20), // Jarak antara panel

                        // Panel Menu
                        _buildMenuPanel(),
                        
                        const SizedBox(height: 20), // Padding bawah agar tidak mepet
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // HELPER WIDGETS
  // ==========================================================

  /// Membangun AppBar Kustom di bagian atas.
  Widget _buildCustomAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/Icons/logo login.png', height: 50),
          GestureDetector(
            onTap: () => Navigator.of(context).push(_settingsRoute()),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: const [
                  Icon(Icons.settings, color: Color(0xFF007C80), size: 20),
                  SizedBox(width: 6),
                  Text(
                    "Pengaturan",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Membangun Panel Pendapatan (Kode Asli Anda yang Benar).
  Widget _buildIncomePanelOriginal() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26.0),
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF01BDB1), Color(0xFF007C80)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Image.asset(
                'assets/Icons/Vector 894 (Kuning).png',
                fit: BoxFit.contain,
                height: 120,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Toko Tiga Lebih",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _tanggal.isEmpty
                          ? "Memuat tanggal..."
                          : "Pendapatan Kamu Hari ini, $_tanggal",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Rp",
                            style: TextStyle(
                                fontSize: 14, color: Colors.white70)),
                        SizedBox(width: 4),
                        Text("10.745.000",
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Membangun Panel Menu Putih di bagian bawah.
  Widget _buildMenuPanel() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.05,
            children: [
              _buildGridMenuItem(
                iconPath: 'assets/Icons/Menu Riwayat Transaksi.png',
                label: 'Riwayat Transaksi',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const TransactionHistoryPage(),
                    ),
                  );
                },
              ),
              _buildGridMenuItem(
                iconPath: 'assets/Icons/Menu Unduh Laporan.png',
                label: 'Unduh Laporan',
                onTap: () => print('Unduh Laporan diklik!'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildQrMenuItem(
            iconPath: 'assets/Icons/Menu Qris.png',
            label: 'Transaksi QRIS',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const QrisTransactionPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Helper untuk item di dalam GridView
  Widget _buildGridMenuItem({
    required String iconPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath, height: 48),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper untuk item QRIS
  Widget _buildQrMenuItem({
    required String iconPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(iconPath, height: 40),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom route untuk SettingsPage
  Route _settingsRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const SettingsPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}

