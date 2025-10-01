import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum NotificationType { general, syariah }

class NotificationSoundPage extends StatefulWidget {
  const NotificationSoundPage({super.key});

  @override
  State<NotificationSoundPage> createState() => _NotificationSoundPageState();
}

class _NotificationSoundPageState extends State<NotificationSoundPage> {
  NotificationType _selectedType = NotificationType.general;

  @override
  void initState() {
    super.initState();
    _loadPreference();
  }

  Future<void> _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('notification_type');
    setState(() {
      if (saved == 'syariah') {
        _selectedType = NotificationType.syariah;
      } else {
        _selectedType = NotificationType.general;
      }
    });
  }

  Future<void> _savePreference(NotificationType type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'notification_type', type == NotificationType.general ? 'general' : 'syariah');
  }

  void _onSelect(NotificationType type) {
    setState(() {
      _selectedType = type;
    });
    _savePreference(type);

    // TODO: play sound sesuai pilihan
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Suara Notifikasi",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildOption(
              type: NotificationType.general,
              label: "General",
              icon: Icons.play_circle_fill,
            ),
            _buildOption(
              type: NotificationType.syariah,
              label: "Syariah",
              icon: Icons.nightlight_round, // bisa diganti star_and_crescent jika ada
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required NotificationType type,
    required String label,
    required IconData icon,
  }) {
    final bool isSelected = _selectedType == type;

    return GestureDetector(
      onTap: () => _onSelect(type),
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.teal : Colors.grey.shade300,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: isSelected ? Colors.teal : Colors.grey),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.teal : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
