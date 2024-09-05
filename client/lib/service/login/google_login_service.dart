import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class GoogleLoginService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    clientId:
        '265155661752-3so9el1vfuik4kkameqr4k0c2oqb4av6.apps.googleusercontent.com',
  );

  Future<bool> handleSignIn() async {
    await dotenv.load(fileName: '.env');

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        String serverUrl = dotenv.get("SERVER_URL");

        // 백엔드로 ID 토큰 전송
        final response = await http.post(
          Uri.parse('$serverUrl/login/google'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            'token': googleAuth.idToken,
            'os': Platform.isAndroid ? 'android' : 'ios'
          }),
        );

        var res = jsonDecode(response.body);
        String accessToken = res['access_token'];
        bool userExist = res['user_exist'];

        if (response.statusCode == 200) {
          // 로그인 성공
          return true;
        } else {
          // 로그인 실패
          return false;
        }
      }
    } catch (error) {
      print(error);
    }
    return false;
  }
}
