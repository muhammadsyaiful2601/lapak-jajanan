import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:lapak_jajanan/features/admin/menu_editor_models.dart';
import 'package:lapak_jajanan/features/shared/widgets/admin_widgets.dart';

class MenuEditorDialog extends StatefulWidget {
  const MenuEditorDialog({super.key, required this.menu});

  final MenuEntry? menu;

  @override
  State<MenuEditorDialog> createState() => _MenuEditorDialogState();
}

class _MenuEditorDialogState extends State<MenuEditorDialog> {
  static const _categories = ['Makanan Berat', 'Camilan', 'Minuman'];

  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(
    text: widget.menu?.name ?? '',
  );
  late final _descriptionController = TextEditingController(
    text: widget.menu?.description ?? '',
  );
  late final _priceController = TextEditingController(
    text: widget.menu?.price.toString() ?? '',
  );
  final _imagePicker = ImagePicker();
  late Uint8List? _imageBytes = widget.menu?.imageBytes;
  late String _imageName = widget.menu?.imageName ?? '';
  late String _category = widget.menu?.category ?? _categories.first;
  late bool _isAvailable = widget.menu?.isAvailable ?? true;
  late List<MenuVariationGroup> _variations = [
    ...?widget.menu?.variationGroups,
  ];
  late List<MenuAddonSetting> _addons = [...?widget.menu?.addons];
  late List<MenuChoiceGroup> _choiceGroups = [...?widget.menu?.choiceGroups];

