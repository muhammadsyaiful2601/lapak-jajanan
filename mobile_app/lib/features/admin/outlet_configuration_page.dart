import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:lapak_jajanan/features/admin/outlet_model.dart';
import 'package:lapak_jajanan/features/shared/widgets/admin_widgets.dart';

class OutletConfigurationPage extends StatefulWidget {
  const OutletConfigurationPage({super.key, required this.outlet});

  final Outlet outlet;

  @override
  State<OutletConfigurationPage> createState() =>
      _OutletConfigurationPageState();
}

class _OutletConfigurationPageState extends State<OutletConfigurationPage> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  late final Outlet _outlet = widget.outlet.copy();
  late TimeOfDay _openTime = _parseTime(_outlet.openTime);
  late TimeOfDay _closeTime = _parseTime(_outlet.closeTime);
  final Set<String> _selectedDays = {
    'Sen',
    'Sel',
    'Rab',
    'Kam',
    'Jum',
    'Sab',
    'Min',
  };
  bool _isPublic = true;
  bool _isOpen = true;
  bool _hasChanges = false;

  static const _days = [
    ('Sen', 'Senin'),
    ('Sel', 'Selasa'),
    ('Rab', 'Rabu'),
    ('Kam', 'Kamis'),
    ('Jum', 'Jumat'),
    ('Sab', 'Sabtu'),
    ('Min', 'Minggu'),
  ];

  @override
  void initState() {
    super.initState();
    _loadOutlet();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const Key('outlet-configuration-scroll'),
      padding: const EdgeInsets.all(22),
      children: [
        AdminPageTitle(
          eyebrow: 'Pengaturan outlet',
          title: 'Konfigurasi & Penyesuaian Gerai',
          description:
              'Atur informasi, jam operasional, dan status layanan ${_outlet.name}.',
          action: OutlinedButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Kembali ke lokasi'),
          ),
        ),
        _buildForm(),
      ],
    );
  }

  Widget _buildForm() {
    return AdminSectionCard(
      title: 'Form konfigurasi gerai',
      subtitle: 'Perubahan disimpan sebagai preview lokal pada aplikasi ini.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: AdminColors.primary),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Status gerai akan ditampilkan di menu pemesanan pelanggan setelah backend dihubungkan.',
                    style: TextStyle(color: AdminColors.text, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 740;
              final infoFields = Column(
                children: [
                  TextField(
                    key: const Key('outlet-name'),
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama lokasi / gerai',
                    ),
                    onChanged: (_) => setState(() => _hasChanges = true),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _addressController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Alamat lengkap & catatan kurir',
                    ),
                    onChanged: (_) => setState(() => _hasChanges = true),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _latitudeController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Latitude GPS',
                          ),
                          onChanged: (_) => setState(() => _hasChanges = true),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _longitudeController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Longitude GPS',
                          ),
                          onChanged: (_) => setState(() => _hasChanges = true),
                        ),
                      ),
                    ],
                  ),
                ],
              );
              final scheduleFields = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _TimePickerField(
                          label: 'Jam buka',
                          value: _openTime,
                          onChanged: (value) => setState(() {
                            _openTime = value;
                            _hasChanges = true;
                          }),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _TimePickerField(
                          label: 'Jam tutup',
                          value: _closeTime,
                          onChanged: (value) => setState(() {
                            _closeTime = value;
                            _hasChanges = true;
                          }),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Hari operasional rutin',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 7),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final day in _days)
                        FilterChip(
                          label: Text(day.$1),
                          selected: _selectedDays.contains(day.$1),
                          onSelected: (selected) => setState(() {
                            if (selected) {
                              _selectedDays.add(day.$1);
                            } else {
                              _selectedDays.remove(day.$1);
                            }
                            _hasChanges = true;
                          }),
                        ),
                    ],
                  ),
                ],
              );

              return wide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: infoFields),
                        const SizedBox(width: 16),
                        Expanded(child: scheduleFields),
                      ],
                    )
                  : Column(
                      children: [
                        infoFields,
                        const SizedBox(height: 16),
                        scheduleFields,
                      ],
                    );
            },
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final publication = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Status publikasi website',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      _isPublic ? 'Aktif di website' : 'Tidak aktif (standby)',
                    ),
                    subtitle: const Text('Pelanggan dapat melihat gerai ini'),
                    value: _isPublic,
                    onChanged: (value) => setState(() {
                      _isPublic = value;
                      _hasChanges = true;
                    }),
                  ),
                ],
              );
              final emergency = SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  _isOpen ? 'Buka toko sekarang' : 'Tutup toko sementara',
                ),
                subtitle: const Text(
                  'Kontrol darurat untuk operasional hari ini',
                ),
                value: _isOpen,
                onChanged: (value) => setState(() {
                  _isOpen = value;
                  _hasChanges = true;
                }),
              );
              return constraints.maxWidth >= 740
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: publication),
                        const SizedBox(width: 20),
                        Expanded(child: emergency),
                      ],
                    )
                  : Column(children: [publication, emergency]);
            },
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Wrap(
              spacing: 8,
              children: [
                OutlinedButton(
                  onPressed: () => setState(_loadOutlet),
                  child: const Text('Reset'),
                ),
                FilledButton.icon(
                  key: const Key('save-outlet-configuration'),
                  onPressed: _saveOutlet,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Simpan Perubahan'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AdminColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          if (_hasChanges)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Ada perubahan yang belum disimpan.',
                style: TextStyle(color: AdminColors.primary, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  void _loadOutlet() {
    _nameController.text = _outlet.name;
    _addressController.text = _outlet.address;
    _latitudeController.text = _outlet.latitude;
    _longitudeController.text = _outlet.longitude;
    _openTime = _parseTime(_outlet.openTime);
    _closeTime = _parseTime(_outlet.closeTime);
    _isPublic = _outlet.isPublic;
    _isOpen = _outlet.isOpen;
    _hasChanges = false;
  }

  void _saveOutlet() {
    setState(() {
      _outlet
        ..name = _nameController.text.trim()
        ..address = _addressController.text.trim()
        ..latitude = _latitudeController.text.trim()
        ..longitude = _longitudeController.text.trim()
        ..openTime = _formatTime(_openTime)
        ..closeTime = _formatTime(_closeTime)
        ..isPublic = _isPublic
        ..isOpen = _isOpen;
      _hasChanges = false;
    });
    context.pop(_outlet);
  }

  static TimeOfDay _parseTime(String value) {
    final parts = value.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  static String _formatTime(TimeOfDay value) {
    return '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
  }
}

class _TimePickerField extends StatelessWidget {
  const _TimePickerField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final TimeOfDay value;
  final ValueChanged<TimeOfDay> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final selected = await showTimePicker(
          context: context,
          initialTime: value,
        );
        if (selected != null) onChanged(selected);
      },
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.access_time, size: 18),
        ),
        child: Text(value.format(context)),
      ),
    );
  }
}
