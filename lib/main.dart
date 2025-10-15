import 'package:flutter/material.dart';
import 'views/login/splash_screen.dart'; // sesuaikan path
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:bsi_merchant_bussiness_proto/viewmodels/transaction/transaction_repository.dart';
import 'package:bsi_merchant_bussiness_proto/viewmodels/transaction/transaction.dart';
import 'package:media_store_plus/media_store_plus.dart'; // ✅ tambahkan import

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Inisialisasi MediaStore sekali di awal
  await MediaStore.ensureInitialized();

  // ✅ Set folder default untuk aplikasi
  // Akan membuat subfolder di Download/BSI_Merchant
  MediaStore.appFolder = "BSI_Merchant";

  // Dummy repo untuk histori transaksi
  final repo = TransactionRepository();

  // Seed data awal
  repo.seed([
    Transaction(
      customerName: "Monica Adina",
      bank: "Bank Central Asia",
      time: "18:58",
      type: "Pembayaran Masuk",
      amount: 299000,
      date: DateTime.now(),
    ),
    Transaction(
      customerName: "Salim Alvidros",
      bank: "Gopay",
      time: "19:00",
      type: "Pembayaran Masuk",
      amount: 150000,
      date: DateTime.now(),
    ),
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BSI Merchant',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const SplashScreen(),
      // tambahkan localizations agar datepicker bisa bahasa Indonesia
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('id', 'ID'),
        Locale('en', 'US'),
      ],
    );
  }
}
