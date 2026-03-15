import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/io_client.dart';

class SSLPinning {
  static Future<SecurityContext> get globalContext async {
    final sslCert = await rootBundle.load('certificates/certificates.pem');
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
    return securityContext;
  }

  static Future<IOClient> get ioClient async {
    final context = await globalContext;
    final httpClient = HttpClient(context: context);

    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;

    return IOClient(httpClient);
  }
}
