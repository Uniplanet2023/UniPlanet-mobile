class NumberFormatter {
  final int amount;

  NumberFormatter(this.amount);

  String format() {
    if (amount <= 999) {
      return '$amount';
    } else if (amount > 999 && amount < 1000000) {
      return '${amount / 1000}k';
    } else {
      return '${amount ~/ 1000000}M';
    }
  }
}
