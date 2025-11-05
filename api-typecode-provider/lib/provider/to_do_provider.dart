import 'package:flutter/material.dart';
import '../model/to_do_item.dart';
import '../services/to_do_service.dart';

class ToDoProvider with ChangeNotifier {
  final ToDoService _toDoService = ToDoService();

  List<ToDoItem> _toDoItems = [];
  bool _isLoading = false;
  bool _isCreating = false;
  String? _error;
  String _initialMessage = "Tekan tombol untuk memuat daftar To-Do dari API. (Simulasi 10 item)";

  // Getters
  List<ToDoItem> get toDoItems => _toDoItems;
  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  String? get error => _error;
  String get initialMessage => _initialMessage;

  // Fetch To-Do dari API
  Future<void> fetchActivity() async {
    _isLoading = true;
    _error = null;
    _toDoItems = [];
    _initialMessage = "Sedang memuat daftar To-Do... Tunggu sebentar!";
    notifyListeners();

    try {
      final fetchedList = await _toDoService.fetchToDoList();
      _toDoItems = fetchedList.take(10).toList(); // batasi 10 item (simulasi)
      _initialMessage = "Tekan tombol untuk memuat daftar To-Do dari API.";
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _initialMessage = 'Gagal memuat data.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Buat To-Do baru (POST)
  Future<void> submitNewToDo({
    required String title,
    required BuildContext context,
  }) async {
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul tidak boleh kosong!'), backgroundColor: Colors.orange),
      );
      return;
    }

    _isCreating = true;
    _error = null;
    notifyListeners();

    try {
      final newItem = await _toDoService.createToDoItem(
        title: title,
        userId: 1,
        completed: false,
      );
      _toDoItems.insert(0, newItem);
      _initialMessage = "Tekan tombol untuk memuat daftar To-Do dari API.";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sukses! To-Do "${newItem.title}" ditambahkan.'),
          backgroundColor: Colors.green.shade700,
        ),
      );
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }
}
