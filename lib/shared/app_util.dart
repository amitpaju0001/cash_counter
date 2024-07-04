

import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AppUtil {
  static void showToast(String message) {
    Fluttertoast.showToast(msg: message);
  }
  static String formattedDate(DateTime date) {
    return DateFormat('d MMMM, yyyy').format(date);
  }
}