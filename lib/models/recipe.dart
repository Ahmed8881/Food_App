import 'ingredient.dart';

class Recipe {
  final int id;
  final String name;
  final String price;
  final String imageUrl;
  final List<Ingredient> ingredients;
  final bool isCustom;
  final String? description;

  Recipe({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.ingredients,
    required this.isCustom,
    this.description,
  });
  
  // Helper to get numerical price value
  double get priceValue {
    // Remove $ sign and convert to double
    return double.tryParse(price.replaceAll(r'$', '')) ?? 0.0;
  }
}