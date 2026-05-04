class OrderSession {
  final String sessionId;
  final String tableNumber;
  final String accessToken;

  const OrderSession({
    required this.sessionId,
    required this.tableNumber,
    required this.accessToken,
  });

  factory OrderSession.fromJson(Map<String, dynamic> json) {
    return OrderSession(
      sessionId: json['session_id'],
      tableNumber: json['table_number'],
      accessToken: json['access_token'],
    );
  }
}

enum OrderType { orderForSelf, orderForOthers }

enum OrderStatus { pending, preparing, served, paid, cancelled }

extension OrderStatusParsing on OrderStatus {
  static OrderStatus fromString(String s) {
    switch (s.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'preparing':
        return OrderStatus.preparing;
      case 'served':
        return OrderStatus.served;
      case 'paid':
        return OrderStatus.paid;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }

  String get label => switch (this) {
    OrderStatus.pending => 'Pending',
    OrderStatus.preparing => 'Preparing',
    OrderStatus.served => 'Served',
    OrderStatus.paid => 'Paid',
    OrderStatus.cancelled => 'Cancelled',
  };
}

class Order {
  final int id;
  final OrderStatus status;
  final double totalPrice;
  final DateTime createdAt;
  // final double totalPrice;
  final OrderType orderType;
  final List<OrderItem> items;

  const Order({
    required this.id,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
    required this.orderType,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      status: OrderStatusParsing.fromString(json['status']),
      totalPrice: double.parse(json['total_price'].toString()),
      createdAt: DateTime.parse(json['created_at']),
      orderType: OrderType.values.firstWhere(
        (e) => e.name == json['order_type'],
      ),
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class OrderItem {
  final int id;
  final MenuItem menuItem;
  final int quantity;
  final double priceAtOrder;
  final String specialRequests;
  final double subtotal;

  const OrderItem({
    required this.id,
    required this.menuItem,
    required this.quantity,
    required this.priceAtOrder,
    required this.specialRequests,
    required this.subtotal,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      menuItem: MenuItem.fromJson(json['menu_item']),
      quantity: json['quantity'],
      priceAtOrder: double.parse(json['price_at_order'].toString()),
      specialRequests: json['special_requests'],
      subtotal: double.parse(json['subtotal'].toString()),
    );
  }
}

class MenuItem {
  final int id;
  final String name;
  final String description;
  final double price;
  final String image;
  final String imageUrl;
  final bool isAvailable;
  final bool isPopular;
  final String categoryName;

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.imageUrl,
    required this.isAvailable,
    required this.isPopular,
    required this.categoryName,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      price: double.parse(json['price'].toString()),
      image: json['image'] ?? '',
      imageUrl: json['image_url'],
      isAvailable: json['is_available'],
      isPopular: json['is_popular'],
      categoryName: json['category_name'],
    );
  }
}

class Feedback {
  final int id;
  final String feedbackType;
  final int rating;
  final String message;
  final Order order;
  final OrderSession orderSession;
  final bool isRead;
  final DateTime createdAt;

  const Feedback({
    required this.id,
    required this.feedbackType,
    required this.rating,
    required this.message,
    required this.order,
    required this.orderSession,
    required this.isRead,
    required this.createdAt,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) {
    return Feedback(
      id: json['id'],
      feedbackType: json['feedback_type'],
      rating: json['rating'],
      message: json['message'],
      order: Order.fromJson(json['order']),
      orderSession: OrderSession.fromJson(json['order_session']),
      isRead: json['is_read'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class CartItem {
  final MenuItem menuItem;
  final int quantity;
  final String specialRequests;

  const CartItem({
    required this.menuItem,
    required this.quantity,
    required this.specialRequests,
  });

  CartItem copyWith({
    MenuItem? menuItem,
    int? quantity,
    String? specialRequests,
  }) {
    return CartItem(
      menuItem: menuItem ?? this.menuItem,
      quantity: quantity ?? this.quantity,
      specialRequests: specialRequests ?? this.specialRequests,
    );
  }

  double get subtotal => menuItem.price * quantity;
}