  bool get _isEditing => widget.menu != null;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: SizedBox(
        width: size.width < 792 ? size.width - 32 : 760,
        child: SingleChildScrollView(
          primary: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isEditing ? 'Edit Menu' : 'Tambah Menu',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 3),
                          const Text(
                            'Informasi menu dan seluruh kustomisasi dalam satu halaman.',
                            style: TextStyle(
                              color: AdminColors.muted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Tutup',
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: AdminColors.border),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AdminSectionCard(
                        title: 'Foto Menu',
                        subtitle: 'Unggah atau ganti foto menu',
                        child: _photoPicker(),
                      ),
                      const SizedBox(height: 12),
                      AdminSectionCard(
                        title: 'Informasi Menu',
                        subtitle:
                            'Data utama yang ditampilkan kepada pelanggan',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Menu tersedia untuk dipesan',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          _isAvailable ? 'Tersedia' : 'Habis',
                                          style: const TextStyle(
                                            color: AdminColors.muted,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Switch(
                                    key: const Key('menu-availability'),
                                    value: _isAvailable,
                                    onChanged: (value) =>
                                        setState(() => _isAvailable = value),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              key: const Key('menu-name'),
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Nama menu',
                                hintText: 'Contoh: Pentol Kuah Pedas',
                              ),
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                  ? 'Nama menu wajib diisi.'
                                  : null,
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              initialValue: _category,
                              decoration: const InputDecoration(
                                labelText: 'Kategori menu',
                              ),
                              items: [
                                for (final category in _categories)
                                  DropdownMenuItem(
                                    value: category,
                                    child: Text(category),
                                  ),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _category = value);
                                }
                              },
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              key: const Key('menu-price'),
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: const InputDecoration(
                                labelText: 'Harga dasar',
                                prefixText: 'Rp ',
                              ),
                              validator: (value) {
                                final price = value == null
                                    ? null
                                    : int.tryParse(value);
                                if (price == null || price < 0) {
                                  return 'Masukkan harga yang valid.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _descriptionController,
                              decoration: const InputDecoration(
                                labelText: 'Deskripsi',
                                hintText: 'Jelaskan menu secara singkat',
                              ),
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _section(
                        key: const PageStorageKey('menu-variations'),
                        title: 'Variasi Menu',
                        subtitle: 'Ukuran, level pedas, atau pilihan lainnya',
                        icon: Icons.tune_outlined,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: OutlinedButton.icon(
                              key: const Key('add-variation'),
                              onPressed: _editVariation,
                              icon: const Icon(Icons.add),
                              label: const Text('Tambah Variasi'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (_variations.isEmpty)
                            const _EmptySectionMessage(
                              message: 'Belum ada variasi untuk menu ini.',
                            )
                          else
                            for (
                              var index = 0;
                              index < _variations.length;
                              index++
                            )
                              _variationCard(index, _variations[index]),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _section(
                        key: const PageStorageKey('menu-addons'),
                        title: 'Add-on / Topping',
                        subtitle:
                            'Tambahkan dan atur add-on khusus untuk menu ini',
                        icon: Icons.add_circle_outline,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: OutlinedButton.icon(
                              key: const Key('add-addon'),
                              onPressed: () => _editAddon(),
                              icon: const Icon(Icons.add),
                              label: const Text('Tambah Add-on'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (_addons.isEmpty)
                            const _EmptySectionMessage(
                              message: 'Belum ada add-on untuk menu ini.',
                            )
                          else
                            for (var index = 0; index < _addons.length; index++)
                              _addonCard(index, _addons[index]),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _section(
                        key: const PageStorageKey('menu-custom-groups'),
                        title: 'Kustom Menu',
                        subtitle:
                            'Atur pilihan wajib atau opsional untuk pelanggan',
                        icon: Icons.checklist_outlined,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: OutlinedButton.icon(
                              key: const Key('add-choice-group'),
                              onPressed: _editChoiceGroup,
                              icon: const Icon(Icons.add),
                              label: const Text('Tambah Grup Pilihan'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (_choiceGroups.isEmpty)
                            const _EmptySectionMessage(
                              message: 'Belum ada grup pilihan kustom.',
                            )
                          else
                            for (
                              var index = 0;
                              index < _choiceGroups.length;
                              index++
                            )
                              _choiceGroupCard(index, _choiceGroups[index]),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1, color: AdminColors.border),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Perubahan hanya tersimpan di preview lokal.',
                      style: TextStyle(color: AdminColors.muted, fontSize: 11),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      alignment: WrapAlignment.end,
                      spacing: 8,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Batal'),
                        ),
                        FilledButton.icon(
                          key: const Key('save-menu'),
                          onPressed: _saveMenu,
                          icon: const Icon(Icons.save_outlined),
                          label: Text(
                            _isEditing ? 'Simpan Perubahan' : 'Simpan Menu',
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: AdminColors.primary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section({
    required Key key,
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Widget> children,
    bool initiallyExpanded = true,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        key: key,
        initiallyExpanded: initiallyExpanded,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: Icon(icon, color: AdminColors.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: AdminColors.muted, fontSize: 12),
        ),
        children: children,
      ),
    );
  }

  Widget _photoPicker() {
    final imageBytes = _imageBytes;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: AdminColors.soft,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AdminColors.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            key: const Key('pick-menu-photo'),
            onTap: _pickMenuPhoto,
            child: SizedBox(
              width: double.infinity,
              height: 190,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (imageBytes == null)
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 38,
                          color: AdminColors.primary,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Unggah Foto Menu',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Ketuk kotak ini untuk memilih foto',
                          style: TextStyle(
                            color: AdminColors.muted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  else
                    Image.memory(
                      imageBytes,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                            child: Text(
                              'Pratinjau foto gagal dimuat.',
                              style: TextStyle(color: AdminColors.muted),
                            ),
                          ),
                    ),
                  if (imageBytes != null) ...[
                    const Align(
                      alignment: Alignment.bottomCenter,
                      child: ColoredBox(
                        color: Colors.black54,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 9,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.photo_camera_outlined,
                                size: 18,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Ketuk foto untuk mengganti',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton.filledTonal(
                        key: const Key('remove-menu-photo'),
                        tooltip: 'Hapus foto',
                        onPressed: () => setState(() {
                          _imageBytes = null;
                          _imageName = '';
                        }),
                        style: IconButton.styleFrom(
                          backgroundColor: AdminColors.surface,
                          foregroundColor: AdminColors.red,
                        ),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        if (_imageName.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            _imageName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AdminColors.muted, fontSize: 12),
          ),
        ],
        const SizedBox(height: 6),
        const Text(
          'Foto hanya tampil di preview lokal dan belum diunggah ke server.',
          style: TextStyle(color: AdminColors.muted, fontSize: 11),
        ),
      ],
    );
  }

  Future<void> _pickMenuPhoto() async {
    try {
      final photo = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1600,
        maxHeight: 1600,
      );
      if (photo == null) return;
      final bytes = await photo.readAsBytes();
      if (!mounted) return;
      setState(() {
        _imageBytes = bytes;
        _imageName = photo.name;
      });
    } on PlatformException catch (error) {
      if (!mounted) return;
      _showMessage(
        context,
        'Foto gagal dipilih: ${error.message ?? error.code}',
      );
    }
  }

  Widget _variationCard(int index, MenuVariationGroup group) {
    return Card(
      key: Key('variation-group-${group.name}'),
      color: AdminColors.soft,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    group.name,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  tooltip: 'Edit variasi ${group.name}',
                  onPressed: () => _editVariation(group, index),
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  tooltip: 'Hapus variasi ${group.name}',
                  onPressed: () => _deleteVariation(index, group),
                  color: AdminColors.red,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            for (final option in group.options)
              _optionStatusRow(
                option,
                onAvailabilityChanged: (value) =>
                    _setVariationOptionAvailability(index, option, value),
              ),
          ],
        ),
      ),
    );
  }

  Widget _addonCard(int index, MenuAddonSetting addon) {
    return Card(
      key: Key('menu-addon-${addon.id}'),
      color: AdminColors.soft,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.add_circle_outline,
                  color: AdminColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        addon.name,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        addon.extraPrice == 0
                            ? 'Gratis'
                            : '+${_rupiah(addon.extraPrice)}',
                        style: const TextStyle(
                          color: AdminColors.primary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  key: Key('edit-addon-${addon.id}'),
                  tooltip: 'Edit add-on ${addon.name}',
                  onPressed: () => _editAddon(addon, index),
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  key: Key('delete-addon-${addon.id}'),
                  tooltip: 'Hapus add-on ${addon.name}',
                  onPressed: () => _deleteAddon(index, addon),
                  color: AdminColors.red,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            const Divider(height: 12),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Tersedia pada menu ini',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                if (!addon.isAvailableForMenu)
                  const Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: AdminStatusPill(label: 'Habis', isActive: false),
                  ),
                Switch(
                  key: Key('addon-availability-${addon.id}'),
                  value: addon.isAvailableForMenu,
                  activeTrackColor: AdminColors.green,
                  onChanged: (value) => _setAddonAvailability(index, value),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _choiceGroupCard(int index, MenuChoiceGroup group) {
    final selectionText = group.isRequired
        ? 'Wajib memilih ${group.minimumChoices}–${group.maximumChoices}'
        : 'Opsional, maksimal ${group.maximumChoices} pilihan';
    return Card(
      key: Key('choice-group-${group.name}'),
      color: AdminColors.soft,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.name,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        selectionText,
                        style: const TextStyle(
                          color: AdminColors.muted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Edit grup ${group.name}',
                  onPressed: () => _editChoiceGroup(group, index),
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  tooltip: 'Hapus grup ${group.name}',
                  onPressed: () => _deleteChoiceGroup(index, group),
                  color: AdminColors.red,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            for (final option in group.options)
              _optionStatusRow(
                option,
                onAvailabilityChanged: (value) =>
                    _setChoiceOptionAvailability(index, option, value),
              ),
          ],
        ),
      ),
    );
  }

  Widget _optionStatusRow(
    MenuOption option, {
    required ValueChanged<bool> onAvailabilityChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              option.name,
              style: TextStyle(
                color: option.isAvailable
                    ? AdminColors.text
                    : AdminColors.muted,
              ),
            ),
          ),
          Text(
            _optionPrice(option),
            style: const TextStyle(color: AdminColors.muted, fontSize: 12),
          ),
          const SizedBox(width: 8),
          if (!option.isAvailable)
            const AdminStatusPill(label: 'Habis', isActive: false),
          Switch(
            value: option.isAvailable,
            activeTrackColor: AdminColors.green,
            onChanged: onAvailabilityChanged,
          ),
        ],
      ),
    );
  }

  Future<void> _editVariation([
    MenuVariationGroup? original,
    int? index,
  ]) async {
    final result = await showDialog<MenuVariationGroup>(
      context: context,
      builder: (context) => VariationGroupDialog(group: original),
    );
    if (result == null || !mounted) return;
    setState(() {
      if (index == null) {
        _variations = [..._variations, result];
      } else {
        _variations = [
          for (var current = 0; current < _variations.length; current++)
            if (current == index) result else _variations[current],
        ];
      }
    });
  }

  Future<void> _editChoiceGroup([MenuChoiceGroup? original, int? index]) async {
    final result = await showDialog<MenuChoiceGroup>(
      context: context,
      builder: (context) => ChoiceGroupDialog(group: original),
    );
    if (result == null || !mounted) return;
    setState(() {
      if (index == null) {
        _choiceGroups = [..._choiceGroups, result];
      } else {
        _choiceGroups = [
          for (var current = 0; current < _choiceGroups.length; current++)
            if (current == index) result else _choiceGroups[current],
        ];
      }
    });
  }

  Future<void> _editAddon([MenuAddonSetting? original, int? index]) async {
    final result = await showDialog<_AddonEditResult>(
      context: context,
      builder: (context) => AddonEditorDialog(addon: original),
    );
    if (result == null || !mounted) return;

    setState(() {
      final setting = MenuAddonSetting(
        id: result.id,
        name: result.name,
        extraPrice: result.extraPrice,
        isAvailableForMenu: original?.isAvailableForMenu ?? true,
      );
      if (index == null) {
        _addons = [..._addons, setting];
      } else {
        _addons = [
          for (var current = 0; current < _addons.length; current++)
            if (current == index) setting else _addons[current],
        ];
      }
    });
  }

  Future<void> _deleteVariation(int index, MenuVariationGroup group) async {
    if (await _confirmDelete('variasi "${group.name}"?') != true || !mounted) {
      return;
    }
    setState(() {
      _variations = [..._variations]..removeAt(index);
    });
  }

  Future<void> _deleteChoiceGroup(int index, MenuChoiceGroup group) async {
    if (await _confirmDelete('grup "${group.name}"?') != true || !mounted) {
      return;
    }
    setState(() {
      _choiceGroups = [..._choiceGroups]..removeAt(index);
    });
  }

  Future<void> _deleteAddon(int index, MenuAddonSetting addon) async {
    if (await _confirmDelete('add-on "${addon.name}" dari menu ini?') != true ||
        !mounted) {
      return;
    }
    setState(() {
      _addons = [..._addons]..removeAt(index);
    });
  }

  Future<bool?> _confirmDelete(String item) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus pengaturan?'),
        content: Text('Anda yakin ingin menghapus $item'),
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
  }

  void _setVariationOptionAvailability(
    int groupIndex,
    MenuOption option,
    bool available,
  ) {
    setState(() {
      final group = _variations[groupIndex];
      _variations[groupIndex] = MenuVariationGroup(
        name: group.name,
        options: [
          for (final current in group.options)
            if (identical(current, option))
              current.copyWith(isAvailable: available)
            else
              current,
        ],
      );
    });
  }

  void _setChoiceOptionAvailability(
    int groupIndex,
    MenuOption option,
    bool available,
  ) {
    setState(() {
      final group = _choiceGroups[groupIndex];
      _choiceGroups[groupIndex] = MenuChoiceGroup(
        name: group.name,
        isRequired: group.isRequired,
        minimumChoices: group.minimumChoices,
        maximumChoices: group.maximumChoices,
        options: [
          for (final current in group.options)
            if (identical(current, option))
              current.copyWith(isAvailable: available)
            else
              current,
        ],
      );
    });
  }

  void _setAddonAvailability(int index, bool available) {
    setState(() {
      _addons = [
        for (var current = 0; current < _addons.length; current++)
          if (current == index)
            _addons[current].copyWith(isAvailableForMenu: available)
          else
            _addons[current],
      ];
    });
  }

  void _saveMenu() {
    if (!_formKey.currentState!.validate()) return;
    final name = _nameController.text.trim();
    final menu = MenuEntry(
      name: name,
      description: _descriptionController.text.trim(),
      category: _category,
      price: int.parse(_priceController.text),
      imageBytes: _imageBytes,
      imageName: _imageName,
      isAvailable: _isAvailable,
      toppings: _addons.isEmpty
          ? '—'
          : _addons.map((addon) => addon.name).join(', '),
      addons: [..._addons],
      variationGroups: [..._variations],
      choiceGroups: [..._choiceGroups],
    );
    Navigator.pop(context, menu);
  }
}

class VariationGroupDialog extends StatefulWidget {
  const VariationGroupDialog({super.key, this.group});

  final MenuVariationGroup? group;

  @override
  State<VariationGroupDialog> createState() => _VariationGroupDialogState();
}

class _VariationGroupDialogState extends State<VariationGroupDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(
    text: widget.group?.name ?? '',
  );
  late List<MenuOption> _options = [...?widget.group?.options];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.group == null ? 'Tambah Variasi' : 'Edit Variasi'),
      content: SizedBox(
        width: 520,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  key: const Key('variation-name'),
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama variasi',
                    hintText: 'Contoh: Ukuran',
                  ),
                  validator: _requiredText,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Opsi variasi',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    TextButton.icon(
                      key: const Key('add-variation-option'),
                      onPressed: _editOption,
                      icon: const Icon(Icons.add),
                      label: const Text('Tambah Opsi'),
                    ),
                  ],
                ),
                if (_options.isEmpty)
                  const _EmptySectionMessage(
                    message: 'Tambahkan minimal satu opsi variasi.',
                  ),
                for (var index = 0; index < _options.length; index++)
                  _editableOptionRow(index, _options[index]),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          key: const Key('save-variation'),
          onPressed: _save,
          style: FilledButton.styleFrom(
            backgroundColor: AdminColors.primary,
            foregroundColor: Colors.white,
          ),
          child: const Text('Simpan Variasi'),
        ),
      ],
    );
  }

  Widget _editableOptionRow(int index, MenuOption option) {
    return _EditableOptionRow(
      option: option,
      onEdit: () => _editOption(option, index),
      onDelete: () => _deleteOption(index, option),
      onAvailabilityChanged: (value) => setState(() {
        _options[index] = option.copyWith(isAvailable: value);
      }),
    );
  }

  Future<void> _editOption([MenuOption? original, int? index]) async {
    final result = await showDialog<MenuOption>(
      context: context,
      builder: (context) =>
          OptionEditorDialog(option: original, allowFixedPrice: true),
    );
    if (result == null || !mounted) return;
    setState(() {
      if (index == null) {
        _options = [..._options, result];
      } else {
        _options[index] = result;
      }
    });
  }

  Future<void> _deleteOption(int index, MenuOption option) async {
    if (await _confirmDelete('opsi "${option.name}"?', context) != true ||
        !mounted) {
      return;
    }
    setState(() {
      _options = [..._options]..removeAt(index);
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_options.isEmpty) {
      _showMessage(context, 'Tambahkan minimal satu opsi variasi.');
      return;
    }
    Navigator.pop(
      context,
      MenuVariationGroup(
        name: _nameController.text.trim(),
        options: [..._options],
      ),
    );
  }
}

