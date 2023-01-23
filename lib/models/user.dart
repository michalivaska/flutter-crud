import 'dart:convert';

import 'package:http/http.dart' as http;

class User {
  final String id;
  final Civilite civilite;
  final String nom;
  final String? email;

  // ajouter sa propre clé API
  static const _baseUrl = 'https://crudcrud.com/api/[CLE_API]/users';

  static const _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  User.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        civilite = Civilite.values.byName(json['civilite']),
        nom = json['nom'],
        email = json['email'];

  static Future<List<User>> getAll() async {
    final url = Uri.parse(_baseUrl);
    final response = await http.get(url, headers: _headers);
    final data = jsonDecode(response.body) as List;
    return data.map((item) => User.fromJson(item)).toList();
  }

  static Future<void> create(Map<String, dynamic> data) async {
    final url = Uri.parse(_baseUrl);
    await http.post(
      url,
      headers: _headers,
      body: jsonEncode(data),
    );
  }

  Future<void> update(Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl/$id');
    await http.put(
      url,
      headers: _headers,
      body: jsonEncode(data),
    );
  }

  Future<void> delete() async {
    final url = Uri.parse('$_baseUrl/$id');
    await http.delete(
      url,
      headers: _headers,
    );
  }
}

enum Civilite { madame, monsieur }
