import 'dart:convert';
import 'dart:io';
import 'package:chatbot/data/remote/urls.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
  Future<dynamic> sendMsgApi({required String msg}) async {
    try {
      // Build URL with API key appended properly
      var url = Uri.parse("${Urls.geminiBaseUrl}?key=${Urls.geminiApiKey}");

      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "role": "user",
              "parts": [
                {"text": msg},
              ],
            },
          ],
        }),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // Check if API returned an error inside JSON
        if (data['error'] != null) {
          throw HttpException(data['error']['message']);
        }

        return data;
      } else {
        // Throw exception on non-200 response
        throw HttpException(
          'Request failed with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw HttpException(e.toString());
    }
  }
}
