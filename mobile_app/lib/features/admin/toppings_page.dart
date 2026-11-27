import 'package:material_ui/material_ui.dart';
import 'package:lapak_jajanan/features/shared/widgets/admin_widgets.dart';

class ToppingsPage extends StatefulWidget {
  const ToppingsPage({super.key});

  @override
  State<ToppingsPage> createState() => _ToppingsPageState();
}

class _ToppingsPageState extends State<ToppingsPage> {
  final _searchController = TextEditingController();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController(text: '0');
  final List<String> _menuNames = [
    'Pentol Kuah Pedas',
    'Mie Ayam Bakso',
    'Es Teh Manis',
    'Es Jeruk',
  ];
  final List<_AddonEntry> _addons = [
    _AddonEntry(
      name: 'Tetelan',
      type: 'Topping Ekstra',
      menuNames: ['Pentol Kuah Pedas'],
      price: 5000,
    ),
    _AddonEntry(
      name: 'Extra Pentol',
      type: 'Topping Ekstra',
      menuNames: ['Pentol Kuah Pedas'],
      price: 4000,
    ),
    _AddonEntry(
      name: 'Extra Bakso',
      type: 'Topping Ekstra',
      menuNames: ['Mie Ayam Bakso'],
      price: 5000,
      isAvailable: false,
    ),
    _AddonEntry(
      name: 'Level Kepedasan',
      type: 'Pilihan Rasa',
      menuNames: ['Pentol Kuah Pedas'],
      price: 0,
    ),
    _AddonEntry(
      name: 'Extra Gula',
      type: 'Pilihan Wajib',
      menuNames: ['Es Teh Manis'],
      price: 0,
    ),
  ];

  final Set<String> _selectedMenus = {};
  String _selectedType = 'Topping Ekstra';
  String _filterType = 'Semua tipe';
  _AddonEntry? _editingAddon;
  bool _isAvailable = true;

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  List<_AddonEntry> get _visibleAddons {
    final query = _searchController.text.trim().toLowerCase();
    return _addons.where((addon) {
      final matchesQuery =
          query.isEmpty ||
          addon.name.toLowerCase().contains(query) ||
          addon.menuNames.any((name) => name.toLowerCase().contains(query));
      final matchesType =
          _filterType == 'Semua tipe' || addon.type == _filterType;
      return matchesQuery && matchesType;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final paidCount = _addons.where((addon) => addon.price > 0).length;
    return ListView(
      padding: const EdgeInsets.all(22),
      children: [
        AdminPageTitle(
          eyebrow: 'Katalog & modifikasi menu',
          title: 'Variasi & Topping Menu',
          description: 'Atur pilihan rasa, level pedas, dan topping tambahan beserta harga ekstra.',
          action: AdminStatusPill(label: '${_addons.length} opsi terdaftar'),
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            AdminMetricCard(
              label: 'Total opsi variasi',
              value: '${_addons.length}',
              detail: 'Item terdaftar',
              icon: Icons.tune_outlined,
            ),
            AdminMetricCard(
              label: 'Topping berbayar',
              value: '$paidCount',
              detail: 'Extra charge',
              icon: Icons.payments_outlined,
              background: const Color(0xFFF5DBCD),
            ),
            AdminMetricCard(
              label: 'Pilihan gratis',
              value: '${_addons.length - paidCount}',
              detail: 'Termasuk menu',
              icon: Icons.check_circle_outline,
              tint: AdminColors.green,
              background: AdminColors.greenSoft,
            ),
          ],
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final list = AdminSectionCard(
              title: 'Daftar variasi',
              subtitle: '${_visibleAddons.length} dari ${_addons.length} opsi',
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Cari topping, variasi, atau hidangan...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final type in [
                        'Semua tipe',
                        'Topping Ekstra',
                        'Pilihan Rasa',
                        'Pilihan Wajib',
                      ])
                        ChoiceChip(
                          label: Text(type),
                          selected: _filterType == type,
                          onSelected: (_) => setState(() => _filterType = type),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_visibleAddons.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('Variasi tidak ditemukan.'),
                    )
                  else
                    for (final addon in _visibleAddons)
                      _AddonRow(
                        addon: addon,
                        onEdit: () => _startEditing(addon),
                        onAvailabilityChanged: (value) =>
                            setState(() => addon.isAvailable = value),
                      ),
                ],
              ),
            );
            final editor = _AddonEditor(
              nameController: _nameController,
              priceController: _priceController,
              menuNames: _menuNames,
              selectedMenus: _selectedMenus,
              selectedType: _selectedType,
              isAvailable: _isAvailable,
              isEditing: _editingAddon != null,
              onTypeChanged: (value) => setState(() => _selectedType = value),
              onMenuChanged: (menu, checked) => setState(() {
                if (checked) {
                  _selectedMenus.add(menu);
                } else {
                  _selectedMenus.remove(menu);
                }
              }),
              onAvailabilityChanged: (value) =>
                  setState(() => _isAvailable = value),
              onSave: _saveAddon,
              onReset: _resetForm,
            );
            if (constraints.maxWidth >= 1120) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: list),
                  const SizedBox(width: 16),
                  Expanded(flex: 4, child: editor),
                ],
              );
            }
            return Column(children: [list, const SizedBox(height: 16), editor]);
          },
        ),
      ],
    );
  }

  void _startEditing(_AddonEntry addon) {
    setState(() {
      _editingAddon = addon;
      _nameController.text = addon.name;
      _priceController.text = addon.price.toString();
      _selectedType = addon.type;
      _selectedMenus
        ..clear()
        ..addAll(addon.menuNames);
      _isAvailable = addon.isAvailable;
    });
  }

  void _saveAddon() {
    final name = _nameController.text.trim();
    final price = int.tryParse(_priceController.text);
    final editingAddon = _editingAddon;
    if (name.isEmpty || price == null || price < 0 || _selectedMenus.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Isi nama, harga yang valid, dan pilih minimal satu menu.',
          ),
        ),
      );
      return;
    }

    setState(() {
      final entry = _AddonEntry(
        name: name,
        type: _selectedType,
        menuNames: _selectedMenus.toList(),
        price: price,
        isAvailable: _isAvailable,
      );
      if (editingAddon == null) {
        _addons.add(entry);
      } else {
        final index = _addons.indexOf(editingAddon);
        if (index >= 0) _addons[index] = entry;
      }
      _clearForm();
    });
  }

  void _resetForm() => setState(_clearForm);

  void _clearForm() {
    _editingAddon = null;
    _nameController.clear();
    _priceController.text = '0';
    _selectedType = 'Topping Ekstra';
    _selectedMenus.clear();
    _isAvailable = true;
  }
}

