import 'package:flutter/material.dart';
import 'qris_stiker_page.dart';
import 'qris_nominal_page.dart';

class QrisTransactionPage extends StatefulWidget {
  const QrisTransactionPage({super.key});

  @override
  State<QrisTransactionPage> createState() => _QrisTransactionPageState();
}

class _QrisTransactionPageState extends State<QrisTransactionPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Transaksi QRIS",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.teal,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.teal,
          tabs: const [
            Tab(text: "QRIS Stiker"),
            Tab(text: "QRIS Nominal"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          QrisStikerPage(),   // default tab
          QrisNominalPage(),  // dummy dulu
        ],
      ),
    );
  }
}
