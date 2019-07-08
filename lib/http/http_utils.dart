import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanandroid_flutter/http/api.dart';

class HttpUtils {
  static const String _GET = 'get';
  static const String _POST = 'post';
  static const String COOKIE = 'cookie';

  static void get(String url, Function callback,
      {Map<String, String> params,
      Map<String, String> headers,
      Function errorCallback}) async {
    print('===============get()');

    if (!url.startsWith('http')) {
      url = API.baseUrl + url;
    }

    print('url = $url');

    if (params != null && params.isNotEmpty) {
      StringBuffer sb = StringBuffer('?');
      params.forEach((key, value) {
        sb.write('$key = $value');
        sb.write('&');
      });
      String paramStr = sb.toString();
      paramStr = paramStr.substring(0, paramStr.length - 1);
      url += paramStr;
    }

    await _request(url, callback,
        method: _GET,
        header: headers,
        params: params,
        errorCallback: errorCallback);
  }

  static Future post(String url, Function callback,
      {Map<String, String> params,
      Map<String, String> headers,
      Function errorCallback}) async {
    if (!url.startsWith('http')) {
      url = API.baseUrl + url;
    }

    await _request(url, callback,
        method: _POST,
        header: headers,
        params: params,
        errorCallback: errorCallback);
  }

  static Future _request(String url, Function callback,
      {String method,
      Map<String, String> header,
      Map<String, String> params,
      Function errorCallback}) async {
    String errorMsg;
    int errorCode;
    var data;

    try {
      Map<String, String> headerMap = header == null ? Map() : header;
      Map<String, String> paramMap = params == null ? Map() : params;

      SharedPreferences sp = await SharedPreferences.getInstance();
      String cookie = sp.get(COOKIE);
      print('cookie: $cookie');
      if (cookie != null && cookie != '') {
        headerMap['Cookie'] = cookie;
      }

      http.Response rsp;

      if (_POST == method) {
        print('POST: url=$url');
        print('POST: params: ${paramMap.toString()}');
        rsp = await http.post(url, headers: headerMap, body: paramMap);
      } else {
        rsp = await http.get(url, headers: headerMap);
      }

      print('response: ${rsp.body}');

      if (rsp.statusCode != 200) {
        errorMsg = '网络请求错误，状态码: ${rsp.statusCode}';
        return;
      }

      Map<String, dynamic> response = json.decode(rsp.body);
      errorCode = response['errorCode'];
      errorMsg = response['errorMsg'];
      data = response['data'];

      if (callback != null) {
        if (errorCode >= 0) {
          callback(data, rsp.headers['set-cookie']);
        } else {
          _handError(errorCallback, errorMsg);
        }
      }
    } catch (e) {
      _handError(errorCallback, e.toString());
    }
  }

  static void _handError(Function errorCallback, String errorMsg) {
    if (errorCallback != null) {
      errorCallback(errorMsg);
    }
    print('errorMsg: $errorMsg');
  }
}
