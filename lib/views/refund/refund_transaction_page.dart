// lib/views/refund/refund_transaction_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/transaction/transaction.dart';
import 'confirm_refund_page.dart';

class RefundTransactionPage extends StatefulWidget {
  final Transaction transaction;

  const RefundTransactionPage({super.key, required this.transaction});

  @override
  State<RefundTransactionPage> createState() => _RefundTransactionPageState();
}

class _RefundTransactionPageState extends State<RefundTransactionPage> {
  final TextEditingController _controller = TextEditingController();
  int? _refundAmount;

  String _formatRupiah(int amount) =>
      "Rp ${NumberFormat('#,###', 'id_ID').format(amount)}"; 

  bool get _isValidRefund {
    if (_refundAmount == null) return false;
    return _refundAmount! > 0 && _refundAmount! <= widget.transaction.amount;
  }

  @override
  Widget build(BuildContext context) {
    final tx = widget.transaction;

    // Jika transaksi bukan (+), tampilkan pesan
    if (tx.type != "Pembayaran Masuk") {
      return Scaffold(
        appBar: AppBar(title: const Text("Refund Transaksi")),
        body: const Center(
          child: Text("Transaksi ini tidak dapat direfund."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Refund Transaksi")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Input nominal refund
            const Text(
              "Nominal Refund",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                prefixText: "Rp ",
                border: OutlineInputBorder(),
                hintText: "Masukkan nominal refund",
              ),
              onChanged: (val) {
                setState(() {
                  _refundAmount = int.tryParse(val);
                });
              },
            ),
            const SizedBox(height: 20),

            // 🔹 Info transaksi
            Text(
              "Total Transaksi: + ${_formatRupiah(tx.amount)}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Nama Nasabah: ${tx.customerName}"),
            Text("Aplikasi Issuer: ${tx.bank}"),
            Text("Tanggal: ${DateFormat('d MMMM yyyy', 'id_ID').format(tx.date)}"),
            Text("Jam: ${tx.time} WIB"),
            const SizedBox(height: 20),

            // 🔹 Detail transaksi
            const Text(
              "DETAIL TRANSAKSI",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("No. Ref Transaksi: ${tx.refNo}"),
            Text("RRN: ${tx.rrn}"),
            const Spacer(),

            // 🔹 Tombol Refund
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isValidRefund
                    ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ConfirmRefundPage(
                              transaction: tx,
                              refundAmount: _refundAmount!,
                            ),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  disabledBackgroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Refund",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
