import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:lapak_jajanan/features/admin/outlet_model.dart';
import 'package:lapak_jajanan/features/shared/widgets/admin_widgets.dart';

class LocationsPage extends StatefulWidget {
  const LocationsPage({super.key});

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  final List<Outlet> _outlets = createDemoOutlets();
  late Outlet _selectedOutlet = _outlets.first;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(22),
      children: [
        AdminPageTitle(
          eyebrow: 'Outlet & konfigurasi',
          title: 'Pengelolaan Lokasi & Jam Operasional',
          description: 'Atur jam buka, status layanan, dan informasi gerai yang terlihat pelanggan.',
          action: FilledButton.icon(
            key: const Key('configure-selected-outlet'),
            onPressed: () => _configureOutlet(_selectedOutlet),
            icon: const Icon(Icons.tune),
            label: const Text('Konfigurasi Gerai'),
          ),
        ),
        Card(
          color: AdminColors.primary,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                const Icon(Icons.public, color: Colors.white, size: 26),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_selectedOutlet.branch} (${_selectedOutlet.name})',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _selectedOutlet.isPublic
                            ? 'Lokasi ini tampil di website pelanggan dan menerima pesanan.'
                            : 'Lokasi ini disembunyikan dari website pelanggan.',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                AdminStatusPill(
                  label: _selectedOutlet.isPublic ? 'Publik aktif' : 'Standby',
                  isActive: _selectedOutlet.isPublic,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final outletCards = Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                for (final outlet in _outlets)
                  SizedBox(
                    width: constraints.maxWidth >= 760
                        ? (constraints.maxWidth - 14) / 2
                        : constraints.maxWidth,
                    child: _OutletCard(
                      outlet: outlet,
                      onConfigure: () => _configureOutlet(outlet),
                      onOpenChanged: (value) => _toggleOutlet(outlet, value),
                    ),
                  ),
              ],
            );
            return Column(
              children: [
                outletCards,
                const SizedBox(height: 16),
                _buildMapPreview(),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildMapPreview() {
    return AdminSectionCard(
      title: 'Peta cakupan gerai & radius pesanan',
      subtitle: 'Pratinjau lokasi operasional yang dipilih',
      child: Container(
        height: 190,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFEDEBE4),
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            colors: [Color(0xFFE7E6DB), Color(0xFFF4F1E9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 30,
              right: 30,
              top: 52,
              child: Container(height: 2, color: Colors.white),
            ),
            Positioned(
              left: 70,
              right: 70,
              bottom: 56,
              child: Transform.rotate(
                angle: -0.15,
                child: Container(height: 2, color: Colors.white),
              ),
            ),
            Positioned(
              left: 140,
              top: 12,
              bottom: 10,
              child: Container(width: 2, color: Colors.white),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: AdminColors.primary,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.storefront_outlined,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    _selectedOutlet.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 14,
              bottom: 12,
              child: Text(
                'Koordinat: ${_selectedOutlet.latitude}, ${_selectedOutlet.longitude}',
                style: const TextStyle(color: AdminColors.muted, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _configureOutlet(Outlet outlet) async {
    final updatedOutlet = await context.push<Outlet>(
      '/admin/locations/configure',
      extra: outlet,
    );
    if (!mounted || updatedOutlet == null) return;
    setState(() {
      final index = _outlets.indexOf(outlet);
      _outlets[index] = updatedOutlet;
      _selectedOutlet = updatedOutlet;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pengaturan gerai disimpan di preview lokal.'),
      ),
    );
  }

  void _toggleOutlet(Outlet outlet, bool isOpen) {
    setState(() {
      outlet.isOpen = isOpen;
    });
  }
}

class _OutletCard extends StatelessWidget {
  const _OutletCard({
    required this.outlet,
    required this.onConfigure,
    required this.onOpenChanged,
  });

  final Outlet outlet;
  final VoidCallback onConfigure;
  final ValueChanged<bool> onOpenChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AdminColors.soft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.storefront_outlined,
                    color: AdminColors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        outlet.name,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      Text(
                        outlet.branch,
                        style: const TextStyle(
                          color: AdminColors.muted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                AdminStatusPill(
                  label: outlet.isPublic ? 'Aktif publik' : 'Standby',
                  isActive: outlet.isPublic,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 100,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFF0EDE7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.map_outlined,
                size: 34,
                color: AdminColors.muted,
              ),
            ),
            const SizedBox(height: 12),
            Text(outlet.address, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 9),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 6,
              runSpacing: 8,
              children: [
                const Icon(
                  Icons.schedule_outlined,
                  size: 16,
                  color: AdminColors.muted,
                ),
                Text('${outlet.openTime} – ${outlet.closeTime} WIB'),
                AdminStatusPill(
                  label: outlet.isOpen ? 'Buka' : 'Tutup',
                  isActive: outlet.isOpen,
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onConfigure,
                    icon: const Icon(Icons.tune_outlined),
                    label: const Text('Atur konfigurasi'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: () => onOpenChanged(!outlet.isOpen),
                    style: FilledButton.styleFrom(
                      backgroundColor: outlet.isOpen
                          ? AdminColors.green
                          : AdminColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(outlet.isOpen ? 'Tutup Gerai' : 'Buka Gerai'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
