import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _formatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static String format(double amount) {
    return _formatter.format(amount);
  }

  static String numberToWords(double amount) {
    if (amount <= 0) return 'Zero Rupees Only';

    final int wholePart = amount.toInt();
    final int paisaPart = ((amount - wholePart) * 100).round();

    String result = '${_convertNumberToWords(wholePart)} Rupees';
    if (paisaPart > 0) {
      result += ' and ${_convertNumberToWords(paisaPart)} Paisa';
    }
    return '$result Only';
  }

  static String _convertNumberToWords(int number) {
    if (number == 0) return 'Zero';

    final List<String> units = [
      '',
      'One',
      'Two',
      'Three',
      'Four',
      'Five',
      'Six',
      'Seven',
      'Eight',
      'Nine',
      'Ten',
      'Eleven',
      'Twelve',
      'Thirteen',
      'Fourteen',
      'Fifteen',
      'Sixteen',
      'Seventeen',
      'Eighteen',
      'Nineteen'
    ];

    final List<String> tens = [
      '',
      '',
      'Twenty',
      'Thirty',
      'Forty',
      'Fifty',
      'Sixty',
      'Seventy',
      'Eighty',
      'Ninety'
    ];

    if (number < 20) return units[number];
    if (number < 100) {
      return '${tens[number ~/ 10]} ${units[number % 10]}'.trim();
    }
    if (number < 1000) {
      return '${units[number ~/ 100]} Hundred ${_convertNumberToWords(number % 100)}'
          .trim();
    }
    if (number < 100000) {
      return '${_convertNumberToWords(number ~/ 1000)} Thousand ${_convertNumberToWords(number % 1000)}'
          .trim();
    }
    if (number < 10000000) {
      return '${_convertNumberToWords(number ~/ 100000)} Lakh ${_convertNumberToWords(number % 100000)}'
          .trim();
    }
    return '${_convertNumberToWords(number ~/ 10000000)} Crore ${_convertNumberToWords(number % 10000000)}'
        .trim();
  }
}
