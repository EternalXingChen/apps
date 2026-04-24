import 'dart:convert';
import 'package:crypto/crypto.dart';

class SecurityUtils {
  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  String encrypt(String data) {
    // Simple base64 encoding for now
    return base64Encode(utf8.encode(data));
  }

  String decrypt(String encryptedData) {
    // Simple base64 decoding
    return utf8.decode(base64Decode(encryptedData));
  }
}
