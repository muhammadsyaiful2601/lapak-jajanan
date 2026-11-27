import 'package:material_ui/material_ui.dart';

String rp(int value) {
  final digits = value.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return '${value < 0 ? '-' : ''}Rp$buffer';
}

class Topping {
  final String name;
  final int price;
  const Topping(this.name, this.price);
}

class MenuItem {
  final String id, name, desc, category;
  final int price;
  final bool available;
  final String? badge;
  final IconData icon;
  final List<Topping> toppings;
  const MenuItem({
    required this.id,
    required this.name,
    required this.desc,
    required this.category,
    required this.price,
    required this.icon,
    this.available = true,
    this.badge,
    this.toppings = const [],
  });
}

class CartLine {
  final MenuItem item;
  int qty;
  final List<Topping> toppings;
  final String note;
  CartLine(this.item, this.qty, this.toppings, this.note);

  int get unitPrice => item.price + toppings.fold(0, (s, t) => s + t.price);
  int get total => unitPrice * qty;
  String get key =>
      '${item.id}|${(toppings.map((t) => t.name).toList()..sort()).join(',')}|$note';
}

const kMenu = <MenuItem>[
  MenuItem(
    id: 'dms-001',
    name: 'Dimsum Mentai',
    category: 'Dimsum',
    price: 20000,
    desc: 'Topping saus mentai bakar gurih & nori',
    icon: Icons.lunch_dining,
    badge: 'Isi 4 pcs',
    toppings: [
      Topping('Ekstra Saus Mentai', 3000),
      Topping('Keju Mozzarella', 4000),
    ],
  ),
  MenuItem(
    id: 'dms-002',
    name: 'Dimsum Goreng Krispi',
    category: 'Dimsum',
    price: 16000,
    desc: 'Kulit renyah golden dip mayo pedas',
    icon: Icons.lunch_dining,
    available: false,
  ),
  MenuItem(
    id: 'tlg-003',
    name: 'Telur Gulung Mozza',
    category: 'Telur Gulung',
    price: 14000,
    desc: 'Keju leleh lumer dengan bumbu balado',
    icon: Icons.kebab_dining,
    badge: 'Isi 5 tusuk',
  ),
  MenuItem(
    id: 'tlg-001',
    name: 'Telur Gulung Original',
    category: 'Telur Gulung',
    price: 10000,
    desc: 'Telur gulung gurih klasik jajanan sore',
    icon: Icons.kebab_dining,
  ),
  MenuItem(
    id: 'bkm-001',
    name: 'Bakmie Spesial Komplit',
    category: 'Bakmie',
    price: 28000,
    desc: 'Ayam cincang manis, jamur & pangsit',
    icon: Icons.ramen_dining,
    badge: 'Chef Pick',
    toppings: [
      Topping('Ekstra Saus Mentai Torched', 3000),
      Topping('Taburan Keju Mozzarella', 4000),
      Topping('Chili Oil Lapak Jajan', 2500),
    ],
  ),
  MenuItem(
    id: 'bkm-003',
    name: 'Bakmie Yamin Manis',
    category: 'Bakmie',
    price: 26000,
    desc: 'Ayam cincang kecap, mie halus',
    icon: Icons.ramen_dining,
    available: false,
  ),
  MenuItem(
    id: 'drk-001',
    name: 'Es Kopi Susu Aren',
    category: 'Minuman',
    price: 18000,
    desc: 'Espresso robusta & arabika, susu, aren',
    icon: Icons.local_cafe,
    badge: 'Signature',
  ),
  MenuItem(
    id: 'drk-002',
    name: 'Es Teh Manis Jasmine',
    category: 'Minuman',
    price: 5000,
    desc: 'Seduhan teh melati wangi, manis seimbang',
    icon: Icons.emoji_food_beverage,
    badge: 'Jasmine',
  ),
];

const kCategories = [
  'Semua Menu',
  'Dimsum',
  'Telur Gulung',
  'Bakmie',
  'Minuman',
];
const kTaxRate = 0.10; // PB1 10%
