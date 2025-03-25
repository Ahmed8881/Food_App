import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;
  final Function(String) onNavigate;

  const AppDrawer({
    Key? key,
    required this.currentRoute,
    required this.onNavigate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer header
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.fastfood,
                    size: 40,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Fast Food Builder',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          
          // Drawer items
          _buildDrawerItem(
            icon: Icons.home,
            title: 'Home',
            route: '/',
          ),
          _buildDrawerItem(
            icon: Icons.restaurant_menu,
            title: 'Menu',
            route: '/menu',
          ),
          _buildDrawerItem(
            icon: Icons.build,
            title: 'Build Your Own',
            route: '/builder',
          ),
          _buildDrawerItem(
            icon: Icons.bookmark,
            title: 'My Recipes',
            route: '/recipes',
          ),
          _buildDrawerItem(
            icon: Icons.shopping_cart,
            title: 'Cart',
            route: '/cart',
          ),
          _buildDrawerItem(
            icon: Icons.history,
            title: 'Order History',
            route: '/orders',
          ),
          
          const Spacer(),
          
          // App version at the bottom
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Version 1.0.0',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required String route,
  }) {
    final isActive = route == currentRoute;
    
    return ListTile(
      leading: Icon(
        icon,
        color: isActive ? AppTheme.primaryColor : Colors.grey[700],
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color: isActive ? AppTheme.primaryColor : Colors.black,
        ),
      ),
      onTap: () {
        onNavigate(route);
      },
      tileColor: isActive ? AppTheme.primaryColor.withAlpha(25) : null,
    );
  }
}