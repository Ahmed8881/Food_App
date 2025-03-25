import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_card.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      drawer: AppDrawer(
        currentRoute: '/orders',
        onNavigate: (route) {
          Navigator.pop(context); // Close drawer
          if (route != '/orders') {
            Navigator.pushNamed(context, route);
          }
        },
      ),
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          final orders = appProvider.orders;
          
          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No orders yet',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your order history will appear here',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/menu');
                    },
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Start Shopping'),
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
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              
              return OrderCard(
                order: order,
                onReorder: () {
                  appProvider.reorder(order);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Order #${order.orderNumber} added to cart'),
                      action: SnackBarAction(
                        label: 'View Cart',
                        onPressed: () {
                          Navigator.pushNamed(context, '/cart');
                        },
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}