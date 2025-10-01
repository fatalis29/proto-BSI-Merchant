// lib/viewmodels/transaction/transaction_repository.dart
import 'transaction.dart';

class TransactionRepository {
  // Singleton pattern (satu instance global)
  static final TransactionRepository _instance = TransactionRepository._internal();
  factory TransactionRepository() => _instance;
  TransactionRepository._internal();

  // List transaksi global
  final List<Transaction> _transactions = [];

  List<Transaction> get transactions => List.unmodifiable(_transactions);

  void addTransaction(Transaction tx) {
    _transactions.add(tx);
  }

  void seed(List<Transaction> initial) {
    _transactions
      ..clear()
      ..addAll(initial);
  }
  
  void clear() => _transactions.clear();
}