class ChoiceGroupDialog extends StatefulWidget {
  const ChoiceGroupDialog({super.key, this.group});

  final MenuChoiceGroup? group;

  @override
  State<ChoiceGroupDialog> createState() => _ChoiceGroupDialogState();
}

class _ChoiceGroupDialogState extends State<ChoiceGroupDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(
    text: widget.group?.name ?? '',
  );
  late final _minimumController = TextEditingController(
    text: widget.group?.minimumChoices.toString() ?? '1',
  );
  late final _maximumController = TextEditingController(
    text: widget.group?.maximumChoices.toString() ?? '1',
  );
  late bool _isRequired = widget.group?.isRequired ?? true;
  late List<MenuOption> _options = [...?widget.group?.options];

  @override
  void dispose() {
    _nameController.dispose();
    _minimumController.dispose();
    _maximumController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.group == null ? 'Tambah Grup Pilihan' : 'Edit Grup Pilihan',
      ),
      content: SizedBox(
        width: 560,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  key: const Key('choice-group-name'),
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama grup pilihan',
                    hintText: 'Contoh: Pilih level kepedasan',
                  ),
                  validator: _requiredText,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<bool>(
                  key: const Key('choice-kind'),
                  initialValue: _isRequired,
                  decoration: const InputDecoration(labelText: 'Jenis pilihan'),
                  items: const [
                    DropdownMenuItem(value: true, child: Text('Wajib')),
                    DropdownMenuItem(value: false, child: Text('Opsional')),
                  ],
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _isRequired = value;
                      if (value && int.tryParse(_minimumController.text) == 0) {
                        _minimumController.text = '1';
                      } else if (!value) {
                        _minimumController.text = '0';
                      }
                    });
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        key: const Key('choice-minimum'),
                        controller: _minimumController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Minimal pilihan',
                        ),
                        validator: (value) {
                          final minimum = int.tryParse(value ?? '');
                          if (minimum == null ||
                              minimum < (_isRequired ? 1 : 0)) {
                            return _isRequired
                                ? 'Wajib minimal 1.'
                                : 'Minimal 0.';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        key: const Key('choice-maximum'),
                        controller: _maximumController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Maksimal pilihan',
                        ),
                        validator: (value) {
                          final maximum = int.tryParse(value ?? '');
                          final minimum =
                              int.tryParse(_minimumController.text) ?? 0;
                          if (maximum == null || maximum < 1) {
                            return 'Maksimal minimal 1.';
                          }
                          if (maximum < minimum) {
                            return 'Tidak boleh kurang dari minimal.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Daftar opsi',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    TextButton.icon(
                      key: const Key('add-choice-option'),
                      onPressed: _editOption,
                      icon: const Icon(Icons.add),
                      label: const Text('Tambah Opsi'),
                    ),
                  ],
                ),
                if (_options.isEmpty)
                  const _EmptySectionMessage(
                    message: 'Tambahkan minimal satu opsi.',
                  ),
                for (var index = 0; index < _options.length; index++)
                  _editableOptionRow(index, _options[index]),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          key: const Key('save-choice-group'),
          onPressed: _save,
          style: FilledButton.styleFrom(
            backgroundColor: AdminColors.primary,
            foregroundColor: Colors.white,
          ),
          child: const Text('Simpan Grup'),
        ),
      ],
    );
  }

  Widget _editableOptionRow(int index, MenuOption option) {
    return _EditableOptionRow(
      option: option,
      onEdit: () => _editOption(option, index),
      onDelete: () => _deleteOption(index, option),
      onAvailabilityChanged: (value) => setState(() {
        _options[index] = option.copyWith(isAvailable: value);
      }),
    );
  }

  Future<void> _editOption([MenuOption? original, int? index]) async {
    final result = await showDialog<MenuOption>(
      context: context,
      builder: (context) =>
          OptionEditorDialog(option: original, allowFixedPrice: false),
    );
    if (result == null || !mounted) return;
    setState(() {
      if (index == null) {
        _options = [..._options, result];
      } else {
        _options[index] = result;
      }
    });
  }

  Future<void> _deleteOption(int index, MenuOption option) async {
    if (await _confirmDelete('opsi "${option.name}"?', context) != true ||
        !mounted) {
      return;
    }
    setState(() {
      _options = [..._options]..removeAt(index);
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_options.isEmpty) {
      _showMessage(context, 'Tambahkan minimal satu opsi.');
      return;
    }
    Navigator.pop(
      context,
      MenuChoiceGroup(
        name: _nameController.text.trim(),
        isRequired: _isRequired,
        minimumChoices: int.parse(_minimumController.text),
        maximumChoices: int.parse(_maximumController.text),
        options: [..._options],
      ),
    );
  }
}

