import 'package:intl/intl.dart';

class CallFormat {
  /// For UI: WhatsApp style
  static String whatsappTime(dynamic value) {
    final ms = toMillis(value);
    if (ms == 0) return "";

    final dt = DateTime.fromMillisecondsSinceEpoch(ms);
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dt.year, dt.month, dt.day);
    final diffDays = today.difference(date).inDays;

    final timePart = DateFormat("hh:mm a").format(dt);

    if (diffDays == 0) return "Today, $timePart";
    if (diffDays == 1) return "Yesterday, $timePart";
    return "${DateFormat("dd MMM yyyy").format(dt)}, $timePart";
  }

  /// For Firestore text field saving (your format)
  static String timeFromMillis(dynamic value) {
    final ms = toMillis(value);
    if (ms == 0) return "";
    final dt = DateTime.fromMillisecondsSinceEpoch(ms);
    return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
  }

  static String duration(int sec) {
    final m = sec ~/ 60;
    final s = sec % 60;
    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  static int toMillis(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }
}
