import 'dart:convert';
import 'dart:typed_data';
import 'package:instagram_analytics/components/adaptive_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:intl/intl.dart';

String parseDateToString(DateTime _date) {
  try {
    return "${_date.year}-${_date.month}-${_date.day} ${_date.hour}:${_date.minute}";
  } catch (_) {
    return "";
  }
}


void toggleAdaptiveOverlayLoader(BuildContext context, {bool hide = false}) {
  if (!hide) {
    Loader.show(context,
        progressIndicator: const AdaptiveLoader(radius: 20),
        themeData: Theme.of(context).copyWith(colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black38)),
        overlayColor: Theme.of(context).primaryColorDark.withOpacity(.7));
  } else {
    Loader.hide();
  }
}

String tryEncodeBase64Image(Uint8List image) {
  try {
    return base64Encode(image);
  } catch (e) {
    return null;
  }
}

Uint8List tryDecodeBase64Image(String image) {
  if (image == '' || image == null) return null;
  try {
    return base64Decode(image).buffer.asByteData().buffer.asUint8List();
  } catch (e) {
    return null;
  }
}

DateTime parseStringToDateTime(String _date) {
  try {
    return DateFormat("yyyy-MM-dd H:i:s").parse(_date);
  } catch (_) {
    return DateTime.now();
  }
}

String formatCurrency(double number, BuildContext context) {
  String currencyFormat = "\$[price]";
  String currency = "USD";
  if (number == null || number < 0) return currencyFormat.replaceAll("[price]", "0.00");
  return currencyFormat.replaceAll("[price]", NumberFormat.currency(name: currency, decimalDigits: 2, symbol: "").format(number));
}

String formatResults(int number) {
  return NumberFormat.currency(name: '', decimalDigits: 0, symbol: '')
      .format(number);
}

TextEditingValue decimalNumberFormatter(
    TextEditingValue oldValue, TextEditingValue newValue) {
  try {
    newValue = TextEditingValue(
        text: newValue.text.replaceAll(",", "."),
        selection: newValue.selection);
    if (newValue.text.isNotEmpty) double.parse(newValue.text);
    return newValue;
  } catch (e) {}
  return oldValue;
}

double tryParseDouble(String value, {double defaultValue = 0}) {
  try {
    return double.parse(value);
  } catch (_) {
    return defaultValue;
  }
}

int tryParseInt(String value, {int defaultValue = 0}) {
  try {
    return int.parse(value);
  } catch (_) {
    return defaultValue;
  }
}

String tryParseString(dynamic value) {
  if (value == null) return "";
  try {
    if (value.runtimeType == String) return value;
  } catch (_) {}
  return "";
}

String convertToProperCase(String text) {
  if (text.length <= 1) return text.toUpperCase();
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}

dynamic tryGetDictValue(Map<String, dynamic> dictionary, String key, {dynamic empty = ""}){
  if(dictionary.containsKey(key)) {
    return dictionary[key];
  }
  return empty;
}

List tryGetDictList(Map<String, dynamic> dictionary, String key){
  if(dictionary.containsKey(key)){
    if(dictionary[key]==null) {
      return [];
    }
    try{
      return jsonDecode(dictionary[key]);
    }catch(_){}
  }
  return [];
}

String handleCurrency(String currency) {
  if (currency == 'USD') return "\$";
  return "$currency ";
}

String limitText(String text, {int limit = 20}){
  if(text.length>limit){
    return text.substring(0, limit);
  }return text;
}
