import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/recipe_card.dart';
import '../theme/app_theme.dart';

class RecipesScreen extends StatelessWidget {
  const RecipesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Recipes')),
      drawer: AppDrawer(
        currentRoute: '/recipes',
        onNavigate: (route) {
          Navigator.pop(context); // Close drawer
          if (route != '/recipes') {
            Navigator.pushNamed(context, route);
          }
        },
      ),
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          final customRecipes = appProvider.customRecipes;

          if (customRecipes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No saved recipes yet',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your own custom recipes in the Builder',
                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/builder');
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Create New Recipe'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: customRecipes.length,
            itemBuilder: (context, index) {
              final recipe = customRecipes[index];

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/builder');
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
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
