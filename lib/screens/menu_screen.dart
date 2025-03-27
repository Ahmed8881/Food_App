import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/recipe_card.dart';
import '../widgets/category_tabs.dart';
import '../theme/app_theme.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String _activeTab = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu')),
      drawer: AppDrawer(
        currentRoute: '/menu',
        onNavigate: (route) {
          Navigator.pop(context); // Close drawer
          if (route != '/menu') {
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
              CategoryTab(id: 'all', label: 'All Items'),
              CategoryTab(id: 'burger', label: 'Burgers'),
              CategoryTab(id: 'sandwich', label: 'Sandwiches'),
              CategoryTab(id: 'side', label: 'Sides'),
              CategoryTab(id: 'drink', label: 'Drinks'),
            ],
            activeTab: _activeTab,
            onTabChanged: (tab) {
              setState(() {
                _activeTab = tab;
              });
            },
          ),

          const SizedBox(height: 16),

          // Recipes list
          Expanded(
            child: Consumer<AppProvider>(
              builder: (context, appProvider, child) {
                final recipes = appProvider.menuItems;
                final filteredRecipes = _filterRecipesByCategory(
                  recipes,
                  _activeTab,
                );

                if (filteredRecipes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.no_food, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No items in this category',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = filteredRecipes[index];

                    return RecipeCard(
                      recipe: recipe,
                      onTap: () {
                        _showRecipeDetails(context, recipe);
                      },
                      onAddToCart: () {
                        appProvider.addToCart(recipe);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${recipe.name} added to cart'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<dynamic> _filterRecipesByCategory(
    List<dynamic> recipes,
    String category,
  ) {
    if (category == 'all') {
      return recipes;
    }

    // Simple category detection based on name
    return recipes.where((recipe) {
      final name = recipe.name.toLowerCase();

      switch (category) {
        case 'burger':
          return name.contains('burger');
        case 'sandwich':
          return name.contains('sandwich');
        case 'side':
          return name.contains('fries') || name.contains('side');
        case 'drink':
          return name.contains('drink') ||
              name.contains('soda') ||
              name.contains('beverage');
        default:
          return true;
      }
    }).toList();
  }

  void _showRecipeDetails(BuildContext context, dynamic recipe) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipe image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  recipe.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 16),

              // Recipe name and price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      recipe.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    recipe.price,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Recipe description
              if (recipe.description != null && recipe.description.isNotEmpty)
                Text(
                  recipe.description,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),

              const SizedBox(height: 20),

              // Ingredients list
              if (recipe.ingredients.isNotEmpty) ...[
                const Text(
                  'Ingredients',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ...recipe.ingredients
                    .map<Widget>(
                      (ingredient) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 8,
                              color: AppTheme.primaryColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              ingredient.name,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Spacer(),
                            Text(
                              ingredient.price,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ],

              const SizedBox(height: 30),

              // Add to cart button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final appProvider = Provider.of<AppProvider>(
                      context,
                      listen: false,
                    );
                    appProvider.addToCart(recipe);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${recipe.name} added to cart'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
