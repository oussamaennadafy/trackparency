import 'package:expense_tracker/theme/colors.dart';
import 'package:flutter/material.dart';

// New bottom sheet modal for adding custom categories
class AddCategoryModal extends StatefulWidget {
  final Function(String name, String icon) onAdd;

  const AddCategoryModal({
    super.key,
    required this.onAdd,
  });

  // Static method to show the modal
  static void show(BuildContext context, Function(String name, String icon) onAdd) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddCategoryModal(onAdd: onAdd),
      ),
    );
  }

  @override
  State<AddCategoryModal> createState() => _AddCategoryModalState();
}

class _AddCategoryModalState extends State<AddCategoryModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedIcon = 'shopping_bag';

  // Predefined list of available icons
  final List<Map<String, dynamic>> _availableIcons = [
    {
      'name': 'shopping_bag',
      'icon': Icons.shopping_bag
    },
    {
      'name': 'restaurant',
      'icon': Icons.restaurant
    },
    {
      'name': 'directions_car',
      'icon': Icons.directions_car
    },
    {
      'name': 'home',
      'icon': Icons.home
    },
    {
      'name': 'sports_basketball',
      'icon': Icons.sports_basketball
    },
    {
      'name': 'flight',
      'icon': Icons.flight
    },
    {
      'name': 'school',
      'icon': Icons.school
    },
    {
      'name': 'health_and_safety',
      'icon': Icons.health_and_safety
    },
    {
      'name': 'receipt_long',
      'icon': Icons.receipt_long
    },
    {
      'name': 'checkroom',
      'icon': Icons.checkroom
    },
    {
      'name': 'movie',
      'icon': Icons.movie
    },
    {
      'name': 'pets',
      'icon': Icons.pets
    },
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.onAdd(_nameController.text.trim(), _selectedIcon);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Modal header with close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add Custom Category',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Category name input
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Category Name',
                hintText: 'Enter category name',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: AppColors.extraLightGray,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a category name';
                }
                if (value.trim().length < 3) {
                  return 'Category name must be at least 3 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            // Icon selection section
            const Text(
              'Select Icon',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Scrollable icon grid
            SizedBox(
              height: 120,
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemCount: _availableIcons.length,
                itemBuilder: (context, index) {
                  final iconData = _availableIcons[index];
                  final isSelected = _selectedIcon == iconData['name'];

                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIcon = iconData['name'];
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.extraLightGray,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.extraLightGray,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        iconData['icon'],
                        color: isSelected ? AppColors.surface : AppColors.gray,
                        size: 28,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            // Submit button
            ElevatedButton(
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.surface,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Add Category',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
