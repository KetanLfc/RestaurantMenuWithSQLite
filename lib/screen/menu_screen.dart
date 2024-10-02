import 'package:flutter/material.dart';
import '../model/menu_item.dart';
import '../repository/menu_repository.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final MenuRepository repository = MenuRepository();
  List<MenuItem> menuItems = [];

  @override
  void initState() {
    super.initState();
    fetchMenuItems();
  }

  Future<void> fetchMenuItems() async {
    final result = await repository.fetchMenuItems();
    setState(() {
      menuItems = result;
    });
  }

  Future<void> insertMenuItem(String name, String description, double price) async {
    final menuItem = MenuItem(name: name, description: description, price: price);
    await repository.insertMenuItem(menuItem);
    fetchMenuItems();
  }

  Future<void> updateMenuItem(int id, String name, String description, double price) async {
    final menuItem = MenuItem(id: id, name: name, description: description, price: price);
    await repository.updateMenuItem(menuItem);
    fetchMenuItems();
  }

  Future<void> deleteMenuItem(int id) async {
    await repository.deleteMenuItem(id);
    fetchMenuItems();
  }

  int? selectedMenuItemId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Menu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Adding the restaurant image at the top
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/menu.jpg'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    insertMenuItem(
                      nameController.text,
                      descriptionController.text,
                      double.parse(priceController.text),
                    );
                    clearFields();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Create'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedMenuItemId != null) {
                      updateMenuItem(
                        selectedMenuItemId!,
                        nameController.text,
                        descriptionController.text,
                        double.parse(priceController.text),
                      );
                      clearFields();
                      selectedMenuItemId = null;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: const Text('Update'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedMenuItemId != null) {
                      deleteMenuItem(selectedMenuItemId!);
                      clearFields();
                      selectedMenuItemId = null;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Delete'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final menuItem = menuItems[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        menuItem.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(menuItem.description),
                          const SizedBox(height: 4),
                          Text(
                            '\$${menuItem.price.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          selectedMenuItemId = menuItem.id;
                          nameController.text = menuItem.name;
                          descriptionController.text = menuItem.description;
                          priceController.text = menuItem.price.toString();
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void clearFields() {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
  }
}
