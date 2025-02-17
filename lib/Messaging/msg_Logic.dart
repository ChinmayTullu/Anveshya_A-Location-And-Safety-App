import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class FCMService {
  final Map<String, dynamic> _credentials;
  static const String _fcmEndpoint = 'https://fcm.googleapis.com/v1/projects/{project_id}/messages:send';

  FCMService(String jsonKeyPath) : _credentials = _loadCredentials(jsonKeyPath);

  static Map<String, dynamic> _loadCredentials(String path) {
    final file = File(path);
    final jsonString = file.readAsStringSync();
    return json.decode(jsonString);
  }

  Future<bool> sendMessage({
    required String deviceToken,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final endpoint = _fcmEndpoint.replaceAll(
        '{project_id}',
        _credentials['project_id'],
      );

      final message = {
        'message': {
          'token': deviceToken,
          'notification': {
            'title': title,
            'body': body,
          },
          if (data != null) 'data': data,
        },
      };

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_credentials['private_key']}',
        },
        body: json.encode(message),
      );

      if (response.statusCode == 200) {
        print('Message sent successfully');
        return true;
      } else {
        print('Failed to send message: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error sending message: $e');
      return false;
    }
  }

  Future<bool> sendMulticastMessage({
    required List<String> deviceTokens,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    bool hasSuccess = false;

    for (final token in deviceTokens) {
      final success = await sendMessage(
        deviceToken: token,
        title: title,
        body: body,
        data: data,
      );
      if (success) hasSuccess = true;
    }

    return hasSuccess;
  }
}