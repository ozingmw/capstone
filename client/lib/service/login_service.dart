import 'dart:convert';
import 'dart:io';
import 'package:dayclover/service/token_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class GoogleLoginService {
  GoogleLoginService() {
    dotenv.load(fileName: '.env');
  }

  Future<dynamic> handleSignIn() async {
    // await dotenv.load(fileName: '.env');

    final GoogleSignIn googleSignIn = Platform.isAndroid
        ? GoogleSignIn(
            scopes: [
              'email',
            ],
            clientId:
                '265155661752-3so9el1vfuik4kkameqr4k0c2oqb4av6.apps.googleusercontent.com',
          )
        : GoogleSignIn(
            scopes: ['email'],
          );

    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // final headers = await googleUser.authHeaders;
        // final testuri = Uri.parse(
        //     'https://people.googleapis.com/v1/people/me?personFields=genders&key=',
        //     headers: {"Authorization": headers["Authorization"]});

        // 백엔드로 ID 토큰 전송
        final response = await http.post(
          Uri.parse('${dotenv.get("SERVER_URL")}/login/google'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            'token': googleAuth.idToken,
            'os': Platform.isAndroid ? 'android' : 'ios'
          }),
        );

        var res = jsonDecode(utf8.decode(response.bodyBytes));
        String accessToken = res['access_token'];
        String refreshToken = res['refresh_token'];

        await TokenService.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );

        return res;
      }
    } catch (error) {
      print(error);
      return 'error';
    }
  }

  Future<dynamic> syncGoogleAccount() async {
    String? guestAccessToken = await TokenService.getAccessToken();
    await handleSignIn();
    String? accessToken = await TokenService.getAccessToken();
    final response = await http.post(
      Uri.parse('${dotenv.get("SERVER_URL")}/login/sync/user'),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({
        'guest_token': guestAccessToken,
      }),
    );
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
}

class GuestLoginService {
  GuestLoginService() {
    dotenv.load(fileName: '.env');
  }

  Future<dynamic> handleSignIn() async {
    // await dotenv.load(fileName: '.env');

    try {
      final response = await http.post(
        Uri.parse('${dotenv.get("SERVER_URL")}/login/guest'),
        headers: {"Content-Type": "application/json"},
      );

      var res = jsonDecode(utf8.decode(response.bodyBytes));
      String accessToken = res['access_token'];
      String refreshToken = res['refresh_token'];

      await TokenService.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      return res;
    } catch (error) {
      print(error);
      return 'error';
    }
  }
}
