import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/to_do_provider.dart';
import '../widget/to_do_list_item_widget.dart';

class ActivityFetcher extends StatelessWidget {
  const ActivityFetcher({super.key});

  Future<void> _showCreateDialog(BuildContext context) async {
    final provider = Provider.of<ToDoProvider>(context, listen: false);
    final TextEditingController titleController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: !provider.isCreating,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Buat To-Do Baru'),
              content: provider.isCreating
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text("Menyimpan..."),
                          ],
                        ),
                      ),
                    )
                  : TextField(
                      controller: titleController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Contoh: Belajar Flutter Provider',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (value) {
                        Navigator.of(context).pop();
                        provider.submitNewToDo(title: titleController.text.trim(), context: context);
                      },
                    ),
              actions: <Widget>[
                TextButton(
                  onPressed: provider.isCreating ? null : () => Navigator.of(context).pop(),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: provider.isCreating
                      ? null
                      : () {
                          Navigator.of(context).pop();
                          provider.submitNewToDo(title: titleController.text.trim(), context: context);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(provider.isCreating ? 'Menyimpan...' : 'Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ToDoProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('My Todo List', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.indigo,
            elevation: 4,
            actions: [
              IconButton(
                icon: const Icon(Icons.add_task, color: Colors.white),
                tooltip: 'Buat To-Do Baru',
                onPressed: (provider.isLoading || provider.isCreating)
                    ? null
                    : () => _showCreateDialog(context),
              ),
            ],
          ),
          body: _buildContent(provider),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: (provider.isLoading || provider.isCreating)
                ? null
                : () => provider.fetchActivity(),
            icon: const Icon(Icons.download),
            label: Text(
              provider.isLoading
                  ? 'Sedang Memuat...'
                  : (provider.isCreating ? 'Memproses...' : 'Muat Daftar To-Do'),
              style: const TextStyle(fontSize: 16),
            ),
            backgroundColor: (provider.isLoading || provider.isCreating)
                ? Colors.grey.shade600
                : Colors.indigo,
            foregroundColor: Colors.white,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          bottomNavigationBar: provider.toDoItems.isEmpty &&
                  provider.error == null &&
                  !provider.isLoading
              ? const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Catatan: Data diambil dari JSONPlaceholder dan disimulasikan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _buildContent(ToDoProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo)),
            SizedBox(height: 16),
            Text("Memuat data...", style: TextStyle(color: Colors.indigo)),
          ],
        ),
      );
    } else if (provider.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            provider.error!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      );
    } else if (provider.toDoItems.isNotEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: provider.toDoItems.length,
        itemBuilder: (context, index) {
          return ToDoListItemWidget(item: provider.toDoItems[index]);
        },
      );
    } else {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            provider.initialMessage,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
        ),
      );
    }
  }
}