class OptionEditorDialog extends StatefulWidget {
  const OptionEditorDialog({
    super.key,
    this.option,
    required this.allowFixedPrice,
  });

  final MenuOption? option;
  final bool allowFixedPrice;

  @override
  State<OptionEditorDialog> createState() => _OptionEditorDialogState();
}

class _OptionEditorDialogState extends State<OptionEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(
    text: widget.option?.name ?? '',
  );
  late final _priceController = TextEditingController(
    text: widget.option?.price.toString() ?? '0',
  );
  late bool _isFixedPrice = widget.option?.isFixedPrice ?? false;
  late bool _isAvailable = widget.option?.isAvailable ?? true;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.option == null ? 'Tambah Opsi' : 'Edit Opsi'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                key: const Key('option-name'),
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama opsi'),
                validator: _requiredText,
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const Key('option-price'),
                controller: _priceController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Harga opsi',
                  prefixText: 'Rp ',
                ),
                validator: (value) {
                  final price = int.tryParse(value ?? '');
                  return price == null || price < 0
                      ? 'Masukkan harga yang valid.'
                      : null;
                },
              ),
              if (widget.allowFixedPrice)
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Harga tersendiri'),
                  subtitle: const Text(
                    'Nonaktifkan untuk memakai harga tambahan.',
                    style: TextStyle(fontSize: 11),
                  ),
                  value: _isFixedPrice,
                  onChanged: (value) => setState(() => _isFixedPrice = value),
                ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Opsi tersedia'),
                subtitle: Text(_isAvailable ? 'Tersedia' : 'Habis'),
                value: _isAvailable,
                onChanged: (value) => setState(() => _isAvailable = value),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          key: const Key('save-option'),
          onPressed: _save,
          style: FilledButton.styleFrom(
            backgroundColor: AdminColors.primary,
            foregroundColor: Colors.white,
          ),
          child: const Text('Simpan Opsi'),
        ),
      ],
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      MenuOption(
        name: _nameController.text.trim(),
        price: int.parse(_priceController.text),
        isFixedPrice: _isFixedPrice,
        isAvailable: _isAvailable,
      ),
    );
  }
}

