import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/client_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common/empty_state_widget.dart';

class ClientListScreen extends StatelessWidget {
  const ClientListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final clientProvider = Provider.of<ClientProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Clients'),
      ),
      body: clientProvider.clients.isEmpty
          ? EmptyStateWidget.noClients(
              onButtonPressed: () => Navigator.pushNamed(context, AppRoutes.addClient),
            )
          : ListView.builder(
              itemCount: clientProvider.clients.length,
              itemBuilder: (context, index) {
                final client = clientProvider.clients[index];
                return ListTile(
                  title: Text(client.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(client.phone ?? client.email ?? 'No contact'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => clientProvider.deleteClient(client.id!),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addClient),
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
