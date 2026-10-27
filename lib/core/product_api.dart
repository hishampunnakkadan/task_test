import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/productmodel.dart';

Future<List<Product>> getProducts() async {
  final response = await http.get(
    Uri.parse('https://fakestoreapi.com/products'),
  );

  if (response.statusCode == 200) {
    List data = jsonDecode(response.body);

    return data.map((e) => Product.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load products');
  }
}
