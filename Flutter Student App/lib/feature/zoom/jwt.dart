import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:opencentric_lms/feature/zoom/config.dart';

String generateZoomJWT() {
  final iat = DateTime.now().millisecondsSinceEpoch ~/ 1000 - 30;
  final exp = iat + 60 * 60 * 2;

  final oPayload = {
    'sdkKey': kZoomMeetingSdkKeyForJWT,
    'iat': iat,
    "role": 1,
    'exp': exp,
    'appKey': kZoomMeetingSdkKeyForJWT,
    'tokenExp': iat + 60 * 60 * 2
  };

  final jwt = JWT(
    oPayload,
    header: {
      'alg': 'HS256',
      'typ': 'JWT',
    },
  );

  final jwtToken = jwt.sign(SecretKey(kZoomMeetingSdkSecretForJWT));

  return jwtToken;
}

String getUid(String token) {
  try {
    final decodedToken = JWT.decode(token);
    final uid = decodedToken.payload['uid'] ?? "";

    return uid;
  } catch (e) {
    return ""; // Error during decoding or invalid token
  }
}

bool isTokenExpired(String token) {
  try {
    final decodedToken = JWT.decode(token);
    final expirationTime = decodedToken.payload['tokenExp'] ?? 0;

    final currentTimeInSeconds =
        DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    return expirationTime <= currentTimeInSeconds;
  } catch (e) {
    return true; // Error during decoding or invalid token
  }
}
