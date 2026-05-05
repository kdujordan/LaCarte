import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:lacarte_dashboard/data/repositories/analytics_repository.dart';
import 'package:lacarte_dashboard/data/service/api_client.dart';

enum AnalyticsStatus { idle, loading, success, error }

class AnalyticsViewModel extends ChangeNotifier {
  final AnalyticsRepository _analyticsRepository = AnalyticsRepository();

  // States
  AnalyticsStatus _dailySalesStatus = AnalyticsStatus.idle;
  AnalyticsStatus _productsStatus = AnalyticsStatus.idle;
  AnalyticsStatus _menuPopularityStatus = AnalyticsStatus.idle;
  AnalyticsStatus _salesTrendStatus = AnalyticsStatus.idle;

  String? _errorMessage;

  // Data
  DailySalesResponse? _dailySalesData;
  List<ProductAnalyticsResponse> _productsData = [];
  List<MenuPopularityResponse> _menuPopularityData = [];
  SalesTrendResponse? _salesTrendData;

  // Getters
  AnalyticsStatus get dailySalesStatus => _dailySalesStatus;
  AnalyticsStatus get productsStatus => _productsStatus;
  AnalyticsStatus get menuPopularityStatus => _menuPopularityStatus;
  AnalyticsStatus get salesTrendStatus => _salesTrendStatus;
  String? get errorMessage => _errorMessage;

  DailySalesResponse? get dailySalesData => _dailySalesData;
  List<ProductAnalyticsResponse> get productsData => _productsData;
  List<MenuPopularityResponse> get menuPopularityData => _menuPopularityData;
  SalesTrendResponse? get salesTrendData => _salesTrendData;

  Future<void> fetchDailySales() async {
    _setDailySalesStatus(AnalyticsStatus.loading);
    try {
      _dailySalesData = await _analyticsRepository.getDailySales();
      _setDailySalesStatus(AnalyticsStatus.success);
    } on DioException catch (e) {
      _setError('Failed to fetch daily sales: ${e.message}');
    } catch (e) {
      _setError('An error occurred: $e');
    }
  }

  Future<void> fetchProductsAnalytics() async {
    _setProductsStatus(AnalyticsStatus.loading);
    try {
      _productsData = await _analyticsRepository.getProductsAnalytics();
      _setProductsStatus(AnalyticsStatus.success);
    } on DioException catch (e) {
      _setError('Failed to fetch products analytics: ${e.message}');
    } catch (e) {
      _setError('An error occurred: $e');
    }
  }

  Future<void> fetchMenuPopularity() async {
    _setMenuPopularityStatus(AnalyticsStatus.loading);
    try {
      _menuPopularityData = await _analyticsRepository.getMenuPopularity();
      _setMenuPopularityStatus(AnalyticsStatus.success);
    } on DioException catch (e) {
      _setError('Failed to fetch menu popularity: ${e.message}');
    } catch (e) {
      _setError('An error occurred: $e');
    }
  }

  Future<void> fetchSalesTrend() async {
    _setTrendStatus(AnalyticsStatus.loading);
    try {
      _salesTrendData = await _analyticsRepository.getSalesTrend();
      _setTrendStatus(AnalyticsStatus.success);
    } on DioException catch (e) {
      _setError('Failed to fetch sales trend: ${e.message}');
    } catch (e) {
      _setError('An error occurred: $e');
    }
  }

  // Fetch all analytics data
  Future<void> fetchAllAnalytics() async {
    await Future.wait([
      fetchDailySales(),
      fetchProductsAnalytics(),
      fetchMenuPopularity(),
      fetchSalesTrend(),
    ]);
  }

  // Helper methods
  void _setDailySalesStatus(AnalyticsStatus status) {
    _dailySalesStatus = status;
    notifyListeners();
  }

  void _setProductsStatus(AnalyticsStatus status) {
    _productsStatus = status;
    notifyListeners();
  }

  void _setMenuPopularityStatus(AnalyticsStatus status) {
    _menuPopularityStatus = status;
    notifyListeners();
  }

  void _setTrendStatus(AnalyticsStatus status) {
    _salesTrendStatus = status;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Analytics calculations
  double getTotalRevenue() {
    return _dailySalesData?.totalRevenue ?? 0;
  }

  int getTotalOrders() {
    return _dailySalesData?.totalOrders ?? 0;
  }

  double getRevenueChange() {
    return _dailySalesData?.revenueChange ?? 0;
  }

  double getOrderChange() {
    return _dailySalesData?.orderChange ?? 0;
  }

  // Get top selling products
  List<ProductAnalyticsResponse> getTopProducts({int limit = 5}) {
    final sorted = List<ProductAnalyticsResponse>.from(_productsData);
    sorted.sort((a, b) => b.totalQuantitySold.compareTo(a.totalQuantitySold));
    return sorted.take(limit).toList();
  }

  // Get top popular menu items
  List<MenuPopularityResponse> getTopMenuItems({int limit = 5}) {
    final sorted = List<MenuPopularityResponse>.from(_menuPopularityData);
    sorted.sort((a, b) => b.salesCount.compareTo(a.salesCount));
    return sorted.take(limit).toList();
  }

  // Check if all data is loaded
  bool get isAllDataLoaded =>
      _dailySalesStatus == AnalyticsStatus.success &&
      _productsStatus == AnalyticsStatus.success &&
      _menuPopularityStatus == AnalyticsStatus.success &&
      _salesTrendStatus == AnalyticsStatus.success;

  // Check if any data is loading
  bool get isLoading =>
      _dailySalesStatus == AnalyticsStatus.loading ||
      _productsStatus == AnalyticsStatus.loading ||
      _menuPopularityStatus == AnalyticsStatus.loading ||
      _salesTrendStatus == AnalyticsStatus.loading;
}
