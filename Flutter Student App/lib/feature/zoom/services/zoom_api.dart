import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:opencentric_lms/feature/zoom/config.dart';

generateZoomAccessToken() async {
  var url = Uri.https('zoom.us', '/oauth/token');
  var response = await http.post(url, headers: {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Authorization': 'Basic $kBase64Key',
  }, body: {
    'grant_type': 'account_credentials',
    'account_id': kAccountId
  });
  if (kDebugMode) {
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  return jsonDecode(response.body);
}

createMeeting(zoomAccessToken) async {
  var url = Uri.https('api.zoom.us', '/v2/users/me/meetings');
  var response = await http.post(url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $zoomAccessToken',
      },
      body: jsonEncode({
        "topic": "My New Meeting",
        "type": 2,
        "start_time": "2024-01-15T12:03:00Z",
        "duration": 60,
        "password": "123456",
        "timezone": "UTC",
        "settings": {
          //"auto_recording": "cloud"
        }
      }));
  if (kDebugMode) {
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  return jsonDecode(response.body);
}

getZak(zoomAccessToken, userId) async {
  var url =
      Uri.https('api.zoom.us', '/v2/users/$userId/token', {'type': 'zak'});
  var response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $zoomAccessToken',
    },
  );
  if (kDebugMode) {
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  return jsonDecode(response.body);
}
