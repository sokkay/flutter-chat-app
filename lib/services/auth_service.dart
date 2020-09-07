import 'dart:convert';
import 'dart:io';

import 'package:chat/global/environment.dart';
import 'package:chat/models/login_response.dart';
import 'package:chat/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  Usuario _usuario;
  bool _autenticando = false;
  final _storage = new FlutterSecureStorage();

  bool get autenticando => this._autenticando;
  Usuario get usuario => this._usuario;

  set autenticando(bool valor) {
    this._autenticando = valor;
    notifyListeners();
  }

  //Getters del token
  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> delteToken() async {
    final storage = new FlutterSecureStorage();
    await storage.delete(key: 'token');
  }

  Future<String> login(String email, String password) async {
    this.autenticando = true;
    final data = {'email': email, 'password': password};

    try {
      final resp = await http.post(
        '${Environment.apiUrl}/login',
        body: jsonEncode(data),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
      if (resp.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(resp.body);
        this._usuario = loginResponse.usuario;
        await this._saveToken(loginResponse.token);
        return null;
      } else {
        final errorResponse = jsonDecode(resp.body);
        return _handleError(errorResponse['errors']);
      }
    } catch (e) {
      print(e);
    } finally {
      this.autenticando = false;
    }
    return null;
  }

  Future<String> register(String name, String email, String password) async {
    this.autenticando = true;
    final data = {'nombre': name, 'email': email, 'password': password};
    try {
      final resp = await http.post(
        '${Environment.apiUrl}/login/new',
        body: jsonEncode(data),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
      if (resp.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(resp.body);
        this._usuario = loginResponse.usuario;
        await this._saveToken(loginResponse.token);
        return null;
      } else {
        final errorResponse = jsonDecode(resp.body);
        return _handleError(errorResponse['errors']);
      }
    } catch (e) {
      print(e);
    } finally {
      this.autenticando = false;
    }
    return null;
  }

  Future<bool> isLoggedIn() async {
    final token = await this._storage.read(key: 'token');
    try {
      final resp = await http.get(
        '${Environment.apiUrl}/login/renew',
        headers: {'x-token': token},
      );
      if (resp.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(resp.body);
        this._usuario = loginResponse.usuario;
        await this._saveToken(loginResponse.token);
        return true;
      } else {
        this.logout();
        return false;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    await this._storage.delete(key: 'token');
  }

  Future<void> _saveToken(String token) async {
    await this._storage.write(key: 'token', value: token);
  }

  String _handleError(Map<dynamic, dynamic> errors) {
    if (errors.containsKey('error')) {
      return errors['error'];
    } else {
      return errors.entries
          .map((e) => e.value['msg'])
          .reduce((value, element) => element + '\n' + value);
    }
  }
}
