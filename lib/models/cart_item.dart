import 'recipe.dart';

class CartItem {
  final int id;
  final Recipe recipe;
  final int quantity;

  CartItem({
    required this.id,
    required this.recipe,
    required this.quantity,
  });
  
  // Get total price for this cart item
  double get totalPrice {
    return recipe.priceValue * quantity;
  }
  
  // Copy with new values
  CartItem copyWith({
    int? id,
    Recipe? recipe,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      recipe: recipe ?? this.recipe,
      quantity: quantity ?? this.quantity,
    );
  }
}