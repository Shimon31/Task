import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';
import '../../core/network/exceptions.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await client
          .get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.productsEndpoint}'),
        headers: {'Content-Type': 'application/json'},
      )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((json) =>
            ProductModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
            'Server error: ${response.statusCode}. Please try again.');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw const NetworkException(
          'Network error. Please check your internet connection.');
    }
  }
}