class _AddonEditor extends StatelessWidget {
  const _AddonEditor({
    required this.nameController,
    required this.priceController,
    required this.menuNames,
    required this.selectedMenus,
    required this.selectedType,
    required this.isAvailable,
    required this.isEditing,
    required this.onTypeChanged,
    required this.onMenuChanged,
    required this.onAvailabilityChanged,
    required this.onSave,
    required this.onReset,
  });

  final TextEditingController nameController;
  final TextEditingController priceController;
  final List<String> menuNames;
  final Set<String> selectedMenus;
  final String selectedType;
  final bool isAvailable;
  final bool isEditing;
  final ValueChanged<String> onTypeChanged;
  final void Function(String, bool) onMenuChanged;
  final ValueChanged<bool> onAvailabilityChanged;
  final VoidCallback onSave;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return AdminSectionCard(
      title: isEditing ? 'Edit Variasi' : 'Tambah / Hubungkan Variasi',
      subtitle: 'Terapkan opsi pada hidangan terkait',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Nama variasi / topping',
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: selectedType,
            decoration: const InputDecoration(labelText: 'Kategori perilaku'),
            items: const [
              DropdownMenuItem(
                value: 'Topping Ekstra',
                child: Text('Topping Ekstra'),
              ),
              DropdownMenuItem(
                value: 'Pilihan Rasa',
                child: Text('Pilihan Rasa'),
              ),
              DropdownMenuItem(
                value: 'Pilihan Wajib',
                child: Text('Pilihan Wajib'),
              ),
            ],
            onChanged: (value) {
              if (value != null) onTypeChanged(value);
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Harga ekstra (Rp)',
              prefixText: 'Rp ',
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Hubungkan ke hidangan',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Material(
            color: AdminColors.soft,
            borderRadius: BorderRadius.circular(14),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (final menu in menuNames)
                  CheckboxListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    title: Text(menu, style: const TextStyle(fontSize: 13)),
                    value: selectedMenus.contains(menu),
                    activeColor: AdminColors.primary,
                    onChanged: (value) => onMenuChanged(menu, value ?? false),
                  ),
              ],
            ),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Tersedia untuk dipesan'),
            value: isAvailable,
            onChanged: onAvailabilityChanged,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onReset,
                  child: const Text('Bersihkan'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: FilledButton.icon(
                  onPressed: onSave,
                  icon: const Icon(Icons.save_outlined),
                  label: Text(
                    isEditing ? 'Simpan Perubahan' : 'Simpan Variasi',
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AdminColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Mode preview: perubahan belum tersimpan ke database.',
            style: TextStyle(color: AdminColors.muted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _AddonRow extends StatelessWidget {
  const _AddonRow({
    required this.addon,
    required this.onEdit,
    required this.onAvailabilityChanged,
  });

  final _AddonEntry addon;
  final VoidCallback onEdit;
  final ValueChanged<bool> onAvailabilityChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AdminColors.border)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              SizedBox(
                width: constraints.maxWidth < 340 ? constraints.maxWidth : 320,
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: addon.price > 0
                            ? const Color(0xFFF5DBCD)
                            : AdminColors.greenSoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        addon.price > 0
                            ? Icons.add_circle_outline
                            : Icons.tune_outlined,
                        color: addon.price > 0
                            ? AdminColors.primary
                            : AdminColors.green,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            addon.name,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            addon.type,
                            style: const TextStyle(
                              color: AdminColors.muted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: constraints.maxWidth < 210 ? constraints.maxWidth : 190,
                child: Text(
                  addon.menuNames.join(', '),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AdminColors.muted,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                addon.price == 0 ? 'Gratis' : '+Rp${addon.price}',
                style: TextStyle(
                  color: addon.price == 0
                      ? AdminColors.green
                      : AdminColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Switch(
                value: addon.isAvailable,
                onChanged: onAvailabilityChanged,
              ),
              IconButton(
                onPressed: onEdit,
                tooltip: 'Edit',
                icon: const Icon(Icons.edit_outlined),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AddonEntry {
  _AddonEntry({
    required this.name,
    required this.type,
    required this.menuNames,
    required this.price,
    this.isAvailable = true,
  });

  final String name;
  final String type;
  final List<String> menuNames;
  final int price;
  bool isAvailable;
}
