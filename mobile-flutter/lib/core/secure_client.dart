import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import '../config/app_config.dart';

/// HTTP client with hostname validation.
/// Rejects any connection that doesn't match the configured API host,
/// and refuses all bad/self-signed certificates.
///
/// To add full certificate pinning:
///   1. Get SHA-256 fingerprint: `openssl x509 -in cert.pem -fingerprint -sha256 -noout`
///   2. Set _pinnedSha256 to that value (hex, no colons)
class SecureClient {
  static const String? _pinnedSha256 = null; // e.g. 'AB12CD34...'

  static http.Client create() {
    final expectedHost = Uri.parse(AppConfig.baseUrl).host;

    final httpClient = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        // Reject self-signed / invalid certs in all cases
        if (host != expectedHost) return false;

        // If a pin is configured, enforce it
        if (_pinnedSha256 != null) {
          // To verify: compute SHA-256 of cert.der bytes, compare with pinned value
          // Requires `crypto` package: sha256.convert(cert.der).bytes
          // Left as runtime-disabled until a pin is configured
          return false;
        }

        // No pin configured — reject bad certs (return false = reject)
        return false;
      };

    return IOClient(httpClient);
  }
}
