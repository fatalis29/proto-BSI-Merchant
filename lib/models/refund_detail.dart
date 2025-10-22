import '/models/history_item.dart';
import '/utilities/utilities.dart';

class RefundDetail {
  final String name;
  final String app;
  final DateTime date;
  final double transactionNominal;
  final double refundNominal;
  final TransactionStatus? refundStatus;

  RefundDetail({required this.name, required this.app, required this.date, required this.transactionNominal, required this.refundNominal, this.refundStatus});

  String getDate() {
    return formatDateToIndonesia(date, format: 'd MMMM y');
  }

  String getTime() {
    return "${formatDateToIndonesia(date.toUtc(), format: 'hh:mm')} WIB";
  }
}