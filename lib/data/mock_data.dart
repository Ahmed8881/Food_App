import '../models/ingredient.dart';
import '../models/recipe.dart';
import '../models/order.dart';

class MockData {
  // Singleton pattern
  MockData._privateConstructor();
  static final MockData _instance = MockData._privateConstructor();
  factory MockData() => _instance;

  // Ingredients
  List<Ingredient> getIngredients() {
    return [
      Ingredient(
        id: 1,
        name: 'Burger Bun',
        price: '\$1.50',
        category: 'base',
        imageUrl:
            'https://images.unsplash.com/photo-1550950158-d0d960dff51b?ixlib=rb-1.2.1&auto=format&fit=crop&w=120&h=120&q=80',
      ),
      Ingredient(
        id: 2,
        name: 'Whole Wheat Bun',
        price: '\$1.75',
        category: 'base',
        imageUrl:
            'https://images.unsplash.com/photo-1550950158-d0d960dff51b?ixlib=rb-1.2.1&auto=format&fit=crop&w=120&h=120&q=80',
      ),
      Ingredient(
        id: 3,
        name: 'Beef Patty',
        price: '\$3.00',
        category: 'protein',
        imageUrl:
            'https://images.unsplash.com/photo-1588315029754-2dd089d39a1a?ixlib=rb-1.2.1&auto=format&fit=crop&w=120&h=120&q=80',
      ),
      Ingredient(
        id: 4,
        name: 'Chicken Patty',
        price: '\$2.75',
        category: 'protein',
        imageUrl:
            'https://images.unsplash.com/photo-1588315029754-2dd089d39a1a?ixlib=rb-1.2.1&auto=format&fit=crop&w=120&h=120&q=80',
      ),
      Ingredient(
        id: 5,
        name: 'Veggie Patty',
        price: '\$2.50',
        category: 'protein',
        imageUrl:
            'https://images.unsplash.com/photo-1588315029754-2dd089d39a1a?ixlib=rb-1.2.1&auto=format&fit=crop&w=120&h=120&q=80',
      ),
      Ingredient(
        id: 6,
        name: 'Lettuce',
        price: '\$0.75',
        category: 'veggie',
        imageUrl:
            'https://images.unsplash.com/photo-1582284540020-8acbe03f4924?ixlib=rb-1.2.1&auto=format&fit=crop&w=120&h=120&q=80',
      ),
      Ingredient(
        id: 7,
        name: 'Tomato',
        price: '\$0.75',
        category: 'veggie',
        imageUrl:
            'https://images.unsplash.com/photo-1582284540020-8acbe03f4924?ixlib=rb-1.2.1&auto=format&fit=crop&w=120&h=120&q=80',
      ),
      Ingredient(
        id: 8,
        name: 'Onions',
        price: '\$0.50',
        category: 'veggie',
        imageUrl:
            'https://images.unsplash.com/photo-1582284540020-8acbe03f4924?ixlib=rb-1.2.1&auto=format&fit=crop&w=120&h=120&q=80',
      ),
      Ingredient(
        id: 9,
        name: 'Pickles',
        price: '\$0.50',
        category: 'veggie',
        imageUrl:
            'https://images.unsplash.com/photo-1582284540020-8acbe03f4924?ixlib=rb-1.2.1&auto=format&fit=crop&w=120&h=120&q=80',
      ),
      Ingredient(
        id: 10,
        name: 'Mayonnaise',
        price: '\$0.50',
        category: 'sauce',
        imageUrl:
            'https://images.unsplash.com/photo-1605620622858-8bc929fa5fb1?ixlib=rb-1.2.1&auto=format&fit=crop&w=120&h=120&q=80',
      ),
      Ingredient(
        id: 11,
        name: 'Ketchup',
        price: '\$0.50',
        category: 'sauce',
        imageUrl:
            'https://images.unsplash.com/photo-1605620622858-8bc929fa5fb1?ixlib=rb-1.2.1&auto=format&fit=crop&w=120&h=120&q=80',
      ),
      Ingredient(
        id: 12,
        name: 'Mustard',
        price: '\$0.50',
        category: 'sauce',
        imageUrl:
            'https://images.unsplash.com/photo-1605620622858-8bc929fa5fb1?ixlib=rb-1.2.1&auto=format&fit=crop&w=120&h=120&q=80',
      ),
      Ingredient(
        id: 13,
        name: 'BBQ Sauce',
        price: '\$0.75',
        category: 'sauce',
        imageUrl:
            'https://images.unsplash.com/photo-1605620622858-8bc929fa5fb1?ixlib=rb-1.2.1&auto=format&fit=crop&w=120&h=120&q=80',
      ),
      Ingredient(
        id: 14,
        name: 'Cheese',
        price: '\$1.00',
        category: 'topping',
        imageUrl:
            'https://images.unsplash.com/photo-1618414466256-4b62f39b5b30?ixlib=rb-1.2.1&auto=format&fit=crop&w=120&h=120&q=80',
      ),
      Ingredient(
        id: 15,
        name: 'Bacon',
        price: '\$1.50',
        category: 'topping',
        imageUrl:
            'https://images.unsplash.com/photo-1618414466256-4b62f39b5b30?ixlib=rb-1.2.1&auto=format&fit=crop&w=120&h=120&q=80',
      ),
      Ingredient(
        id: 16,
        name: 'Avocado',
        price: '\$1.25',
        category: 'topping',
        imageUrl:
            'https://images.unsplash.com/photo-1618414466256-4b62f39b5b30?ixlib=rb-1.2.1&auto=format&fit=crop&w=120&h=120&q=80',
      ),
    ];
  }

