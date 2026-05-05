import 'package:lacarte_dashboard/data/service/api_client.dart';
import 'package:lacarte_dashboard/data/service/dio_client.dart';

class AnalyticsRepository {
  final ApiClient _apiClient = DioClient().apiClient;

  Future<DailySalesResponse> getDailySales() async {
    try {
      return await _apiClient.getDailySales();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ProductAnalyticsResponse>> getProductsAnalytics() async {
    try {
      return await _apiClient.getProductsAnalytics();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MenuPopularityResponse>> getMenuPopularity() async {
    try {
      return await _apiClient.getMenuPopularity();
    } catch (e) {
      rethrow;
    }
  }

  Future<SalesTrendResponse> getSalesTrend() async {
    try {
      return await _apiClient.getSalesTrend();
    } catch (e) {
      rethrow;
    }
  }
}
