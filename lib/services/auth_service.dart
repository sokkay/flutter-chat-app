import 'dart:convert';
import 'dart:io';

import 'package:chat/global/environment.dart';
import 'package:chat/helpers/handle_error.dart';
import 'package:chat/models/login_response.dart';
import 'package:chat/models/usuario.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Usuario _usuario;
  final _storage = new FlutterSecureStorage();
  static AuthService _instance;

  factory AuthService() {
    if (_instance == null) {
      _instance = new AuthService._();
    }
    return _instance;
  }

  AuthService._();

  Usuario get usuario => this._usuario;
  set usuario(Usuario usuario) => this._usuario = usuario;

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
        return handleError(errorResponse['errors']);
      }
    } catch (e) {
      print(e);
      return "Error inesperado";
    }
  }

  Future<String> register(String name, String email, String password) async {
    final data = {'name': name, 'email': email, 'password': password};
    try {
      final resp = await http.post(
        '${Environment.apiUrl}/login/new',
        body: jsonEncode(data),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
      if (resp.statusCode == 201) {
        final loginResponse = LoginResponse.fromJson(resp.body);
        this._usuario = loginResponse.usuario;
        await this._saveToken(loginResponse.token);
        return null;
      } else {
        final errorResponse = jsonDecode(resp.body);
        return handleError(errorResponse['errors']);
      }
    } catch (e, stack) {
      print(e);
      print(stack);
      return "Error inesperado";
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await this._storage.read(key: 'token');
    if (this._usuario != null) {
      return true;
    }
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
      return false;
    }
  }

  Future<void> logout() async {
    await this._storage.delete(key: 'token');
  }

  Future<void> _saveToken(String token) async {
    await this._storage.write(key: 'token', value: token);
  }
}