class AddonEditorDialog extends StatefulWidget {
  const AddonEditorDialog({super.key, this.addon});

  final MenuAddonSetting? addon;

  @override
  State<AddonEditorDialog> createState() => _AddonEditorDialogState();
}

class _AddonEditorDialogState extends State<AddonEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(
    text: widget.addon?.name ?? '',
  );
  late final _priceController = TextEditingController(
    text: widget.addon?.extraPrice.toString() ?? '0',
  );
  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.addon == null ? 'Tambah Add-on' : 'Edit Add-on'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                key: const Key('addon-name'),
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama add-on'),
                validator: _requiredText,
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const Key('addon-price'),
                controller: _priceController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Harga tambahan',
                  prefixText: 'Rp ',
                ),
                validator: (value) {
                  final price = int.tryParse(value ?? '');
                  return price == null || price < 0
                      ? 'Masukkan harga yang valid.'
                      : null;
                },
              ),
              const Text(
                'Add-on ini hanya untuk menu ini. Perubahan masih berupa preview lokal.',
                style: TextStyle(color: AdminColors.muted, fontSize: 11),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          key: const Key('save-addon'),
          onPressed: _save,
          style: FilledButton.styleFrom(
            backgroundColor: AdminColors.primary,
            foregroundColor: Colors.white,
          ),
          child: const Text('Simpan Add-on'),
        ),
      ],
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final id =
        widget.addon?.id ?? 'local-${DateTime.now().microsecondsSinceEpoch}';
    Navigator.pop(
      context,
      _AddonEditResult(
        id: id,
        name: _nameController.text.trim(),
        extraPrice: int.parse(_priceController.text),
      ),
    );
  }
}

