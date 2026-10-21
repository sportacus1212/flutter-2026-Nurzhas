// R8: Custom date and duration formatter without external dependencies
class DateFormatter {
  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static String formatDateTime(DateTime dt) {
    final day = dt.day;
    final month = _months[dt.month - 1];
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$day $month, $hour:$minute';
  }

  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${duration.inMinutes}m';
  }
}
