import 'package:material_ui/material_ui.dart';
import 'package:lapak_jajanan/features/shared/widgets/admin_widgets.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final _searchController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _orderController = TextEditingController(text: '1');
  final List<_CategoryEntry> _categories = [
    _CategoryEntry(
      name: 'Makanan Berat',
      description: 'Menu utama dan hidangan mengenyangkan',
      itemCount: 2,
      order: 1,
    ),
    _CategoryEntry(
      name: 'Camilan',
      description: 'Jajanan dan makanan ringan',
      itemCount: 1,
      order: 2,
    ),
    _CategoryEntry(
      name: 'Minuman',
      description: 'Minuman segar dan hangat',
      itemCount: 2,
      order: 3,
    ),
  ];
  String? _editingName;
  bool _isActive = true;

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  List<_CategoryEntry> get _visibleCategories {
    final query = _searchController.text.trim().toLowerCase();
    final visible = _categories
        .where((category) => category.name.toLowerCase().contains(query))
        .toList();
    visible.sort((a, b) => a.order.compareTo(b.order));
    return visible;
  }

  @override
  Widget build(BuildContext context) {
    final linkedMenus = _categories.fold<int>(
      0,
      (total, category) => total + category.itemCount,
    );
    return ListView(
      padding: const EdgeInsets.all(22),
      children: [
        AdminPageTitle(
          eyebrow: 'Katalog resto & kasir',
          title: 'Pengelolaan Kategori Menu',
          description: 'Atur kelompok hidangan dan urutan tampilnya pada kasir POS serta menu pelanggan.',
          action: AdminStatusPill(
            label:
                '${_categories.where((category) => category.isActive).length} kategori aktif',
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            const spacing = 12.0;
            final columns = constraints.maxWidth >= 560 ? 2 : 1;
            final cardWidth =
                (constraints.maxWidth - spacing * (columns - 1)) / columns;
            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                AdminMetricCard(
                  width: cardWidth,
                  label: 'Total kategori',
                  value: '${_categories.length}',
                  detail: 'Grup menu',
                  icon: Icons.category_outlined,
                ),
                AdminMetricCard(
                  key: const Key('categories-metric-linked'),
                  width: cardWidth,
                  label: 'Menu terhubung',
                  value: '$linkedMenus',
                  detail: 'Hidangan',
                  icon: Icons.restaurant_menu_outlined,
                  tint: AdminColors.green,
                  background: AdminColors.greenSoft,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final categoryList = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  key: const Key('category-search'),
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Cari kategori menu...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
                if (_visibleCategories.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('Kategori tidak ditemukan.'),
                  )
                else
                  for (final category in _visibleCategories)
                    _CategoryRow(
                      category: category,
                      onEdit: () => _startEditing(category),
                      onDelete: () => _deleteCategory(category),
                      onToggle: (value) =>
                          setState(() => category.isActive = value),
                    ),
                const SizedBox(height: 10),
                const Text(
                  'Urutan kategori menentukan posisi tab pada tampilan Kasir POS dan menu pelanggan.',
                  style: TextStyle(color: AdminColors.muted, fontSize: 12),
                ),
              ],
            );
            final editor = _CategoryEditor(
              nameController: _nameController,
              descriptionController: _descriptionController,
              orderController: _orderController,
              isActive: _isActive,
              editingName: _editingName,
              onActiveChanged: (value) => setState(() => _isActive = value),
              onSave: _saveCategory,
              onReset: _resetForm,
            );

            if (constraints.maxWidth >= 1000) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: categoryList),
                  const SizedBox(width: 16),
                  Expanded(flex: 4, child: editor),
                ],
              );
            }
            return Column(
              children: [categoryList, const SizedBox(height: 16), editor],
            );
          },
        ),
        const SizedBox(height: 16),
        AdminSectionCard(
          title: 'Distribusi menu per kategori',
          subtitle: 'Sebaran item aktif pada katalog saat ini',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final category in _categories)
                SizedBox(
                  width: 210,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AdminColors.soft,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: linkedMenus == 0
                              ? 0
                              : category.itemCount / linkedMenus,
                          color: AdminColors.primary,
                          backgroundColor: AdminColors.border,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        const SizedBox(height: 7),
                        Text('${category.itemCount} hidangan terhubung'),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _startEditing(_CategoryEntry category) {
    setState(() {
      _editingName = category.name;
      _nameController.text = category.name;
      _descriptionController.text = category.description;
      _orderController.text = category.order.toString();
      _isActive = category.isActive;
    });
  }

  void _saveCategory() {
    final name = _nameController.text.trim();
    final order = int.tryParse(_orderController.text);
    if (name.isEmpty || order == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Isi nama kategori dan urutan yang valid.'),
        ),
      );
      return;
    }

    setState(() {
      final existing = _categories.cast<_CategoryEntry?>().firstWhere(
        (category) => category?.name == _editingName,
        orElse: () => null,
      );
      if (existing == null) {
        _categories.add(
          _CategoryEntry(
            name: name,
            description: _descriptionController.text.trim(),
            itemCount: 0,
            order: order,
            isActive: _isActive,
          ),
        );
      } else {
        existing
          ..name = name
          ..description = _descriptionController.text.trim()
          ..order = order
          ..isActive = _isActive;
      }
      _clearForm();
    });
  }

  Future<void> _deleteCategory(_CategoryEntry category) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus kategori?'),
        content: Text('Kategori "${category.name}" akan dihapus dari preview.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) {
      setState(() {
        _categories.remove(category);
        if (_editingName == category.name) _clearForm();
      });
    }
  }

  void _resetForm() => setState(_clearForm);

  void _clearForm() {
    _editingName = null;
    _nameController.clear();
    _descriptionController.clear();
    _orderController.text = '${_categories.length + 1}';
    _isActive = true;
  }
}

