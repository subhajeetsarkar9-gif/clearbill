import 'package:flutter/material.dart';
import '../models/client_model.dart';
import '../database/client_dao.dart';

class ClientProvider extends ChangeNotifier {
  final ClientDAO _clientDAO = ClientDAO();
  List<ClientModel> _clients = [];
  bool _isLoading = false;

  List<ClientModel> get clients => _clients;
  bool get isLoading => _isLoading;

  Future<void> loadClients() async {
    _isLoading = true;
    notifyListeners();
    _clients = await _clientDAO.getAll();
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addClient(ClientModel client) async {
    await _clientDAO.insert(client);
    await loadClients();
    return true;
  }

  Future<bool> updateClient(ClientModel client) async {
    await _clientDAO.update(client);
    await loadClients();
    return true;
  }

  Future<bool> deleteClient(int id) async {
    await _clientDAO.delete(id);
    await loadClients();
    return true;
  }
}
