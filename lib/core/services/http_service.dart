import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpService {
  static const int _maxRetries = 3;
  static const int _baseDelayMs = 1000;

  static Future<List<Map<String, dynamic>>> fetchPostsWithRetry() async {
    return await _fetchWithRetry(
      'https://jsonplaceholder.typicode.com/posts',
    );
  }

  static Future<List<Map<String, dynamic>>> fetchWithInvalidUrl() async {
    return await _fetchWithRetry(
      'https://jsonplaceholder.typicode.com/invalid_endpoint',
    );
  }

  static Future<List<Map<String, dynamic>>> _fetchWithRetry(
    String url, {
    int retryCount = 0,
  }) async {
    try {
      debugPrint(
          '=== Task II - HTTP Request ===');
      debugPrint(
          'Attempt ${retryCount + 1} of $_maxRetries: GET $url');

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        debugPrint('Success! Status: ${response.statusCode}');
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception(
            'Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error on attempt ${retryCount + 1}: $e');

      if (retryCount < _maxRetries - 1) {
        final delay = _calculateBackoffDelay(retryCount);
        debugPrint(
            'Retrying in ${delay}ms (exponential backoff + jitter)...');
        await Future.delayed(Duration(milliseconds: delay));
        return _fetchWithRetry(url, retryCount: retryCount + 1);
      } else {
        debugPrint(
            'Max retries reached. Request failed.');
        throw Exception('Failed after $_maxRetries attempts: $e');
      }
    }
  }

  static int _calculateBackoffDelay(int retryCount) {
    final exponentialDelay =
        _baseDelayMs * pow(2, retryCount).toInt();
    final jitter = Random().nextInt(500);
    final totalDelay = exponentialDelay + jitter;
    debugPrint(
        'Backoff delay: ${exponentialDelay}ms + ${jitter}ms jitter = ${totalDelay}ms');
    return totalDelay;
  }
}