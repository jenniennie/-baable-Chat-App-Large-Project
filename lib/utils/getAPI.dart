import 'package:http/http.dart' as http;
import 'dart:convert';

class getAPI {
  static Future<String> getJson(String url, var outgoing) async {
    String ret = "";
    try {
      http.Response response = await http.post(Uri.parse(url),
          body: outgoing,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
          encoding: Encoding.getByName("utf-8"));
      ret = response.body;
    } catch (e) {
      print(e.toString());
    }
    return ret;
  }
}
