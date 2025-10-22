class TransactionSuccess {

}

class TransactionFailed extends Error {
  final int failedCode;

  TransactionFailed({required this.failedCode});

  String failedType() {
    if (failedCode == 402) { //
      return "Transaksi Ditolak";
    }
    return "Transaksi Gagal";
  }

  String failedMessage() {
    if (failedCode == 402) {
      return "Transaksi Ditolak oleh Nasabah";
    }
    return "Transaksi Gagal";
  }
}
