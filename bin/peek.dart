// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> main() async {
  final response = await http.get(Uri.parse('https://dummyjson.com/products/0'));
  print(response.statusCode);
  print(response.body);
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  print(json['title']);
  print(json['dimensions'].runtimeType);
  
}