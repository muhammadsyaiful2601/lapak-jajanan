import 'dart:typed_data';

class MenuAddonSetting {
  const MenuAddonSetting({
    required this.id,
    required this.name,
    required this.extraPrice,
    required this.isAvailableForMenu,
  });

  final String id;
  final String name;
  final int extraPrice;
  final bool isAvailableForMenu;

  MenuAddonSetting copyWith({
    String? name,
    int? extraPrice,
    bool? isAvailableForMenu,
  }) {
    return MenuAddonSetting(
      id: id,
      name: name ?? this.name,
      extraPrice: extraPrice ?? this.extraPrice,
      isAvailableForMenu: isAvailableForMenu ?? this.isAvailableForMenu,
    );
  }
}

class MenuOption {
  const MenuOption({
    required this.name,
    required this.price,
    required this.isFixedPrice,
    required this.isAvailable,
  });

  final String name;
  final int price;
  final bool isFixedPrice;
  final bool isAvailable;

  MenuOption copyWith({bool? isAvailable}) {
    return MenuOption(
      name: name,
      price: price,
      isFixedPrice: isFixedPrice,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}

class MenuVariationGroup {
  const MenuVariationGroup({required this.name, required this.options});

  final String name;
  final List<MenuOption> options;
}

class MenuChoiceGroup {
  const MenuChoiceGroup({
    required this.name,
    required this.isRequired,
    required this.minimumChoices,
    required this.maximumChoices,
    required this.options,
  });

  final String name;
  final bool isRequired;
  final int minimumChoices;
  final int maximumChoices;
  final List<MenuOption> options;
}

class MenuEntry {
  MenuEntry({
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.toppings,
    required this.addons,
    required this.variationGroups,
    required this.choiceGroups,
    this.imageBytes,
    this.imageName = '',
    this.isAvailable = true,
  });

  final String name;
  final String description;
  final String category;
  final int price;
  final String toppings;
  final Uint8List? imageBytes;
  final String imageName;
  bool isAvailable;
  final List<MenuAddonSetting> addons;
  final List<MenuVariationGroup> variationGroups;
  final List<MenuChoiceGroup> choiceGroups;

  MenuEntry copyForEditing() {
    return MenuEntry(
      name: name,
      description: description,
      category: category,
      price: price,
      toppings: toppings,
      imageBytes: imageBytes,
      imageName: imageName,
      isAvailable: isAvailable,
      addons: [for (final addon in addons) addon.copyWith()],
      variationGroups: [
        for (final group in variationGroups)
          MenuVariationGroup(
            name: group.name,
            options: [for (final option in group.options) option.copyWith()],
          ),
      ],
      choiceGroups: [
        for (final group in choiceGroups)
          MenuChoiceGroup(
            name: group.name,
            isRequired: group.isRequired,
            minimumChoices: group.minimumChoices,
            maximumChoices: group.maximumChoices,
            options: [for (final option in group.options) option.copyWith()],
          ),
      ],
    );
  }
}

List<MenuEntry> createPreviewMenus() => [
  MenuEntry(
    name: 'Pentol Kuah Pedas',
    description: 'Pentol kuah dengan sambal pedas khas lapak',
    category: 'Makanan Berat',
    price: 15000,
    toppings: 'Tetelan, Extra Pentol',
    addons: const [
      MenuAddonSetting(
        id: 'tetelan',
        name: 'Tetelan',
        extraPrice: 5000,
        isAvailableForMenu: true,
      ),
      MenuAddonSetting(
        id: 'extra-pentol',
        name: 'Extra Pentol',
        extraPrice: 4000,
        isAvailableForMenu: true,
      ),
    ],
    variationGroups: [
      MenuVariationGroup(
        name: 'Level Kepedasan',
        options: [
          for (var level = 0; level <= 5; level++)
            MenuOption(
              name: 'Level $level',
              price: 0,
              isFixedPrice: false,
              isAvailable: true,
            ),
        ],
      ),
    ],
    choiceGroups: const [],
  ),
  MenuEntry(
    name: 'Mie Ayam Bakso',
    description: 'Mie ayam dengan bakso homemade',
    category: 'Makanan Berat',
    price: 18000,
    toppings: 'Extra Bakso',
    addons: const [
      MenuAddonSetting(
        id: 'extra-bakso',
        name: 'Extra Bakso',
        extraPrice: 5000,
        isAvailableForMenu: true,
      ),
    ],
    variationGroups: const [
      MenuVariationGroup(
        name: 'Ukuran',
        options: [
          MenuOption(
            name: 'Regular',
            price: 0,
            isFixedPrice: false,
            isAvailable: true,
          ),
          MenuOption(
            name: 'Large',
            price: 5000,
            isFixedPrice: false,
            isAvailable: true,
          ),
        ],
      ),
    ],
    choiceGroups: const [],
  ),
  MenuEntry(
    name: 'Keripik Pisang',
    description: 'Keripik pisang renyah original',
    category: 'Camilan',
    price: 10000,
    toppings: '—',
    addons: const [],
    variationGroups: const [],
    choiceGroups: const [],
    isAvailable: false,
  ),
  MenuEntry(
    name: 'Es Teh Manis',
    description: 'Teh manis dingin',
    category: 'Minuman',
    price: 5000,
    toppings: 'Extra Gula',
    addons: const [
      MenuAddonSetting(
        id: 'extra-gula',
        name: 'Extra Gula',
        extraPrice: 0,
        isAvailableForMenu: true,
      ),
    ],
    variationGroups: const [],
    choiceGroups: const [],
  ),
  MenuEntry(
    name: 'Es Jeruk',
    description: 'Jeruk peras segar',
    category: 'Minuman',
    price: 7000,
    toppings: '—',
    addons: const [],
    variationGroups: const [],
    choiceGroups: const [],
  ),
];
