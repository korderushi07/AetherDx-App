import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http_parser/http_parser.dart';

class ApiService {
  static String get baseUrl {
    final rawUrl = dotenv.get('base_url', fallback: '').trim();
    return rawUrl;
  }

  static String _parseError(String responseBody, String defaultMsg) {
    try {
      final data = json.decode(responseBody);
      final detail = data['detail'];
      if (detail == null) return defaultMsg;
      if (detail is String) return detail;
      if (detail is List) {
        // FastAPI validation errors (e.g. password too short, invalid email)
        return detail
            .map((err) {
              if (err is Map) {
                final msg = err['msg'] as String?;
                if (msg != null) {
                  // Clean up standard validation prefixes like "Value error, "
                  return msg.replaceAll('Value error, ', '');
                }
              }
              return '';
            })
            .where((msg) => msg.isNotEmpty)
            .join('\n');
      }
      return detail.toString();
    } catch (_) {
      return defaultMsg;
    }
  }

  /// Registers a new user. FastAPI expects a JSON body: {"email": "...", "password": "..."}.
  static Future<bool> register(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/register');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: json.encode({
          'email': email.trim().toLowerCase(),
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception(_parseError(response.body, 'Registration failed'));
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Logs in an existing user. FastAPI OAuth2PasswordRequestForm expects a
  /// application/x-www-form-urlencoded body with fields 'username' and 'password'.
  static Future<String?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'ngrok-skip-browser-warning': 'true',
        },
        body: {
          'username': email.trim().toLowerCase(),
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['access_token'];
        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          await prefs.setString('user_email', email.trim());
          return token;
        }
      } else {
        throw Exception(_parseError(response.body, 'Incorrect email or password'));
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
    return null;
  }

  /// Retrieves the saved authentication token from local storage.
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  /// Uploads a nail image for AI classification.
  /// Returns a map with prediction_id, predicted_class, confidence, and status.
  static Future<Map<String, dynamic>> predictNail(
    String imagePath, {
    Uint8List? imageBytes,
  }) async {
    final url = Uri.parse('$baseUrl/nail/predict');
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('User is not authenticated. Please log in.');
      }

      final extension = imagePath.split('.').last.toLowerCase();
      String mimeType = 'image/jpeg';
      if (extension == 'png') {
        mimeType = 'image/png';
      } else if (extension == 'webp') {
        mimeType = 'image/webp';
      } else if (extension == 'gif') {
        mimeType = 'image/gif';
      }

      final request = http.MultipartRequest('POST', url)
        ..headers.addAll({
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        });

      if (imageBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            imageBytes,
            filename: imagePath.split('/').last.split('\\').last,
            contentType: MediaType.parse(mimeType),
          ),
        );
      } else {
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            imagePath,
            contentType: MediaType.parse(mimeType),
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(_parseError(response.body, 'Inference failed'));
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Fetches prediction history for the current authenticated user.
  static Future<List<Map<String, dynamic>>> getPredictionHistory() async {
    final url = Uri.parse('$baseUrl/nail/history');
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('User is not authenticated. Please log in.');
      }

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception(_parseError(response.body, 'Failed to fetch history'));
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Fetches lifestyle recommendations from the backend for a specific condition.
  static Future<Map<String, dynamic>> getLifestyleRecommendations(String condition) async {
    // Map condition to fit backend's direct query match logic (e.g. 'Nail Psoriasis' -> 'Psoriasis')
    String targetClass = 'Healthy';
    if (condition.toLowerCase().contains('psoriasis')) {
      targetClass = 'Psoriasis';
    } else if (condition.toLowerCase().contains('terry') || condition.toLowerCase().contains('liver')) {
      targetClass = 'Liver Disease';
    }

    final url = Uri.parse('$baseUrl/nail/recommendations/lifestyle?disease_class=$targetClass');
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('User is not authenticated. Please log in.');
      }

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(_parseError(response.body, 'Failed to fetch recommendations'));
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Fetches user profile and health information from the backend.
  static Future<Map<String, dynamic>?> getUserProfile() async {
    final url = Uri.parse('$baseUrl/auth/profile');
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('User is not authenticated. Please log in.');
      }

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(_parseError(response.body, 'Failed to fetch profile'));
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Saves user profile and health information to the backend.
  static Future<bool> saveUserProfile(Map<String, dynamic> profileData) async {
    final url = Uri.parse('$baseUrl/auth/profile');
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('User is not authenticated. Please log in.');
      }

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        },
        body: json.encode(profileData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception(_parseError(response.body, 'Failed to save profile'));
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Generates a password reset OTP for a registered email.
  /// Returns the generated OTP (for demo/development use).
  static Future<String> forgotPassword(String email) async {
    final url = Uri.parse('$baseUrl/auth/forgot-password');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: json.encode({
          'email': email.trim().toLowerCase(),
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['otp'] as String;
      } else {
        throw Exception(_parseError(response.body, 'Failed to request reset OTP'));
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Resets password using the received OTP code.
  static Future<bool> resetPassword(String email, String otp, String newPassword) async {
    final url = Uri.parse('$baseUrl/auth/reset-password');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: json.encode({
          'email': email.trim().toLowerCase(),
          'otp': otp.trim(),
          'new_password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(_parseError(response.body, 'Failed to reset password'));
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Fetches nearby specialists based on condition and city.
  /// Call: GET /api/v1/consultation/nearby?condition=...&city=...
  static Future<Map<String, dynamic>> getNearbySpecialists({
    required String condition,
    required String city,
  }) async {
    final queryParams = {
      'condition': condition,
      'city': city,
    };
    final uri = Uri.parse('$baseUrl/api/v1/consultation/nearby').replace(queryParameters: queryParams);
    try {
      final token = await getToken();
      final headers = {
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      };
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(_parseError(response.body, 'Failed to fetch specialists'));
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Fetches details for a specific specialist.
  /// Call: GET /api/v1/consultation/details/{doctorId}
  static Future<Map<String, dynamic>> getSpecialistDetails(String doctorId) async {
    final url = Uri.parse('$baseUrl/api/v1/consultation/details/$doctorId');
    try {
      final token = await getToken();
      final headers = {
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      };
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(_parseError(response.body, 'Failed to fetch specialist details'));
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Clear session variables.
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_email');
  }
}
