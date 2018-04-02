import 'dart:async';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart' as crypto;

import 'settings.dart' show weatherAccount, weatherKey;

const weatherUrl = 'https://free-api.heweather.com/s6/weather';
const nowWeatherUrl = 'https://free-api.heweather.com/s6/weather/now';
const AIQUrl = 'https://free-api.heweather.com/s6/air/now';

String calParamsStr(Map<String, String> params) {
  var paramKeys = params.keys.toList();
  paramKeys.sort();
  String paramsStr = paramKeys.map((each) {
    return '$each=' + params[each].trim();
  }).join('&');

  var content = new Utf8Encoder().convert(paramsStr + weatherKey);
  var sign = BASE64.encode(crypto.md5.convert(content).bytes);
  return '$paramsStr&sign=$sign';
}


/// @param cityCode - the city code (in city.json file)
Future getWeather(String cityCode) async {
  var paramsMap = {
    'username': weatherAccount,
    'location': cityCode,
    't': (new DateTime.now().millisecondsSinceEpoch / 1000).toStringAsFixed(0)
  };

  String paramsStr = calParamsStr(paramsMap);

  print(paramsStr);
  return http.get(
    weatherUrl + '?$paramsStr',
  );
}


/// @param cityCode - the city code (in city.json file)
Future getNowWeather(String cityCode) async {
  var paramsMap = {
    'username': weatherAccount,
    'location': cityCode,
    't': (new DateTime.now().millisecondsSinceEpoch / 1000).toStringAsFixed(0)
  };

  String paramsStr = calParamsStr(paramsMap);

  return http.get(
    nowWeatherUrl + '?$paramsStr',
  );
}

Future getAQI(String cityCode) async {
  var paramsMap = {
    'username': weatherAccount,
    'location': cityCode,
    't': (new DateTime.now().millisecondsSinceEpoch / 1000).toStringAsFixed(0)
  };

  String paramsStr = calParamsStr(paramsMap);

  return http.get(
    AIQUrl + '?$paramsStr',
  );
}

void main() async {
  http.Response r = await getAQI('CN101210805');
  print(r.body);
}

