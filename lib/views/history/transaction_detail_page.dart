// lib/views/history/transaction_detail_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/transaction/transaction.dart';
import '../refund/refund_transaction_page.dart';

class TransactionDetailPage extends StatelessWidget {
  final Transaction transaction;
  final int? refundAmount; // null = belum ada refund

  const TransactionDetailPage({
    super.key,
    required this.transaction,
    this.refundAmount,
  });

  String _formatRupiah(int amount) =>
      "Rp ${NumberFormat('#,###', 'id_ID').format(amount)}";

  @override
  Widget build(BuildContext context) {
    final tx = transaction;
    final isMasuk = tx.type == "Pembayaran Masuk";

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Transaksi")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // 🔹 Bagian Transaksi Awal
          const Text("Transaksi Awal",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.arrow_downward, color: Colors.green),
              title: Text(tx.customerName),
              subtitle: Text("${tx.bank} • ${tx.time} WIB"),
              trailing: Text(
                "+ ${_formatRupiah(tx.amount)}",
                style: const TextStyle(
                    color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 🔹 Detail transaksi awal
          const Text("DETAIL TRANSAKSI",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("Nominal Transaksi: ${_formatRupiah(tx.amount)}"),
          Text("Tips: ${_formatRupiah(0)}"),
          Text("Total Transaksi: ${_formatRupiah(tx.amount)}"),
          Text("No. Ref Transaksi: ${tx.refNo}"),
          Text("RRN: ${tx.rrn}"),
          Text("Customer PAN: ${tx.customerPan}"),
          Text("Merchant PAN: ${tx.merchantPan}"),
          const SizedBox(height: 24),

          // 🔹 Jika sudah ada refund, tampilkan section refund
          if (refundAmount != null) ...[
            const Text("Transaksi Refund",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.arrow_upward, color: Colors.red),
                title: Text(tx.customerName),
                subtitle: Text("${tx.bank} • ${DateFormat('d MMM yyyy').format(DateTime.now())}"),
                trailing: Text(
                  "- ${_formatRupiah(refundAmount!)}",
                  style: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],

          const SizedBox(height: 24),

          // 🔹 Tombol Refund hanya muncul jika transaksi (+) dan belum ada refund
          if (isMasuk && refundAmount == null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RefundTransactionPage(transaction: tx),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Refund Transaksi",
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
