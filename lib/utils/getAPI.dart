import 'package:http/http.dart' as http;
import 'dart:convert';

class getAPI {
  static Future<String> getJson(String url, String outgoing) async {
    String ret = "before";
    print('input $outgoing');
    try {
      http.Response response = await http.post(Uri.parse(url),
          body: utf8.encode(outgoing),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
          encoding: Encoding.getByName("utf-8"));
      ret = response.body;
    } catch (e) {
      print(e.toString());
    }
    print('THE RET is: $ret');
    return ret;
  }
}
