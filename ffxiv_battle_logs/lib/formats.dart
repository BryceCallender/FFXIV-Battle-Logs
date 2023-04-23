import 'package:intl/intl.dart';

class Format {
  static final totalFormat =
      NumberFormat.compactCurrency(decimalDigits: 2, symbol: '');
  static final tpsFormat = NumberFormat("###,###.0", "en_US");
}
