import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestHelper {
  static Future<dynamic> receiveRequest(String url) async {
    http.Response httpResponse = await http.get(Uri.parse(url));

    try {
      if (httpResponse.statusCode == 200) { // Successful
        String responseData = httpResponse.body;
        var decodeResponseData = jsonDecode(responseData);
        return decodeResponseData;
      } else {
        return "Error Occurred, Failed. No Response.";
      }
    } catch (exp) {
      return "Error Occurred, Failed. No Response.";
    }


  }
}