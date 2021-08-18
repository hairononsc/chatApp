import 'dart:io';

class Environment {
  static String apiUrl = Platform.isAndroid
      ? 'http://192.168.0.105:3000/api'
      : 'http://192.168.0.105:3000/api';

  static String socketUrl =  Platform.isAndroid
      ? '192.168.0.5:3000'
      : '192.168.0.5:3000';
}
