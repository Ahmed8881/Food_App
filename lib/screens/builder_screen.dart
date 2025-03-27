import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/ingredient.dart';
import '../models/recipe.dart';
import '../widgets/app_drawer.dart';
import '../widgets/ingredient_card.dart';
import '../widgets/category_tabs.dart';
import '../widgets/save_recipe_modal.dart';
import '../theme/app_theme.dart';

class BuilderScreen extends StatefulWidget {
  const BuilderScreen({super.key});

  @override
  State<BuilderScreen> createState() => _BuilderScreenState();
}

class _BuilderScreenState extends State<BuilderScreen> {
  String _activeTab = 'all';
  final List<Ingredient> _selectedIngredients = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Build Your Recipe')),
      drawer: AppDrawer(
        currentRoute: '/builder',
        onNavigate: (route) {
          Navigator.pop(context); // Close drawer
          if (route != '/builder') {
            Navigator.pushNamed(context, route);
          }
        },
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          // Category tabs
          CategoryTabs<String>(
            tabs: [
              CategoryTab(id: 'all', label: 'All'),
              CategoryTab(id: 'base', label: 'Base'),
              CategoryTab(id: 'protein', label: 'Protein'),
              CategoryTab(id: 'veggie', label: 'Veggies'),
              CategoryTab(id: 'sauce', label: 'Sauces'),
              CategoryTab(id: 'topping', label: 'Toppings'),
            ],
            activeTab: _activeTab,
            onTabChanged: (tab) {
              setState(() {
                _activeTab = tab;
              });
            },
          ),

          const SizedBox(height: 16),

          // Selected ingredients summary
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Selected: ${_selectedIngredients.length}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (_selectedIngredients.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedIngredients.clear();
                                });
                              },
                              child: Text(
                                'Clear All',
                                style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getSelectedIngredientsText(),
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$${_calculateTotalPrice().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Ingredients grid
          Expanded(
            child: Consumer<AppProvider>(
              builder: (context, appProvider, child) {
                final ingredients = appProvider.getIngredientsByCategory(
                  _activeTab,
                );

                if (ingredients.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.no_food, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No ingredients in this category',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: ingredients.length,
                  itemBuilder: (context, index) {
                    final ingredient = ingredients[index];
                    final isSelected = _selectedIngredients.contains(
                      ingredient,
                    );

                    return IngredientCard(
                      ingredient: ingredient,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedIngredients.remove(ingredient);
                          } else {
                            _selectedIngredients.add(ingredient);
                          }
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _selectedIngredients.isEmpty ? null : _saveRecipe,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                foregroundColor: AppTheme.primaryColor,
                disabledBackgroundColor: Colors.grey[100],
                disabledForegroundColor: Colors.grey[400],
              ),
              child: const Text('Save Recipe'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _selectedIngredients.isEmpty ? null : _addToCart,
              child: const Text('Add to Cart'),
            ),
          ),
        ],
      ),
    );
  }

  String _getSelectedIngredientsText() {
    if (_selectedIngredients.isEmpty) {
      return 'No ingredients selected';
    }
    return _selectedIngredients.map((e) => e.name).join(', ');
  }

  double _calculateTotalPrice() {
    return _selectedIngredients.fold(0.0, (sum, item) => sum + item.priceValue);
  }

  void _saveRecipe() {
    if (_selectedIngredients.isEmpty) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SaveRecipeModal(
            selectedIngredients: List.from(_selectedIngredients),
            totalPrice: _calculateTotalPrice(),
            onSave: (name, description) {
              final appProvider = Provider.of<AppProvider>(
                context,
                listen: false,
              );
              final recipe = appProvider.saveCustomRecipe(
                name,
                List.from(_selectedIngredients),
                description,
              );

              if (recipe != null) {
                setState(() {
                  _selectedIngredients.clear();
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Recipe "$name" saved successfully'),
                    action: SnackBarAction(
                      label: 'View',
                      onPressed: () {
                        Navigator.pushNamed(context, '/recipes');
                      },
                    ),
                  ),
                );
              }
            },
            onClose: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  void _addToCart() {
    if (_selectedIngredients.isEmpty) return;

    final appProvider = Provider.of<AppProvider>(context, listen: false);

    // Create a temporary recipe for the cart
    final totalPrice = _calculateTotalPrice();
    final recipe = Recipe(
      id: DateTime.now().millisecondsSinceEpoch,
      name: 'Custom Recipe',
      price: '\$${totalPrice.toStringAsFixed(2)}',
      imageUrl:
          'https://images.unsplash.com/photo-1596662951482-0c4ba74a6df6?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&h=300&q=80',
      ingredients: List.from(_selectedIngredients),
      isCustom: true,
      description:
          'Custom recipe with ${_selectedIngredients.length} ingredients',
    );

    appProvider.addToCart(recipe);

    setState(() {
      _selectedIngredients.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Custom recipe added to cart'),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () {
            Navigator.pushNamed(context, '/cart');
          },
        ),
      ),
    );
  }
}
