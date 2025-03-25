class Ingredient {
  final int id;
  final String name;
  final String price;
  final String category;
  final String imageUrl;

  Ingredient({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.imageUrl,
  });
  
  // Helper to get numerical price value
  double get priceValue {
    // Remove $ sign and convert to double
    return double.tryParse(price.replaceAll(r'$', '')) ?? 0.0;
  }
}