import 'package:chatapp/global/enviroment.dart';
import 'package:chatapp/models/login_response.dart';
import 'package:chatapp/models/usuario.dart';

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  // Properties
  late Usuario usuario;
  bool _autenticando = false;

  bool get autenticando => this._autenticando;
  set autenticando(bool value) {
    this._autenticando = value;
    notifyListeners();
  }

  final _storage = new FlutterSecureStorage();
// getter y settet
  static Future<String?> getToken() async {
    final _storage = new FlutterSecureStorage();
    return await _storage.read(key: 'token');
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

// End points
  Future<bool> login(String email, String password) async {
    this.autenticando = true;
    final data = {'email': email, 'password': password};

    final resp = await http.post(Uri.parse("${Environment.apiUrl}/login"),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    this.autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);

      this.usuario = loginResponse.usuario;
      await this._guardarToken(loginResponse.token);

      return true;
    } else {
      return false;
    }
  }

  Future register(String nombre, String email, String password) async {
    this.autenticando = true;
    final data = {'nombre': nombre, 'email': email, 'password': password};

    final resp = await http.post(Uri.parse("${Environment.apiUrl}/login/new"),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    this.autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);

      this.usuario = loginResponse.usuario;
      await this._guardarToken(loginResponse.token);

      return true;
    } else {
      final resBody = jsonDecode(resp.body);
      return resBody['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    String? token = await this._storage.read(key: 'token');
    if (token == null) {
      token = "";
    }
    final resp = await http
        .get(Uri.parse("${Environment.apiUrl}/login/renew"), headers: {
      'Content-Type': 'application/json',
      'x-token': token,
    });

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);

      this.usuario = loginResponse.usuario;
      await this._guardarToken(loginResponse.token);

      return true;
    } else {
      this._logout();
      return false;
    }
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future _logout() async {
    await _storage.delete(key: 'token');
    // return await _storage.write(key: 'token', value: token);
  }
}
