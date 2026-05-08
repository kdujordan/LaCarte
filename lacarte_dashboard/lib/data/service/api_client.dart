import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: "http://127.0.0.1:8000/api")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  // ==================== Authentication ====================
  @POST("/signup/")
  Future<UserResponse> signup(@Body() SignupRequest request);

  @POST("/token/")
  Future<TokenResponse> login(@Body() LoginRequest request);

  @POST("/token/refresh/")
  Future<TokenResponse> refreshToken(@Body() RefreshTokenRequest request);

  // ==================== Orders ====================
  @GET("/orders/")
  Future<List<OrderResponse>> getOrders(
    @Query("status") String? status,
    @Query("ordering") String? ordering,
  );

  @GET("/orders/{id}/")
  Future<OrderResponse> getOrderById(@Path("id") int id);

  @PATCH("/orders/{id}/update_status/")
  Future<OrderResponse> updateOrderStatus(
    @Path("id") int id,
    @Body() UpdateOrderStatusRequest request,
  );

  // ==================== Analytics ====================
  @GET("/analytics/daily-sales/")
  Future<DailySalesResponse> getDailySales();

  @GET("/analytics/products/")
  Future<List<ProductAnalyticsResponse>> getProductsAnalytics();

  @GET("/analytics/menu-popularity/")
  Future<List<MenuPopularityResponse>> getMenuPopularity();

  @GET("/analytics/sales-trend/")
  Future<SalesTrendResponse> getSalesTrend();

  // ==================== Staff Management ====================
  @GET("/analytics/staff/")
  Future<List<StaffResponse>> getStaffList();

  @GET("/analytics/staff/pending_staff_approvals/")
  Future<List<StaffResponse>> getPendingStaffApprovals();

  @PATCH("/analytics/staff/{id}/approve_staff/")
  Future<StaffResponse> approveStaff(@Path("id") int id);

  @DELETE("/analytics/staff/{id}/reject_staff/")
  Future<void> rejectStaff(@Path("id") int id);

  // ==================== Menu Items ====================
  @GET("/menu-items/")
  Future<List<MenuItemResponse>> getMenuItems();

  @GET("/menu-items/{id}/")
  Future<MenuItemResponse> getMenuItemById(@Path("id") int id);

  @POST("/menu-items/create_menu_item/")
  @MultiPart()
  Future<MenuItemResponse> createMenuItem(
    @Part(name: "name") String name,
    @Part(name: "description") String description,
    @Part(name: "price") double price,
    @Part(name: "category") int category,
    @Part(name: "image") MultipartFile image,
  );

  @PUT("/menu-items/{id}/update_menu_item/")
  Future<MenuItemResponse> updateMenuItem(
    @Path("id") int id,
    @Body() MenuItemRequest request,
  );

  @DELETE("/menu-items/{id}/delete_menu_item/")
  Future<void> deleteMenuItem(@Path("id") int id);

  // ==================== Feedback ====================
  @GET("/feedback/")
  Future<List<FeedbackResponse>> getFeedback();

  @POST("/feedback/")
  Future<FeedbackResponse> submitFeedback(@Body() FeedbackRequest request);
}

// ==================== Request/Response Models ====================

@JsonSerializable()
class SignupRequest {
  final String email;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  final String password;
  final String role;

  SignupRequest({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.role,
  });

  factory SignupRequest.fromJson(Map<String, dynamic> json) =>
      _$SignupRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SignupRequestToJson(this);
}

@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

@JsonSerializable()
class TokenResponse {
  final String access;
  final String refresh;
  @JsonKey(name: 'user')
  final UserResponse? user;

  TokenResponse({required this.access, required this.refresh, this.user});

  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TokenResponseToJson(this);
}

@JsonSerializable()
class RefreshTokenRequest {
  final String refresh;

  RefreshTokenRequest({required this.refresh});

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenRequestToJson(this);
}

@JsonSerializable()
class UserResponse {
  final int id;
  final String email;
  final String role;
  @JsonKey(name: 'is_approved')
  final bool isApproved;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;

