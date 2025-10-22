import 'package:flutter/material.dart';

class HistoryItem {
  // transaction detail
  String customerName;
  String application;
  String customerPan;
  String rrn;
  String merchantName;
  String acquirer;
  String merchantPan;
  String terminalId;
  String? note;
  
  // transaction status
  DateTime dateTime;
  double nominal;
  String transactionRefNumber;
  TransactionStatus status;

  HistoryItem({
    required this.customerName,
    required this.application,
    required this.customerPan,
    required this.rrn,
    required this.merchantName,
    required this.acquirer,
    required this.merchantPan,
    required this.terminalId,
    this.note,
    required this.dateTime,
    required this.nominal,
    required this.transactionRefNumber,
    required this.status
  });
}

class HistoryListItem {
  int id;
  String name;
  String bankName;
  String merchantId;
  TransactionType transactionType;
  DateTime dateTime;
  double nominal;
  
  HistoryListItem({
    required this.id,
    required this.name,
    required this.bankName,
    required this.transactionType,
    required this.dateTime,
    required this.nominal,
    required this.merchantId
  });
}

class HistoryResponse {
  int length;
  List<HistoryListItem> historyItems;

  HistoryResponse({
    required this.length,
    required this.historyItems
  });
}

enum TransactionType {
  pembayaranMasuk,
  refund
}

extension TransactionTypeExtension on TransactionType {
  String get string {
    switch (this) {
      case TransactionType.pembayaranMasuk: return 'Pembayaran Masuk';
      case TransactionType.refund: return 'Refund';
    }
  }
}

enum TransactionStatus {
  Berhasil,
  Gagal,
}

extension TransactionStatusExtension on TransactionStatus {
  String get string {
    switch (this) {
      case TransactionStatus.Berhasil:
        return 'Berhasil';
      case TransactionStatus.Gagal:
        return 'Gagal';
    }
  }

  TextStyle get style {
    switch (this) {
      case TransactionStatus.Berhasil:
        return const TextStyle(color: Colors.green, fontWeight: FontWeight.bold);
      case TransactionStatus.Gagal:
        return const TextStyle(color: Colors.red, fontWeight: FontWeight.bold);
    }
  }
}