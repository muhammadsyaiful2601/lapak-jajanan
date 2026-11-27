class Outlet {
  Outlet({
    required this.name,
    required this.branch,
    required this.address,
    required this.openTime,
    required this.closeTime,
    required this.latitude,
    required this.longitude,
    required this.isPublic,
    required this.isOpen,
  });

  String name;
  final String branch;
  String address;
  String openTime;
  String closeTime;
  String latitude;
  String longitude;
  bool isPublic;
  bool isOpen;

  Outlet copy() => Outlet(
    name: name,
    branch: branch,
    address: address,
    openTime: openTime,
    closeTime: closeTime,
    latitude: latitude,
    longitude: longitude,
    isPublic: isPublic,
    isOpen: isOpen,
  );
}

List<Outlet> createDemoOutlets() => [
  Outlet(
    name: 'Lokasi Utama',
    branch: 'Senja Tebet',
    address: 'Jl. Merdeka No. 12, Jakarta Selatan',
    openTime: '09:00',
    closeTime: '21:00',
    latitude: '-6.23841',
    longitude: '106.85292',
    isPublic: true,
    isOpen: true,
  ),
  Outlet(
    name: 'Pasar Kuliner',
    branch: 'Senja Pop-Up & Festival',
    address: 'Pasar Kuliner Blok B No. 5',
    openTime: '10:00',
    closeTime: '22:00',
    latitude: '-6.24011',
    longitude: '106.85832',
    isPublic: false,
    isOpen: false,
  ),
];
