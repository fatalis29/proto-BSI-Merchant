// lib/viewmodels/transaction/transaction.dart
class Transaction {
  final String customerName;
  final String bank;
  final String time;
  final String type; // "Pembayaran Masuk" atau "Refund"
  final int amount;
  final DateTime date;

  // Optional detail fields (dummy for now)
  final String refNo;
  final String rrn;
  final String customerPan;
  final String merchantPan;

  Transaction({
    required this.customerName,
    required this.bank,
    required this.time,
    required this.type,
    required this.amount,
    required this.date,
    this.refNo = 'SWO009O5ZY4G',
    this.rrn = '000407511928',
    this.customerPan = '9360045010002122400',
    this.merchantPan = '9360045010002122400',
  });
}
