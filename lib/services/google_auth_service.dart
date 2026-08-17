import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aetherdx/core/network/api_service.dart';

class GoogleAuthService {
  // Firebase project: aetherdx-app  |  project number: 493392434693
  // Web Client ID (client_type: 3) from google-services.json:
  static const String _fallbackClientId =
      '493392434693-01cog26oamu0iaq470i0ikgfambnqa9o.apps.googleusercontent.com';

  static String get serverClientId {
    final raw = dotenv.maybeGet('GOOGLE_SERVER_CLIENT_ID') ??
        dotenv.maybeGet('google_server_client_id') ??
        _fallbackClientId;
    return raw.trim();
  }

  static bool get _isClientIdConfigured {
    final id = serverClientId;
    return id.isNotEmpty &&
        !id.contains('YOUR_WEB_CLIENT') &&
        id.endsWith('.apps.googleusercontent.com');
  }

  /// Creates a fresh GoogleSignIn instance (reads serverClientId lazily after dotenv loaded)
  static GoogleSignIn _buildGoogleSignIn() {
    return GoogleSignIn(
      scopes: ['email', 'profile'],
      serverClientId: serverClientId,
    );
  }

  /// Performs Google Sign-In, retrieves the Google `idToken`, and sends it to
  /// `POST /auth/google`. Parses and saves `access_token` to local storage.
  ///
  /// Returns a `Map<String, dynamic>` with authentication info if successful,
  /// or `null` if the user cancelled sign in.
  /// Throws `Exception` on token verification errors or network failures.
  static Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      final googleSignIn = _buildGoogleSignIn();

      debugPrint('[GoogleAuth] serverClientId: $serverClientId');
      debugPrint('[GoogleAuth] isClientIdConfigured: $_isClientIdConfigured');

      // Clear any previous sign-in session to force the account chooser dialog
      try {
        await googleSignIn.signOut();
      } catch (e) {
        debugPrint('[GoogleAuth] Pre-signin signOut error: $e');
      }

      // 1. Open Google account selection dialog
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled sign in
        debugPrint('[GoogleAuth] Cancelled by user.');
        return null;
      }

      debugPrint('[GoogleAuth] Signed in as: ${googleUser.email}');

      // 2. Retrieve authentication credentials (idToken)
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      debugPrint('[GoogleAuth] idToken is ${idToken == null ? "NULL" : "present (length: ${idToken.length})"}');

      if (idToken == null || idToken.isEmpty) {
        throw Exception(
          'Failed to retrieve Google ID Token.\n'
          'This usually means the serverClientId is wrong or not set.\n'
          'Current client ID: $serverClientId',
        );
      }

      // 3. Send idToken via POST /auth/google to backend API
      final url = Uri.parse('${ApiService.baseUrl}/auth/google');
      debugPrint('[GoogleAuth] Posting to: $url');

      final http.Response response;
      try {
        response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'ngrok-skip-browser-warning': 'true',
          },
          body: json.encode({
            'id_token': idToken,
          }),
        );
      } catch (e) {
        throw Exception('Network error connecting to authentication server: $e');
      }

      debugPrint('[GoogleAuth] Backend response: ${response.statusCode} ${response.body}');

      // 4. Parse response {"access_token": "...", "token_type": "bearer"}
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final accessToken = data['access_token'] as String?;

        if (accessToken == null || accessToken.isEmpty) {
          throw Exception('Backend server returned an invalid or empty access token.');
        }

        // 5. Save access_token and user_email using SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', accessToken);
        await prefs.setString('user_email', googleUser.email);
        if (googleUser.displayName != null && googleUser.displayName!.isNotEmpty) {
          await prefs.setString('user_name', googleUser.displayName!);
        }

        return {
          'access_token': accessToken,
          'user_email': googleUser.email,
          'user_name': googleUser.displayName,
          'photo_url': googleUser.photoUrl,
        };
      } else {
        // Backend token verification error
        String errorDetail = 'Google token verification failed (${response.statusCode})';
        try {
          final errData = json.decode(response.body);
          if (errData is Map && errData.containsKey('detail')) {
            final detail = errData['detail'];
            if (detail is String) {
              errorDetail = detail;
            } else if (detail is List) {
              errorDetail = detail
                  .map((e) => e is Map ? (e['msg'] ?? '') : '')
                  .where((s) => s.toString().isNotEmpty)
                  .join('\n');
            }
          }
        } catch (_) {}
        throw Exception(errorDetail);
      }
    } catch (e) {
      // Re-throw formatted exception unless it's user cancellation
      final errStr = e.toString();
      debugPrint('[GoogleAuth] Error: $errStr');

      if (errStr.contains('sign_in_canceled') || errStr.contains('canceled')) {
        return null;
      }

      if (e is PlatformException && e.code == 'sign_in_failed') {
        final code = e.message ?? '';
        if (code.contains('10:') || code.contains('ApiException: 10')) {
          // ApiException 10 = DEVELOPER_ERROR
          throw Exception(
            'Google Sign-In: Developer Config Error\n'
            '• SHA-1 "50:B2:C6:EB:12:06:A7:31:D1:69:13:9C:B3:ED:4B:21:9C:9F:7F:D7" '
            'must be added to Firebase Console → Project Settings → Your Android App.\n'
            '• Then download the updated google-services.json and re-run the app.',
          );
        }
        throw Exception('Google Sign-In failed: ${e.message ?? e.code}');
      }

      rethrow;
    }
  }

  /// Sign out from Google session
  static Future<void> signOut() async {
    try {
      await _buildGoogleSignIn().signOut();
    } catch (e) {
      debugPrint('[GoogleAuth] SignOut error: $e');
    }
  }
}
