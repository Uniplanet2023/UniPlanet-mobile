class PriceFormatter {
  final double amount;

  PriceFormatter(this.amount);

  String getDigit() {
    String res = amount.toString().split('.')[0];
    return res;
  }

  String getDecimal() {
    if (amount.toString().split('.').length == 1) {
      return '00';
    }
    String res = amount.toString().split('.')[1];
    if (res.length < 2) {
      return res += '0';
    }
    return res;
  }
}
