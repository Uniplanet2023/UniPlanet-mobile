class TimeAgoFormatter {
  final DateTime time;

  TimeAgoFormatter(this.time);

  String format() {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      final weeks = difference.inDays ~/ 7;
      return '${weeks}w ago';
    } else if (difference.inDays < 365) {
      final months = difference.inDays ~/ 30;
      if (months == 1) {
        return '$months month ago';
      }
      return '$months months ago';
    } else {
      final years = difference.inDays ~/ 365;
      return '($years)y ago';
    }
  }
}
