import 'package:intl/intl.dart';
import 'recipe.dart';

class OrderItem {
  final Recipe recipe;
  final int quantity;

  OrderItem({
    required this.recipe,
    required this.quantity,
  });
}

class Order {
  final int id;
  final String orderNumber;
  final String totalAmount;
  final String status;
  final DateTime createdAt;
  final List<OrderItem> items;
  final String? address;
  final String? phone;
  final String? paymentMethod;

  Order({
    required this.id,
    required this.orderNumber,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.items,
    this.address,
    this.phone,
    this.paymentMethod,
  });
  
  // Format date nicely
  String get formattedDate {
    return DateFormat('MMM dd, yyyy • h:mm a').format(createdAt);
  }
}