import 'package:material_ui/material_ui.dart';
import 'package:lapak_jajanan/features/admin/menu_editor_dialog.dart';
import 'package:lapak_jajanan/features/admin/menu_editor_models.dart';
import 'package:lapak_jajanan/features/shared/widgets/admin_widgets.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final _searchController = TextEditingController();
  final List<MenuEntry> _menus = createPreviewMenus();

  String _selectedCategory = 'Semua';
  String _selectedAvailability = 'Semua status';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MenuEntry> get _visibleMenus {
    final query = _searchController.text.trim().toLowerCase();
    return _menus.where((menu) {
      final matchesQuery =
          query.isEmpty ||
          menu.name.toLowerCase().contains(query) ||
          menu.category.toLowerCase().contains(query);
      final matchesCategory =
          _selectedCategory == 'Semua' || menu.category == _selectedCategory;
      final matchesAvailability =
          _selectedAvailability == 'Semua status' ||
          (_selectedAvailability == 'Tersedia' && menu.isAvailable) ||
          (_selectedAvailability == 'Habis' && !menu.isAvailable);
      return matchesQuery && matchesCategory && matchesAvailability;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final availableCount = _menus.where((menu) => menu.isAvailable).length;
    final categories = _menus.map((menu) => menu.category).toSet().toList();

    return ListView(
      key: const Key('catalog-scroll-view'),
      padding: const EdgeInsets.all(22),
      children: [
        AdminPageTitle(
          eyebrow: 'Manajemen dapur & menu',
          title: 'Katalog & Pengelolaan Menu',
          description: 'Kelola menu, variasi, topping, dan kustomisasi dalam satu tempat.',
          action: AdminPrimaryButton(
            label: 'Tambah Menu Baru',
            icon: Icons.add,
            onPressed: () => _editMenu(),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            const spacing = 12.0;
            final columns = constraints.maxWidth >= 1000
                ? 4
                : constraints.maxWidth >= 560
                ? 2
                : 1;
            final cardWidth =
                (constraints.maxWidth - spacing * (columns - 1)) / columns;
            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                AdminMetricCard(
                  key: const Key('catalog-metric-total'),
                  width: cardWidth,
                  label: 'Total hidangan',
                  value: '${_menus.length}',
                  detail: 'Item terdaftar',
                  icon: Icons.restaurant_menu_outlined,
                ),
                AdminMetricCard(
                  width: cardWidth,
                  label: 'Siap dipesan',
                  value: '$availableCount',
                  detail: 'Aktif',
                  icon: Icons.check_circle_outline,
                  tint: AdminColors.green,
                  background: AdminColors.greenSoft,
                ),
                AdminMetricCard(
                  width: cardWidth,
                  label: 'Habis / kosong',
                  value: '${_menus.length - availableCount}',
                  detail: 'Perlu restock',
                  icon: Icons.remove_circle_outline,
                  tint: AdminColors.red,
                  background: AdminColors.redSoft,
                ),
                AdminMetricCard(
                  width: cardWidth,
                  label: 'Kategori aktif',
                  value: '${categories.length}',
                  detail: 'Grup menu',
                  icon: Icons.category_outlined,
                  background: const Color(0xFFF5DBCD),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 18),
        AdminSectionCard(
          title: 'Daftar menu',
          subtitle: '${_visibleMenus.length} dari ${_menus.length} hidangan',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Cari nama menu atau kategori...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              const Text(
                'Kategori',
                style: TextStyle(
                  color: AdminColors.muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final category in ['Semua', ...categories])
                      ChoiceChip(
                        label: Text(category),
                        selected: _selectedCategory == category,
                        onSelected: (_) =>
                            setState(() => _selectedCategory = category),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Ketersediaan',
                style: TextStyle(
                  color: AdminColors.muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final availability in [
                      'Semua status',
                      'Tersedia',
                      'Habis',
                    ])
                      ChoiceChip(
                        label: Text(availability),
                        selected: _selectedAvailability == availability,
                        onSelected: (_) => setState(
                          () => _selectedAvailability = availability,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (_visibleMenus.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Menu tidak ditemukan. Coba kata kunci atau filter lain.',
                    style: TextStyle(color: AdminColors.muted),
                  ),
                )
              else
                for (final menu in _visibleMenus)
                  _MenuRow(
                    menu: menu,
                    onAvailabilityChanged: (value) =>
                        setState(() => menu.isAvailable = value),
                    onEdit: () => _editMenu(menu),
                    onDelete: () => _deleteMenu(menu),
                  ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AdminColors.primary),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Pengaturan menu di halaman ini berjalan dalam preview lokal dan belum disimpan ke database.',
                    style: TextStyle(color: AdminColors.muted),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _editMenu([MenuEntry? original]) async {
    final result = await showDialog<MenuEntry>(
      context: context,
      builder: (context) => MenuEditorDialog(menu: original),
    );
    if (result == null || !mounted) return;
    setState(() {
      if (original == null) {
        _menus.add(result);
      } else {
        final index = _menus.indexOf(original);
        if (index >= 0) _menus[index] = result;
      }
    });
    _showMessage(
      original == null
          ? 'Menu ditambahkan ke preview lokal.'
          : 'Perubahan preview menu diperbarui.',
    );
  }

  Future<void> _deleteMenu(MenuEntry menu) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus menu?'),
        content: Text('Menu "${menu.name}" akan dihapus dari preview lokal.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: AdminColors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) {
      setState(() => _menus.remove(menu));
      _showMessage('Menu dihapus dari preview lokal.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.menu,
    required this.onAvailabilityChanged,
    required this.onEdit,
    required this.onDelete,
  });

  final MenuEntry menu;
  final ValueChanged<bool> onAvailabilityChanged;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AdminColors.border)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 680;
          final photo = menu.imageBytes;
          final details = Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: AdminColors.soft,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: photo == null
                    ? Icon(
                        menu.category == 'Minuman'
                            ? Icons.local_drink_outlined
                            : Icons.restaurant_outlined,
                        color: AdminColors.primary,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: Image.memory(
                          photo,
                          width: 54,
                          height: 54,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      menu.name,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      menu.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AdminColors.muted,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      menu.category,
                      style: const TextStyle(
                        color: AdminColors.primary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
          final actions = Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            children: [
              Text(
                'Rp${menu.price}',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              Switch(
                value: menu.isAvailable,
                activeTrackColor: AdminColors.green,
                onChanged: onAvailabilityChanged,
              ),
              IconButton(
                tooltip: 'Edit menu ${menu.name}',
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                tooltip: 'Hapus menu ${menu.name}',
                onPressed: onDelete,
                color: AdminColors.red,
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          );
          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                details,
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        menu.toppings,
                        style: const TextStyle(
                          color: AdminColors.muted,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    actions,
                  ],
                ),
              ],
            );
          }
          return Row(
            children: [
              Expanded(flex: 4, child: details),
              Expanded(
                flex: 2,
                child: Text(
                  menu.toppings,
                  style: const TextStyle(
                    color: AdminColors.muted,
                    fontSize: 12,
                  ),
                ),
              ),
              actions,
            ],
          );
        },
      ),
    );
  }
}