  // Get ingredients by category
  List<Ingredient> getIngredientsByCategory(String category) {
    if (category == 'all') {
      return getIngredients();
    }
    return getIngredients()
        .where((ingredient) => ingredient.category == category)
        .toList();
  }

  // Recipes
  List<Recipe> getRecipes() {
    final ingredients = getIngredients();

    return [
      Recipe(
        id: 1,
        name: 'Classic Burger',
        price: '\$8.99',
        imageUrl:
            'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&h=300&q=80',
        ingredients: [
          ingredients[0], // Burger Bun
          ingredients[2], // Beef Patty
          ingredients[5], // Lettuce
          ingredients[6], // Tomato
          ingredients[13], // Cheese
          ingredients[9], // Mayo
        ],
        isCustom: false,
        description:
            'Beef patty, lettuce, tomato, cheese, and our special sauce',
      ),
      Recipe(
        id: 2,
        name: 'Double Cheese',
        price: '\$10.99',
        imageUrl:
            'https://images.unsplash.com/photo-1565299507177-b0ac66763828?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&h=300&q=80',
        ingredients: [
          ingredients[0], // Burger Bun
          ingredients[2], // Beef Patty
          ingredients[2], // Beef Patty
          ingredients[13], // Cheese
          ingredients[13], // Cheese
          ingredients[8], // Pickles
          ingredients[7], // Onions
        ],
        isCustom: false,
        description:
            'Double beef patty with extra cheese, pickles, and grilled onions',
      ),
      Recipe(
        id: 3,
        name: 'Chicken Sandwich',
        price: '\$7.99',
        imageUrl:
            'https://images.unsplash.com/photo-1539252554935-80c8d6f3f7af?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&h=300&q=80',
        ingredients: [
          ingredients[1], // Whole Wheat Bun
          ingredients[3], // Chicken Patty
          ingredients[5], // Lettuce
          ingredients[15], // Bacon
          ingredients[14], // Cheese
          ingredients[11], // Mustard
        ],
        isCustom: false,
        description: 'Grilled chicken, bacon, cheese, and honey mustard',
      ),
      Recipe(
        id: 4,
        name: 'French Fries',
        price: '\$3.99',
        imageUrl:
            'https://images.unsplash.com/photo-1541592106381-b31e9677c0e5?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&h=300&q=80',
        ingredients: [],
        isCustom: false,
        description: 'Crispy golden fries with sea salt',
      ),
      Recipe(
        id: 5,
        name: 'Veggie Supreme',
        price: '\$9.75',
        imageUrl:
            'https://images.unsplash.com/photo-1585238342024-78d387f4a707?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&h=300&q=80',
        ingredients: [
          ingredients[1], // Whole Wheat Bun
          ingredients[4], // Veggie Patty
          ingredients[15], // Avocado
          ingredients[5], // Lettuce
          ingredients[6], // Tomato
          ingredients[9], // Mayo
        ],
        isCustom: true,
        description:
            'Whole wheat bun, veggie patty, avocado, alfalfa sprouts, tomato, spicy mayo',
      ),
      Recipe(
        id: 6,
        name: 'BBQ Burger',
        price: '\$9.50',
        imageUrl:
            'https://images.unsplash.com/photo-1572802419224-296b0aeee0d9?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&h=300&q=80',
        ingredients: [
          ingredients[0], // Burger Bun
          ingredients[2], // Beef Patty
          ingredients[7], // Onions
          ingredients[14], // Cheese
          ingredients[12], // BBQ Sauce
        ],
        isCustom: false,
        description:
            'Juicy beef patty with caramelized onions, melted cheese, and tangy BBQ sauce',
      ),
    ];
  }

  // Get custom recipes (initially contains one custom example)
  List<Recipe> getInitialCustomRecipes() {
    return [getRecipes()[4]]; // Veggie Supreme is marked as custom
  }

  // Get predefined orders
  List<Order> getInitialOrders() {
    final recipes = getRecipes();

    return [
      Order(
        id: 1,
        orderNumber: '1042',
        totalAmount: '\$18.95',
        status: 'Completed',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        items: [
          OrderItem(recipe: recipes[0], quantity: 1),
          OrderItem(recipe: recipes[3], quantity: 2),
        ],
        address: '123 Main St, Anytown',
        phone: '555-123-4567',
        paymentMethod: 'Cash on Delivery',
      ),
      Order(
        id: 2,
        orderNumber: '1036',
        totalAmount: '\$24.50',
        status: 'Completed',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        items: [
          OrderItem(recipe: recipes[1], quantity: 1),
          OrderItem(recipe: recipes[2], quantity: 1),
          OrderItem(recipe: recipes[3], quantity: 1),
        ],
        address: '456 Oak Ave, Somewhere',
        phone: '555-987-6543',
        paymentMethod: 'Card',
      ),
    ];
  }
}
 