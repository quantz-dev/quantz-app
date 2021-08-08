import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:momentum/momentum.dart';

class FcmService extends MomentumService {
  RemoteMessage? _message;
  RemoteMessage? get message => _message;

  void setMessage(RemoteMessage? message) {
    _message = message;
  }

  void clear() {
    _message = null;
  }
}
