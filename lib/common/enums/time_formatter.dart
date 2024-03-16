class TimeAgoFormatter {
  final DateTime time;

  TimeAgoFormatter(this.time);

  String format() {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} sec ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hrs ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = difference.inDays ~/ 7;
      return '$weeks weeks ago';
    } else if (difference.inDays < 365) {
      final months = difference.inDays ~/ 30;
      return '$months months ago';
    } else {
      final years = difference.inDays ~/ 365;
      return '$years years ago';
    }
  }
}