class _CategoryEditor extends StatelessWidget {
  const _CategoryEditor({
    required this.nameController,
    required this.descriptionController,
    required this.orderController,
    required this.isActive,
    required this.editingName,
    required this.onActiveChanged,
    required this.onSave,
    required this.onReset,
  });

  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController orderController;
  final bool isActive;
  final String? editingName;
  final ValueChanged<bool> onActiveChanged;
  final VoidCallback onSave;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return AdminSectionCard(
      title: editingName == null ? 'Tambah Kategori' : 'Edit Kategori',
      subtitle: 'Buat kelompok menu baru',
      child: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Nama kategori'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Deskripsi singkat'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: orderController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Urutan tampilan'),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Kategori aktif'),
            subtitle: const Text('Tampilkan di kasir dan menu pelanggan'),
            value: isActive,
            onChanged: onActiveChanged,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onReset,
                  child: const Text('Batal / Reset'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.icon(
                  onPressed: onSave,
                  icon: const Icon(Icons.check),
                  label: const Text('Simpan'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AdminColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.category,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  final _CategoryEntry category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key('category-row-${category.name}'),
      margin: const EdgeInsets.only(bottom: 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(14),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              runSpacing: 8,
              children: [
                SizedBox(
                  width: constraints.maxWidth < 408
                      ? constraints.maxWidth - 28
                      : 340,
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AdminColors.soft,
                        child: Text(
                          '#${category.order}',
                          style: const TextStyle(color: AdminColors.primary),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 8,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  category.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                AdminStatusPill(
                                  label: category.isActive
                                      ? 'Aktif'
                                      : 'Nonaktif',
                                  isActive: category.isActive,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${category.itemCount} hidangan • ${category.description}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AdminColors.muted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 4,
                  children: [
                    Switch(value: category.isActive, onChanged: onToggle),
                    IconButton(
                      onPressed: onEdit,
                      tooltip: 'Edit',
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    IconButton(
                      onPressed: onDelete,
                      tooltip: 'Hapus',
                      color: AdminColors.red,
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CategoryEntry {
  _CategoryEntry({
    required this.name,
    required this.description,
    required this.itemCount,
    required this.order,
    this.isActive = true,
  });

  String name;
  String description;
  int itemCount;
  int order;
  bool isActive;
}
