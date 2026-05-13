import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lacarte_dashboard/ui/dashboard_ft/view_models/menu_view_model.dart';
import 'package:lacarte_dashboard/data/service/api_client.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';

class MenuAtelier extends StatefulWidget {
  const MenuAtelier({super.key});

  @override
  State<MenuAtelier> createState() => _MenuAtelierState();
}

class _MenuAtelierState extends State<MenuAtelier> {
  String _selectedTab = 'All Items';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MenuViewModel>().fetchAllData();
    });
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(symbol: '\$').format(amount);
  }



  @override
  Widget build(BuildContext context) {
    return Consumer<MenuViewModel>(
      builder: (context, menuVM, child) {
        if (menuVM.status == MenuStatus.loading && menuVM.menuItems.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF728A7C)),
          );
        }

        final categories = menuVM.categories;

        return Padding(
          padding: const EdgeInsets.only(
            top: 32.0,
            right: 32.0,
            bottom: 32.0,
            left: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Menu Atelier',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E231F),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Manage your digital catalog, availability, and pricing.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 250,
                        height: 40,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search orders, items...',
                            hintStyle: const TextStyle(fontSize: 13),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.notifications_none,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/150?img=11',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Categories & Action Bar
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildTab(
                              'All Items',
                              isActive: _selectedTab == 'All Items',
                            ),
                            ...categories.map(
                              (c) => _buildTab(
                                c.name,
                                isActive: _selectedTab == c.name,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => showDialog(
                            context: context,
                            builder: (_) => CategoryDialog(menuVM: menuVM),
                          ),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text(
                            'New Category',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF1E231F),
                            elevation: 0,
                            side: BorderSide(color: Colors.grey.shade300),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () => showDialog(
                            context: context,
                            builder: (_) => MenuItemDialog(menuVM: menuVM),
                          ),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text(
                            'New Item',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF728A7C), // Sage green
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Menu Grid
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    // Quick Actions Section
                    if (_selectedTab == 'All Items') ...[
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            'Quick Actions',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E231F),
                            ),
                          ),
                        ),
                      ),
                      SliverGrid.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 24,
                        childAspectRatio: 0.85,
                        children: [
                          _buildActionCard(
                            icon: Icons.add_photo_alternate_outlined,
                            title: 'Upload Food Photography',
                            subtitle:
                                'Drag and drop new images here to quickly create menu items.',
                            btnText: 'Browse Files',
                            isDashed: false,
                            bgColor: const Color(0xFFF4F2EE),
                            onPressed: () => showDialog(
                              context: context,
                              builder: (_) => MenuItemDialog(menuVM: menuVM),
                            ),
                          ),
                          _buildActionCard(
                            icon: Icons.add,
                            title: 'Manual Entry',
                            subtitle:
                                'Create an item without a photo to start.',
                            btnText: 'Add Details',
                            isDashed: true,
                            bgColor: Colors.transparent,
                            onPressed: () => showDialog(
                              context: context,
                              builder: (_) => MenuItemDialog(menuVM: menuVM),
                            ),
                          ),
                        ],
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 32)),
                    ],

                    // Group by categories
                    if (_selectedTab == 'All Items' && categories.isNotEmpty) ...[
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 16.0, top: 8.0),
                          child: Text(
                            'Categories',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E231F),
                            ),
                          ),
                        ),
                      ),
                      SliverGrid.count(
                        crossAxisCount: 4,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.5,
                        children: categories.map((c) => _buildCategoryCard(menuVM, c)).toList(),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 32)),
                    ],

                    ..._buildCategorySections(menuVM, categories),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildCategorySections(
    MenuViewModel menuVM,
    List<CategoryResponse> categories,
  ) {
    List<Widget> slivers = [];

    // Determine which categories to show
    final categoriesToShow = _selectedTab == 'All Items'
        ? categories
        : categories.where((c) => c.name == _selectedTab).toList();

    for (var category in categoriesToShow) {
      final itemsInCategory = menuVM.menuItems
          .where((item) => item.category == category.id)
          .toList();

      if (itemsInCategory.isEmpty && _selectedTab == 'All Items') {
        // Skip empty categories in All Items view
        continue;
      }

      // Add Category Header (or Category Card if only this category is selected)
      if (_selectedTab == 'All Items') {
        slivers.add(
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
              child: Text(
                category.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E231F),
                ),
              ),
            ),
          ),
        );
      } else {
        // When a single category tab is selected, show its category card at the top
        slivers.add(
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0, top: 8.0),
              child: SizedBox(
                width: 300,
                child: _buildCategoryCard(menuVM, category),
              ),
            ),
          ),
        );
      }

      if (itemsInCategory.isEmpty) {
        slivers.add(
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: 24.0),
              child: Text(
                'No items in this category yet.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        );
        continue;
      }

      // Add Grid for this category
      slivers.add(
        SliverGrid.count(
          crossAxisCount: 3,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: 0.85,
          children: itemsInCategory.map((item) {
            return _buildItemCard(
              id: item.id,
              title: item.name,
              price: _formatCurrency(item.price),
              description: item.description,
              tag: category.name,
              isAvailable: item.isAvailable,
              imageUrl: item.image,
              onToggleAvailability: () {
                menuVM.updateMenuItem(
                  item.id,
                  MenuItemRequest(
                    name: item.name,
                    description: item.description,
                    price: item.price,
                    category: item.category,
                    isAvailable: !item.isAvailable,
                  ),
                );
              },
              onEdit: () {
                showDialog(
                  context: context,
                  builder: (_) =>
                      MenuItemDialog(menuVM: menuVM, itemToEdit: item),
                );
              },
            );
          }).toList(),
        ),
      );

      slivers.add(const SliverToBoxAdapter(child: SizedBox(height: 32)));
    }

    return slivers;
  }

  Widget _buildCategoryCard(MenuViewModel menuVM, CategoryResponse category) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  category.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => CategoryDialog(
                      menuVM: menuVM,
                      categoryToEdit: category,
                    ),
                  );
                },
                child: Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              category.description,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, {bool isActive = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = title;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1E231F) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey.shade600,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String btnText,
    required bool isDashed,
    required Color bgColor,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDashed ? Colors.grey.shade300 : Colors.transparent,
          width: isDashed ? 2 : 0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.grey.shade600, size: 28),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: Text(
                btnText,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard({
    required int id,
    required String title,
    required String price,
    required String description,
    required String tag,
    required bool isAvailable,
    required String imageUrl,
    required VoidCallback onToggleAvailability,
    required VoidCallback onEdit,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isAvailable
                      ? const Color(0xFF00C853)
                      : Colors.grey.shade400,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isAvailable ? 'Available' : 'Sold Out',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isAvailable ? Colors.black87 : Colors.grey.shade500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Image
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageUrl.startsWith('http')
                    ? imageUrl
                    : 'http://localhost:8000$imageUrl', // Fallback for relative URLs
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: double.infinity,
                  color: Colors.grey.shade100,
                  child: const Center(
                    child: Icon(
                      Icons.fastfood_outlined,
                      color: Colors.grey,
                      size: 48,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Title & Price
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F2EE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  price,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Description
          Text(
            description,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 13,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 24),
          // Bottom Row (Tag & Actions)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2EFE9), // Sage light
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    color: Color(0xFF728A7C),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: onToggleAvailability,
                    child: Icon(
                      isAvailable
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 18,
                      color: isAvailable
                          ? Colors.grey.shade600
                          : Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: onEdit,
                    child: Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MenuItemDialog extends StatefulWidget {
  final MenuViewModel menuVM;
  final MenuItemResponse? itemToEdit;

  const MenuItemDialog({super.key, required this.menuVM, this.itemToEdit});

  @override
  State<MenuItemDialog> createState() => _MenuItemDialogState();
}

class _MenuItemDialogState extends State<MenuItemDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _description;
  late double _price;
  int? _selectedCategoryId;
  PlatformFile? _selectedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.itemToEdit != null) {
      _name = widget.itemToEdit!.name;
      _description = widget.itemToEdit!.description;
      _price = widget.itemToEdit!.price;
      _selectedCategoryId = widget.itemToEdit!.category;
    } else {
      _name = '';
      _description = '';
      _price = 0.0;
      if (widget.menuVM.categories.isNotEmpty) {
        _selectedCategoryId = widget.menuVM.categories.first.id;
      }
    }
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null) {
      setState(() {
        _selectedImage = result.files.first;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (widget.itemToEdit == null && _selectedImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select an image')));
      return;
    }
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.itemToEdit == null) {
        // Create
        final multipartFile = MultipartFile.fromBytes(
          _selectedImage!.bytes!,
          filename: _selectedImage!.name,
        );
        await widget.menuVM.createMenuItem(
          name: _name,
          description: _description,
          price: _price,
          category: _selectedCategoryId!,
          image: multipartFile,
        );
      } else {
        // Update
        await widget.menuVM.updateMenuItem(
          widget.itemToEdit!.id,
          MenuItemRequest(
            name: _name,
            description: _description,
            price: _price,
            category: _selectedCategoryId!,
            isAvailable: widget.itemToEdit!.isAvailable,
          ),
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
        if (widget.menuVM.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(widget.menuVM.errorMessage!)));
          widget.menuVM.clearError();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.itemToEdit == null
                    ? 'Menu item created'
                    : 'Menu item updated',
              ),
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _confirmDelete() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this menu item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      await widget.menuVM.deleteMenuItem(widget.itemToEdit!.id);
      if (mounted) {
        Navigator.of(context).pop();
        if (widget.menuVM.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(widget.menuVM.errorMessage!)));
          widget.menuVM.clearError();
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Menu item deleted')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.itemToEdit == null ? 'New Menu Item' : 'Edit Menu Item',
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
                onSaved: (val) => _name = val!,
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
                onSaved: (val) => _description = val!,
                maxLines: 3,
              ),
              TextFormField(
                initialValue: _price > 0 ? _price.toString() : '',
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Required';
                  if (double.tryParse(val) == null) return 'Invalid number';
                  return null;
                },
                onSaved: (val) => _price = double.parse(val!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _selectedCategoryId,
                decoration: const InputDecoration(labelText: 'Category'),
                items: widget.menuVM.categories.map((c) {
                  return DropdownMenuItem(value: c.id, child: Text(c.name));
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedCategoryId = val;
                  });
                },
                validator: (val) => val == null ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              if (widget.itemToEdit == null) ...[
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedImage == null
                            ? 'No image selected'
                            : _selectedImage!.name,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Pick Image'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        if (widget.itemToEdit != null)
          TextButton(
            onPressed: _isLoading ? null : _confirmDelete,
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}

class CategoryDialog extends StatefulWidget {
  final MenuViewModel menuVM;
  final CategoryResponse? categoryToEdit;

  const CategoryDialog({super.key, required this.menuVM, this.categoryToEdit});

  @override
  State<CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _description;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.categoryToEdit != null) {
      _name = widget.categoryToEdit!.name;
      _description = widget.categoryToEdit!.description;
    } else {
      _name = '';
      _description = '';
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.categoryToEdit == null) {
        await widget.menuVM.createCategory(
          CategoryRequest(name: _name, description: _description),
        );
      } else {
        await widget.menuVM.updateCategory(
          widget.categoryToEdit!.id,
          CategoryRequest(name: _name, description: _description),
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
        if (widget.menuVM.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(widget.menuVM.errorMessage!)),
          );
          widget.menuVM.clearError();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.categoryToEdit == null
                    ? 'Category created'
                    : 'Category updated',
              ),
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _confirmDelete() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this category?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      await widget.menuVM.deleteCategory(widget.categoryToEdit!.id);
      if (mounted) {
        Navigator.of(context).pop();
        if (widget.menuVM.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(widget.menuVM.errorMessage!)),
          );
          widget.menuVM.clearError();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Category deleted')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.categoryToEdit == null ? 'New Category' : 'Edit Category',
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
                onSaved: (val) => _name = val!,
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
                onSaved: (val) => _description = val!,
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (widget.categoryToEdit != null)
          TextButton(
            onPressed: _isLoading ? null : _confirmDelete,
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}
