import 'dart:convert';
import 'package:http/http.dart' as http;

class OtpService {
  static const String _baseUrl = 'http://your-server-domain.com:3000/api/otp';
  static const String _apiKey = 'your-api-key-here'; // Replace with your actual API key
  
  // Send OTP for email verification
  static Future<OtpResponse> sendVerificationOtp(String email, {String? userName}) async {
    return _sendOtp(email, 'verification', userName: userName);
  }
  
  // Send OTP for password reset
  static Future<OtpResponse> sendPasswordResetOtp(String email, {String? userName}) async {
    return _sendOtp(email, 'password_reset', userName: userName);
  }
  
  // Send password reset link (Firebase style)
  static Future<OtpResponse> sendPasswordResetLink(String email, {String? userName}) async {
    return _sendOtp(email, 'password_reset_link', userName: userName);
  }
  
  // Private method to send OTP
  static Future<OtpResponse> _sendOtp(String email, String purpose, {String? userName}) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/send'),
        headers: {
          'Content-Type': 'application/json',
          'X-API-Key': _apiKey,
        },
        body: jsonEncode({
          'email': email,
          'purpose': purpose,
          if (userName != null) 'userName': userName,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return OtpResponse(
          success: true,
          message: data['message'],
          email: data['data']['email'],
          expiryTime: DateTime.parse(data['data']['expiryTime']),
          messageId: data['data']['messageId'],
        );
      } else {
        return OtpResponse(
          success: false,
          error: data['error'] ?? 'Failed to send OTP',
          message: data['message'] ?? data['details'] ?? 'Unknown error occurred',
        );
      }
    } catch (e) {
      return OtpResponse(
        success: false,
        error: 'Network Error',
        message: 'Failed to connect to OTP service: $e',
      );
    }
  }
  
  // Verify OTP
  static Future<OtpVerificationResponse> verifyOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/verify'),
        headers: {
          'Content-Type': 'application/json',
          'X-API-Key': _apiKey,
        },
        body: jsonEncode({
          'email': email,
          'otp': otp,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return OtpVerificationResponse(
          success: true,
          message: data['message'],
          email: data['data']['email'],
          verified: data['data']['verified'],
          timestamp: DateTime.parse(data['data']['timestamp']),
        );
      } else {
        return OtpVerificationResponse(
          success: false,
          error: data['error'] ?? 'Verification failed',
          message: data['message'] ?? 'Invalid OTP or verification failed',
          verified: false,
        );
      }
    } catch (e) {
      return OtpVerificationResponse(
        success: false,
        error: 'Network Error',
        message: 'Failed to connect to OTP service: $e',
        verified: false,
      );
    }
  }
  
  // Test email connection
  static Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/test-connection'),
        headers: {
          'X-API-Key': _apiKey,
        },
      );

      final data = jsonDecode(response.body);
      return response.statusCode == 200 && data['connected'] == true;
    } catch (e) {
      return false;
    }
  }
  
  // Send test email
  static Future<bool> sendTestEmail(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/test-email'),
        headers: {
          'Content-Type': 'application/json',
          'X-API-Key': _apiKey,
        },
        body: jsonEncode({
          'email': email,
        }),
      );

      final data = jsonDecode(response.body);
      return response.statusCode == 200 && data['success'] == true;
    } catch (e) {
      return false;
    }
  }
}

class OtpResponse {
  final bool success;
  final String? message;
  final String? error;
  final String? email;
  final DateTime? expiryTime;
  final String? messageId;

  OtpResponse({
    required this.success,
    this.message,
    this.error,
    this.email,
    this.expiryTime,
    this.messageId,
  });

  @override
  String toString() {
    return 'OtpResponse(success: $success, message: $message, error: $error)';
  }
}

class OtpVerificationResponse {
  final bool success;
  final String? message;
  final String? error;
  final String? email;
  final bool verified;
  final DateTime? timestamp;

  OtpVerificationResponse({
    required this.success,
    this.message,
    this.error,
    this.email,
    required this.verified,
    this.timestamp,
  });

  @override
  String toString() {
    return 'OtpVerificationResponse(success: $success, verified: $verified, message: $message, error: $error)';
  }
}