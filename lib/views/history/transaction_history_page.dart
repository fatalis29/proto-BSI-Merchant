import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../viewmodels/transaction/transaction.dart';
import '../../viewmodels/transaction/transaction_repository.dart';
import 'transaction_detail_page.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  late String _tanggalPanel = "Memuat...";
  final int _saldoHariIni = 10745000;
  String _searchQuery = "";
  DateTime? _selectedDateFilter;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null).then((_) {
      if (mounted) {
        setState(() {
          _tanggalPanel =
              DateFormat("EEEE, d MMMM yyyy", "id_ID").format(DateTime.now());
        });
      }
    });
  }

  // PENYESUAIAN 1: Hapus "Rp " dari fungsi ini
  String _formatAngka(int amount) =>
      NumberFormat('#,###', 'id_ID').format(amount);

  List<Transaction> get _filteredTransactions {
    final allTransactions = TransactionRepository().transactions;
    return allTransactions.where((tx) {
      final matchesSearch = tx.customerName
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final matchesDate = _selectedDateFilter == null
          ? true
          : (tx.date.year == _selectedDateFilter!.year &&
              tx.date.month == _selectedDateFilter!.month &&
              tx.date.day == _selectedDateFilter!.day);
      return matchesSearch && matchesDate;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final transactions = _filteredTransactions;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      // Hapus AppBar dari sini
      // appBar: AppBar(...),
      body: SafeArea( // Bungkus dengan SafeArea
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Ratakan semua ke kiri
          children: [
            // ==========================================================
            // PENYESUAIAN 2: BUAT HEADER MANUAL
            // ==========================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Riwayat Transaksi",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24, // Perbesar sedikit sesuai desain
                ),
              ),
            ),
            const SizedBox(height: 16), // Jarak antara judul dan panel


            // ==========================================================
            // PENYESUAIAN 3: PERBAIKI PANEL DENGAN RICHTEXT
            // ==========================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF01BDB1), Color(0xFF007C80)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _tanggalPanel,
                            style: const TextStyle(fontSize: 14, color: Colors.white70),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          // Menggunakan RichText di sini
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontFamily: DefaultTextStyle.of(context).style.fontFamily,
                              ),
                              children: [
                                const TextSpan(
                                  text: "Rp ",
                                  style: TextStyle(fontWeight: FontWeight.normal), // Dibuat normal
                                ),
                                TextSpan(
                                  text: _formatAngka(_saldoHariIni),
                                  style: const TextStyle(fontWeight: FontWeight.bold), // Dibuat bold
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Image.asset(
                      'assets/Icons/Vector 894 (Stroke)(side).png',
                      height: 45,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ),

            // Bagian Search + Kalender (tidak ada perubahan)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Cari nama customer",
                        prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (val) => setState(() => _searchQuery = val),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.calendar_today, color: Color(0xFF007C80)),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDateFilter ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                          locale: const Locale("id", "ID"),
                        );
                        if (picked != null) setState(() => _selectedDateFilter = picked);
                      },
                    ),
                  ),
                  if (_selectedDateFilter != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: InkWell(
                        onTap: () => setState(() => _selectedDateFilter = null),
                        child: const Icon(Icons.clear, color: Colors.redAccent)
                      ),
                    )
                ],
              ),
            ),

            // List Transaksi (tidak ada perubahan)
            Expanded(
              child: transactions.isEmpty
                  ? const Center(child: Text("Tidak ada transaksi ditemukan"))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final tx = transactions[index];
                        final isMasuk = tx.type == "Pembayaran Masuk";

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          decoration: BoxDecoration(
                             color: Colors.white,
                             borderRadius: BorderRadius.circular(12)
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => TransactionDetailPage(
                                        transaction: tx,
                                        refundAmount: !isMasuk ? tx.amount : null,
                                      )));
                            },
                            title: Text(
                              tx.customerName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                            ),
                            subtitle: Text("${tx.bank} • ${tx.time}", style: TextStyle(color: Colors.grey[600])),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${isMasuk ? '+' : '-'} Rp ${_formatAngka(tx.amount)}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isMasuk
                                        ? const Color(0xFF2E7D32)
                                        : Colors.black87,
                                  ),
                                ),
                                Text(
                                  tx.type,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: isMasuk
                                        ? const Color(0xFF2E7D32)
                                        : Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

