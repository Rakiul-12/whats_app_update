import 'package:intl/intl.dart';

class CallFormat {
  static String timeFromMillis(dynamic value) {
    if (value == null) return "";
    if (value is int) {
      final dt = DateTime.fromMillisecondsSinceEpoch(value);
      return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
    }
    return "";
  }

  static String duration(int sec) {
    final m = sec ~/ 60;
    final s = sec % 60;
    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }
}
