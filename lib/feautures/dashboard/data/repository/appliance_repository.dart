import 'package:smartversemobile/core/network/api_client.dart';

import '../models/appliance.dart';
import '../models/appliance_category.dart';


class ApplianceRepository {
  final _dio = ApiClient.instance.dio;

  Future<List<Appliance>> getAppliances() async {
    final response = await _dio.get('/appliances');
    final list = response.data['data'] as List;
    return list
        .map((json) => Appliance.fromJson(json as Map<String, dynamic>))
        .where((a) => a.active)
        .toList();
  }

  Future<List<Category>> getCategories() async {
    final response = await _dio.get('/categories');
    final list = response.data['data'] as List;
    final categories = list.map((json) => Category.fromJson(json as Map<String, dynamic>)).toList();
    categories.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    return categories;
  }

  Future<List<Appliance>> searchAppliances(String query, {String? categoryId}) async {
    final response = await _dio.get('/appliances/search', queryParameters: {
      'search': query,
      if (categoryId != null) 'categoryId': categoryId,
    });
    final list = response.data['data'] as List;
    return list
        .map((json) => Appliance.fromJson(json as Map<String, dynamic>))
        .where((a) => a.active)
        .toList();
  }
}