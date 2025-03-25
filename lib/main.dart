import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/builder_screen.dart';
import 'screens/recipes_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/orders_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: MaterialApp(
        title: 'Fast Food Builder',
        theme: AppTheme.themeData,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/menu': (context) => const MenuScreen(),
          '/builder': (context) => const BuilderScreen(),
          '/recipes': (context) => const RecipesScreen(),
          '/cart': (context) => const CartScreen(),
          '/orders': (context) => const OrdersScreen(),
        },
      ),
    );
  }
}
