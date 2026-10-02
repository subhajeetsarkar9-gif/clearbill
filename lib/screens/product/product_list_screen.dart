import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common/empty_state_widget.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products & Services'),
      ),
      body: pProvider.products.isEmpty
          ? EmptyStateWidget.noProducts(
              onButtonPressed: () => Navigator.pushNamed(context, AppRoutes.addProduct),
            )
          : ListView.builder(
              itemCount: pProvider.products.length,
              itemBuilder: (context, index) {
                final p = pProvider.products[index];
                return ListTile(
                  title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('₹${p.price} per ${p.unit} | GST: ${p.gstPercent}%'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => pProvider.deleteProduct(p.id!),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addProduct),
        child: const Icon(Icons.add),
      ),
    );
  }
}