  UserResponse({
    required this.id,
    required this.email,
    required this.role,
    required this.isApproved,
    required this.firstName,
    required this.lastName,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}

@JsonSerializable()
class OrderResponse {
  final int id;
  @JsonKey(name: 'order_type')
  final String orderType;
  final String status;
  @JsonKey(name: 'total_price')
  final double totalPrice;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  final SessionResponse? session;
  final List<OrderItemResponse> items;

  OrderResponse({
    required this.id,
    required this.orderType,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
    this.session,
    required this.items,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderResponseToJson(this);
}

@JsonSerializable()
class SessionResponse {
  @JsonKey(name: 'session_id')
  final String sessionId;
  final TableResponse? table;
  @JsonKey(name: 'is_active')
  final bool isActive;

  SessionResponse({
    required this.sessionId,
    this.table,
    required this.isActive,
  });

  factory SessionResponse.fromJson(Map<String, dynamic> json) =>
      _$SessionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SessionResponseToJson(this);
}

@JsonSerializable()
class TableResponse {
  final int id;
  @JsonKey(name: 'table_number')
  final int tableNumber;
  @JsonKey(name: 'is_active')
  final bool isActive;

  TableResponse({
    required this.id,
    required this.tableNumber,
    required this.isActive,
  });

  factory TableResponse.fromJson(Map<String, dynamic> json) =>
      _$TableResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TableResponseToJson(this);
}

@JsonSerializable()
class OrderItemResponse {
  final int id;
  @JsonKey(name: 'menu_item')
  final MenuItemResponse menuItem;
  final int quantity;
  @JsonKey(name: 'special_requests')
  final String specialRequests;

  OrderItemResponse({
    required this.id,
    required this.menuItem,
    required this.quantity,
    required this.specialRequests,
  });

  factory OrderItemResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemResponseToJson(this);
}

@JsonSerializable()
class UpdateOrderStatusRequest {
  final String status;

  UpdateOrderStatusRequest({required this.status});

  factory UpdateOrderStatusRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateOrderStatusRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateOrderStatusRequestToJson(this);
}

@JsonSerializable()
class DailySalesResponse {
  final int id;
  final DateTime date;
  @JsonKey(name: 'total_revenue')
  final double totalRevenue;
  @JsonKey(name: 'total_orders')
  final int totalOrders;
  @JsonKey(name: 'takeaway_orders')
  final int takeawayOrders;
  @JsonKey(name: 'dine_in_orders')
  final int dineInOrders;
  @JsonKey(name: 'peak_hour')
  final String peakHour;
  @JsonKey(name: 'revenue_change')
  final double? revenueChange;
  @JsonKey(name: 'order_change')
  final double? orderChange;

  DailySalesResponse({
    required this.id,
    required this.date,
    required this.totalRevenue,
    required this.totalOrders,
    required this.takeawayOrders,
    required this.dineInOrders,
    required this.peakHour,
    this.revenueChange,
    this.orderChange,
  });

  factory DailySalesResponse.fromJson(Map<String, dynamic> json) =>
      _$DailySalesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DailySalesResponseToJson(this);
}

@JsonSerializable()
class ProductAnalyticsResponse {
  final int id;
  @JsonKey(name: 'menu_item')
  final int menuItemId;
  @JsonKey(name: 'total_quantity_sold')
  final int totalQuantitySold;
  @JsonKey(name: 'total_revenue')
  final double totalRevenue;

  ProductAnalyticsResponse({
    required this.id,
    required this.menuItemId,
    required this.totalQuantitySold,
    required this.totalRevenue,
  });

  factory ProductAnalyticsResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductAnalyticsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductAnalyticsResponseToJson(this);
}

@JsonSerializable()
class MenuPopularityResponse {
  final int id;
  @JsonKey(name: 'menu_item')
  final String menuItem;
  @JsonKey(name: 'sales_count')
  final int salesCount;

  MenuPopularityResponse({
    required this.id,
    required this.menuItem,
    required this.salesCount,
  });

  factory MenuPopularityResponse.fromJson(Map<String, dynamic> json) =>
      _$MenuPopularityResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MenuPopularityResponseToJson(this);
}

@JsonSerializable()
class SalesTrendResponse {
  final List<String> labels;
  final List<double> revenue;
  @JsonKey(name: 'orders_volume')
  final List<int> ordersVolume;
  @JsonKey(name: 'order_type_distribution')
  final OrderTypeDistribution orderTypeDistribution;

  SalesTrendResponse({
    required this.labels,
    required this.revenue,
    required this.ordersVolume,
    required this.orderTypeDistribution,
  });

  factory SalesTrendResponse.fromJson(Map<String, dynamic> json) =>
      _$SalesTrendResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SalesTrendResponseToJson(this);
}

@JsonSerializable()
class OrderTypeDistribution {
  final int takeaway;
  @JsonKey(name: 'dine_in')
  final int dineIn;

  OrderTypeDistribution({required this.takeaway, required this.dineIn});

  factory OrderTypeDistribution.fromJson(Map<String, dynamic> json) =>
      _$OrderTypeDistributionFromJson(json);

  Map<String, dynamic> toJson() => _$OrderTypeDistributionToJson(this);
}

@JsonSerializable()
class MenuItemResponse {
  final int id;
  final String name;
  final String description;
  final double price;
  final int category;
  final String image;
  @JsonKey(name: 'is_available')
  final bool isAvailable;

  MenuItemResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.image,
    required this.isAvailable,
  });

  factory MenuItemResponse.fromJson(Map<String, dynamic> json) =>
      _$MenuItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MenuItemResponseToJson(this);
}

@JsonSerializable()
class MenuItemRequest {
  final String name;
  final String description;
  final double price;
  final int category;
  @JsonKey(name: 'is_available')
  final bool isAvailable;

  MenuItemRequest({
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.isAvailable,
  });

  factory MenuItemRequest.fromJson(Map<String, dynamic> json) =>
      _$MenuItemRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MenuItemRequestToJson(this);
}

@JsonSerializable()
class FeedbackResponse {
  final int id;
  final String message;
  final int rating;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  final String? email;

  FeedbackResponse({
    required this.id,
    required this.message,
    required this.rating,
    required this.createdAt,
    this.email,
  });

  factory FeedbackResponse.fromJson(Map<String, dynamic> json) =>
      _$FeedbackResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FeedbackResponseToJson(this);
}

@JsonSerializable()
class FeedbackRequest {
  final String message;
  final int rating;
  final String? email;

  FeedbackRequest({required this.message, required this.rating, this.email});

  factory FeedbackRequest.fromJson(Map<String, dynamic> json) =>
      _$FeedbackRequestFromJson(json);

  Map<String, dynamic> toJson() => _$FeedbackRequestToJson(this);
}

@JsonSerializable()
class StaffResponse {
  final int id;
  final String email;
  final String role;
  @JsonKey(name: 'is_approved')
  final bool isApproved;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;

  StaffResponse({
    required this.id,
    required this.email,
    required this.role,
    required this.isApproved,
    required this.firstName,
    required this.lastName,
  });

  factory StaffResponse.fromJson(Map<String, dynamic> json) =>
      _$StaffResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StaffResponseToJson(this);
}
