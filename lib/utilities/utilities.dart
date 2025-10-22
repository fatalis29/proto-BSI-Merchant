import 'dart:developer';
import 'package:intl/intl.dart';
const BASE_URL_LENGTH = 17;

String formatToRupiah(double amount) {
  var formatter = NumberFormat.simpleCurrency(locale: 'id', name: 'IDR', decimalDigits: 0);
  return formatter.format(amount);
}

String formatDateToIndonesia(DateTime dateTime, {String format = 'EEEE, d MMMM y'}) {
  return DateFormat(format, 'id-ID').format(dateTime);
}

String getSubUrlFromPath(String path) {
  String subPath = path.substring(BASE_URL_LENGTH+1);
  int endOfSubUrl = subPath.indexOf(RegExp(r'[?=:]'));
  return endOfSubUrl != -1 ? subPath.substring(0, endOfSubUrl) : subPath;
}

String getTimestampIso8601() {
  return DateTime.now().toUtc().toIso8601String();
}

String getBdiSignature(String timestamp, String url, {String body = "{\"data\":\"n,,n=00000000724116,r=e45RyNKtIcbk3RbI\",\"AuthType\":\"login\"}"}) {
  // api_url = "https://yuriva.com/dmoney" (static param)
  // var url = "/dmoney"; // (path dari api_url)
  // bdi_timestamp = "2024-02-13T07:55:39.053Z" (current date (ISO Format))
  var api_key = "284cd721-3b6a-4d4b-984e-3995ae5d1ae7"; // (static param)
  var add_key = "74145"; // (static param)
  body = "{\"data\":\"n,,n=00000000724116,r=e45RyNKtIcbk3RbI\",\"AuthType\":\"login\"}";
  var bdi_signature = url + timestamp + api_key + add_key +  body; //(request param di trim whitespace/ space / tab)

  // var bdi_signature = await Sha256().hash(bdi_signature);

  log('BDI-SIGNATURE: $bdi_signature');
  return bdi_signature;
}