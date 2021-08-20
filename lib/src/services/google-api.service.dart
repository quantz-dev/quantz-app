import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../core/index.dart';
import '../data/index.dart';
import '../widgets/index.dart';
import 'interface/google-api.interface.dart';

class GoogleApiService extends GoogleApiInterface {
  final _dio = Dio();

  Future<FirebaseSubscription> getFirebaseSubscription() async {
    var token = await FirebaseMessaging.instance.getToken();
    final path = '$api/topics/$token';
    try {
      var response = await _dio.post(path);
      return FirebaseSubscription.fromJson(response.data);
    } catch (e) {
      print(e);
      print(['ERROR', path]);
      return FirebaseSubscription();
    }
  }

  Future<String> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        return googleAuth.idToken ?? '';
      }
      return '';
    } catch (e) {
      print(e);
      showToast('$e', error: true);
      return '';
    }
  }

  Future<String> refreshToken() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signInSilently();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        return googleAuth.idToken ?? '';
      }
      return '';
    } catch (e) {
      print(e);
      showToast('$e', error: true);
      return '';
    }
  }
}
