import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/ingredient.dart';
import '../models/recipe.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../data/mock_data.dart';

class AppProvider with ChangeNotifier {
  // Mock data source
  final MockData _mockData = MockData();
  
  // State variables
  List<CartItem> _cartItems = [];
  List<Recipe> _customRecipes = [];
  List<Order> _orders = [];
  List<Ingredient> _ingredients = [];
  List<Recipe> _menuItems = [];
  int _nextCartId = 1;
  int _nextRecipeId = 100; // Start from higher number to avoid conflicts
  int _nextOrderId = 1000;
  
  // Constructor - initialize data
  AppProvider() {
    _ingredients = _mockData.getIngredients();
    _menuItems = _mockData.getRecipes();
    _customRecipes = _mockData.getInitialCustomRecipes();
    _orders = _mockData.getInitialOrders();
    
    // Find the next available IDs based on existing data
    _nextCartId = 1;
    _nextRecipeId = _menuItems.fold(0, (prev, item) => item.id > prev ? item.id : prev) + 1;
    _nextOrderId = _orders.fold(0, (prev, item) => item.id > prev ? item.id : prev) + 1;
  }
  
  // Getters
  List<CartItem> get cartItems => _cartItems;
  List<Recipe> get customRecipes => _customRecipes;
  List<Order> get orders => _orders;
  List<Ingredient> get ingredients => _ingredients;
  List<Recipe> get menuItems => _menuItems;
  
  // Get ingredients by category
  List<Ingredient> getIngredientsByCategory(String category) {
    return _mockData.getIngredientsByCategory(category);
  }
  
  // Cart operations
  void addToCart(Recipe recipe) {
    // Check if item already exists in cart
    final existingIndex = _cartItems.indexWhere((item) => item.recipe.id == recipe.id);
    
    if (existingIndex >= 0) {
      // Increase quantity if item already in cart
      _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
        quantity: _cartItems[existingIndex].quantity + 1,
      );
    } else {
      // Add new item
      _cartItems.add(CartItem(
        id: _nextCartId++,
        recipe: recipe,
        quantity: 1,
      ));
    }
    
    notifyListeners();
  }
  
  void addMultipleToCart(Recipe recipe, int quantity) {
    if (quantity <= 0) return;
    
    // Check if item already exists in cart
    final existingIndex = _cartItems.indexWhere((item) => item.recipe.id == recipe.id);
    
    if (existingIndex >= 0) {
      // Increase quantity if item already in cart
      _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
        quantity: _cartItems[existingIndex].quantity + quantity,
      );
    } else {
      // Add new item
      _cartItems.add(CartItem(
        id: _nextCartId++,
        recipe: recipe,
        quantity: quantity,
      ));
    }
    
    notifyListeners();
  }
  
  void updateQuantity(int id, int quantity) {
    if (quantity <= 0) {
      removeFromCart(id);
      return;
    }
    
    final index = _cartItems.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _cartItems[index] = _cartItems[index].copyWith(quantity: quantity);
      notifyListeners();
    }
  }
  
  void removeFromCart(int id) {
    _cartItems.removeWhere((item) => item.id == id);
    notifyListeners();
  }
  
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
  
  double getCartTotal() {
    return _cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  }
  
  // Custom recipes operations  
  Recipe? saveCustomRecipe(String name, List<Ingredient> ingredients, String? description) {
    if (ingredients.isEmpty) return null;
    
    // Calculate total price
    final totalPrice = ingredients.fold(0.0, (sum, ingredient) => sum + ingredient.priceValue);
    final formattedPrice = '\$${totalPrice.toStringAsFixed(2)}';
    
    // Create recipe object
    final newRecipe = Recipe(
      id: _nextRecipeId++,
      name: name,
      price: formattedPrice,
      imageUrl: 'https://images.unsplash.com/photo-1596662951482-0c4ba74a6df6?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&h=300&q=80',
      ingredients: ingredients,
      isCustom: true,
      description: description,
    );
    
    _customRecipes.add(newRecipe);
    notifyListeners();
    return newRecipe;
  }
  
  // Orders operations
  Order? createOrder({
    required String address,
    required String phone,
    required String paymentMethod,
  }) {
    if (_cartItems.isEmpty) return null;
    
    // Generate order number
    final uuid = const Uuid();
    final orderNumber = uuid.v4().substring(0, 8).toUpperCase();
    
    // Calculate total amount
    final totalAmount = '\$${getCartTotal().toStringAsFixed(2)}';
    
    // Create order items from cart
    final orderItems = _cartItems.map((item) => OrderItem(
      recipe: item.recipe,
      quantity: item.quantity,
    )).toList();
    
    // Create new order
    final newOrder = Order(
      id: _nextOrderId++,
      orderNumber: orderNumber,
      totalAmount: totalAmount,
      status: 'Pending',
      createdAt: DateTime.now(),
      items: orderItems,
      address: address,
      phone: phone,
      paymentMethod: paymentMethod,
    );
    
    _orders.add(newOrder);
    clearCart(); // Clear cart after successful order
    notifyListeners();
    return newOrder;
  }
  
  // Helper method to reorder from previous order
  void reorder(Order order) {
    clearCart(); // Clear current cart first
    
    // Add all items from the order to cart
    for (var item in order.items) {
      addMultipleToCart(item.recipe, item.quantity);
    }
  }
}