class _AddonEditResult {
  const _AddonEditResult({
    required this.id,
    required this.name,
    required this.extraPrice,
  });

  final String id;
  final String name;
  final int extraPrice;
}

class _EditableOptionRow extends StatelessWidget {
  const _EditableOptionRow({
    required this.option,
    required this.onEdit,
    required this.onDelete,
    required this.onAvailabilityChanged,
  });

  final MenuOption option;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onAvailabilityChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key('option-row-${option.name}'),
      color: AdminColors.soft,
      margin: const EdgeInsets.only(bottom: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 6,
          children: [
            SizedBox(
              width: 170,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    _optionPrice(option),
                    style: const TextStyle(
                      color: AdminColors.muted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!option.isAvailable)
                  const AdminStatusPill(label: 'Habis', isActive: false),
                Switch(
                  value: option.isAvailable,
                  onChanged: onAvailabilityChanged,
                ),
                IconButton(
                  tooltip: 'Edit opsi ${option.name}',
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  tooltip: 'Hapus opsi ${option.name}',
                  onPressed: onDelete,
                  color: AdminColors.red,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptySectionMessage extends StatelessWidget {
  const _EmptySectionMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AdminColors.soft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        style: const TextStyle(color: AdminColors.muted, fontSize: 12),
      ),
    );
  }
}

Future<bool?> _confirmDelete(String item, BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Hapus opsi?'),
      content: Text('Anda yakin ingin menghapus $item'),
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
}

String? _requiredText(String? value) =>
    value == null || value.trim().isEmpty ? 'Bagian ini wajib diisi.' : null;

String _rupiah(int value) =>
    'Rp${NumberFormat.decimalPattern('id_ID').format(value)}';

String _optionPrice(MenuOption option) {
  if (option.price == 0) return 'Termasuk';
  return option.isFixedPrice
      ? 'Harga ${_rupiah(option.price)}'
      : '+${_rupiah(option.price)}';
}

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
