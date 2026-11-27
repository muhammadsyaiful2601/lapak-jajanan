class DailySalesData {
  final String dayLabel;
  final String fullDate;
  final double grossMillion;
  final double netMillion;
  final int transactions;
  final int itemsSold;
  final String aov;
  final String discount;
  final String pb1;
  final String grossFormatted;
  final String netFormatted;
  final bool isPeak;
  final bool isToday;

  const DailySalesData({
    required this.dayLabel,
    required this.fullDate,
    required this.grossMillion,
    required this.netMillion,
    required this.transactions,
    required this.itemsSold,
    required this.aov,
    required this.discount,
    required this.pb1,
    required this.grossFormatted,
    required this.netFormatted,
    this.isPeak = false,
    this.isToday = false,
  });
}

class OrderItemDetail {
  final String name;
  final String price;
  final List<String> notes;

  const OrderItemDetail({
    required this.name,
    required this.price,
    required this.notes,
  });
}

class TransactionRecord {
  final String id;
  final String terminalInfo;
  final String time;
  final String outlet;
  final String customer;
  final String subCustomer;
  final String orderType;
  final String paymentMethod;
  final String total;
  final String status;
  final String cashier;
  final String gatewayRef;
  final String settledTime;
  final String specialNote;
  final String subtotal;
  final String pb1;
  final List<OrderItemDetail> items;

  const TransactionRecord({
    required this.id,
    required this.terminalInfo,
    required this.time,
    required this.outlet,
    required this.customer,
    required this.subCustomer,
    required this.orderType,
    required this.paymentMethod,
    required this.total,
    required this.status,
    this.cashier = 'Bambang I. (KSR-01)',
    this.gatewayRef = 'NMD-984320914820',
    this.settledTime = '24 Okt 2023, 21:33:12 WIB',
    this.specialNote = 'Kuah bakmie dipisah, sambal lapak jajan ekstra satu porsi.',
    this.subtotal = 'Rp 81.000',
    this.pb1 = 'Rp 8.100',
    this.items = const [],
  });
}

class TopMenuItem {
  final int rank;
  final String name;
  final String subtitle;
  final String revenue;
  final String growth;
  final bool isPositiveHighlight;

  const TopMenuItem({
    required this.rank,
    required this.name,
    required this.subtitle,
    required this.revenue,
    required this.growth,
    this.isPositiveHighlight = true,
  });
}

class MockAnalyticsRepository {
  static const List<DailySalesData> weeklySales = [
    DailySalesData(
      dayLabel: 'Rab 18',
      fullDate: 'Rabu, 18 Okt 2023',
      grossMillion: 5.60,
      netMillion: 5.04,
      transactions: 165,
      itemsSold: 451,
      aov: 'Rp 33.939',
      discount: '-Rp 150.000',
      pb1: 'Rp 560.000',
      grossFormatted: 'Rp 5.600.000',
      netFormatted: 'Rp 5.040.000',
    ),
    DailySalesData(
      dayLabel: 'Kam 19',
      fullDate: 'Kamis, 19 Okt 2023',
      grossMillion: 5.90,
      netMillion: 5.31,
      transactions: 172,
      itemsSold: 464,
      aov: 'Rp 34.302',
      discount: '-Rp 160.000',
      pb1: 'Rp 590.000',
      grossFormatted: 'Rp 5.900.000',
      netFormatted: 'Rp 5.310.000',
    ),
    DailySalesData(
      dayLabel: 'Jum 20',
      fullDate: 'Jumat, 20 Okt 2023',
      grossMillion: 7.10,
      netMillion: 6.39,
      transactions: 208,
      itemsSold: 560,
      aov: 'Rp 34.134',
      discount: '-Rp 240.000',
      pb1: 'Rp 710.000',
      grossFormatted: 'Rp 7.100.000',
      netFormatted: 'Rp 6.390.000',
    ),
    DailySalesData(
      dayLabel: 'Sab 21',
      fullDate: 'Sabtu, 21 Okt 2023',
      grossMillion: 8.42,
      netMillion: 7.58,
      transactions: 247,
      itemsSold: 672,
      aov: 'Rp 34.089',
      discount: '-Rp 340.000',
      pb1: 'Rp 842.000',
      grossFormatted: 'Rp 8.420.000',
      netFormatted: 'Rp 7.578.000',
      isPeak: true,
    ),
    DailySalesData(
      dayLabel: 'Min 22',
      fullDate: 'Minggu, 22 Okt 2023',
      grossMillion: 7.80,
      netMillion: 7.02,
      transactions: 228,
      itemsSold: 615,
      aov: 'Rp 34.210',
      discount: '-Rp 310.000',
      pb1: 'Rp 780.000',
      grossFormatted: 'Rp 7.800.000',
      netFormatted: 'Rp 7.020.000',
    ),
    DailySalesData(
      dayLabel: 'Sen 23',
      fullDate: 'Senin, 23 Okt 2023',
      grossMillion: 6.80,
      netMillion: 6.12,
      transactions: 199,
      itemsSold: 538,
      aov: 'Rp 34.170',
      discount: '-Rp 180.000',
      pb1: 'Rp 680.000',
      grossFormatted: 'Rp 6.800.000',
      netFormatted: 'Rp 6.120.000',
    ),
    DailySalesData(
      dayLabel: 'Sel 24',
      fullDate: 'Selasa, 24 Okt 2023',
      grossMillion: 7.13,
      netMillion: 6.42,
      transactions: 209,
      itemsSold: 564,
      aov: 'Rp 34.114',
      discount: '-Rp 210.000',
      pb1: 'Rp 713.000',
      grossFormatted: 'Rp 7.130.000',
      netFormatted: 'Rp 6.417.000',
      isToday: true,
    ),
  ];

  static const List<TopMenuItem> topMenus = [
    TopMenuItem(
      rank: 1,
      name: 'Bakmie Spesial Komplit',
      subtitle: '742 porsi terjual • Kontribusi 42.6% makanan',
      revenue: 'Rp 20.776.000',
      growth: '+18.4% pesat',
    ),
    TopMenuItem(
      rank: 2,
      name: 'Dimsum Mentai Bakar (4 Pcs)',
      subtitle: '586 porsi terjual • Favorit camilan sore',
      revenue: 'Rp 11.720.000',
      growth: '+11.2% stabil',
    ),
    TopMenuItem(
      rank: 3,
      name: 'Es Kopi Susu Lapak Aren',
      subtitle: '512 cup terjual • Minuman signature #1',
      revenue: 'Rp 9.216.000',
      growth: '+9.8%',
    ),
    TopMenuItem(
      rank: 4,
      name: 'Telur Gulung Mozzarella',
      subtitle: '438 porsi terjual • Jajanan nostalgia terpopuler',
      revenue: 'Rp 6.132.000',
      growth: '+4.1%',
      isPositiveHighlight: false,
    ),
    TopMenuItem(
      rank: 5,
      name: 'Dimsum Goreng Krispi',
      subtitle: '324 porsi terjual • Tambahan favorit',
      revenue: 'Rp 5.184.000',
      growth: '+3.5%',
      isPositiveHighlight: false,
    ),
  ];

  static const List<TransactionRecord> transactions = [
    TransactionRecord(
      id: '#TRX-20231024-0089',
      terminalInfo: 'POS Terminal 01',
      time: '24 Okt 2023, 21:32',
      outlet: 'Senja Tebet',
      customer: 'Aditia Pratama',
      subCustomer: 'Meja 03',
      orderType: 'Dine-in POS',
      paymentMethod: 'QRIS Dinamis',
      total: 'Rp 89.100',
      status: 'Selesai',
      subtotal: 'Rp 81.000',
      pb1: 'Rp 8.100',
      items: [
        OrderItemDetail(
          name: '1x Bakmie Spesial Komplit',
          price: 'Rp 31.000',
          notes: ['Variasi: Mie Karet, Level 1 Pedas', '+Ekstra Saus Mentai Torched (+Rp 3.000)'],
        ),
        OrderItemDetail(
          name: '1x Dimsum Mentai Bakar (4 Pcs)',
          price: 'Rp 24.000',
          notes: ['+Taburan Keju Mozzarella Melt (+Rp 4.000)'],
        ),
        OrderItemDetail(
          name: '2x Es Kopi Susu Lapak Jajan Aren',
          price: 'Rp 36.000',
          notes: ['@Rp 18.000 | Less Sugar 50%, Normal Ice'],
        ),
      ],
    ),
    TransactionRecord(
      id: '#KD-5082',
      terminalInfo: 'Online Delivery',
      time: '24 Okt 2023, 21:26',
      outlet: 'Pasar Kuliner',
      customer: 'Dian Sastrowidjoyo',
      subCustomer: 'GrabExpress ID: 8940',
      orderType: 'Delivery',
      paymentMethod: 'ShopeePay',
      total: 'Rp 42.000',
      status: 'Selesai',
      subtotal: 'Rp 38.182',
      pb1: 'Rp 3.818',
      specialNote: 'Tolong sertakan sendok plastik dan tisu.',
      items: [
        OrderItemDetail(
          name: '2x Dimsum Mentai Bakar (4 Pcs)',
          price: 'Rp 42.000',
          notes: ['Saus mentai pedas sedang'],
        ),
      ],
    ),
    TransactionRecord(
      id: '#KD-5081',
      terminalInfo: 'Online Pickup',
      time: '24 Okt 2023, 21:18',
      outlet: 'Senja Tebet',
      customer: 'Rizky Ramadhan',
      subCustomer: 'Ambil Mandiri (Counter)',
      orderType: 'Pickup',
      paymentMethod: 'QRIS BCA',
      total: 'Rp 114.500',
      status: 'Selesai',
      subtotal: 'Rp 104.090',
      pb1: 'Rp 10.410',
      specialNote: 'Diambil jam 21:30 tepat.',
      items: [
        OrderItemDetail(
          name: '3x Bakmie Spesial Komplit',
          price: 'Rp 84.000',
          notes: ['1 Tidak pedas, 2 Pedas sedang'],
        ),
        OrderItemDetail(
          name: '2x Telur Gulung Mozzarella',
          price: 'Rp 30.500',
          notes: ['Saus sambal dipisah'],
        ),
      ],
    ),
    TransactionRecord(
      id: '#TRX-20231024-0088',
      terminalInfo: 'POS Terminal 02',
      time: '24 Okt 2023, 21:05',
      outlet: 'Pasar Kuliner',
      customer: 'Walk-in (Kasir)',
      subCustomer: 'Takeaway Direct',
      orderType: 'Walk-in POS',
      paymentMethod: 'Tunai Kasir',
      total: 'Rp 68.000',
      status: 'Selesai',
      subtotal: 'Rp 61.818',
      pb1: 'Rp 6.182',
      items: [
        OrderItemDetail(
          name: '2x Bakmie Spesial Komplit',
          price: 'Rp 56.000',
          notes: ['Bungkus rapi'],
        ),
        OrderItemDetail(
          name: '1x Es Teh Manis',
          price: 'Rp 12.000',
          notes: ['Es normal'],
        ),
      ],
    ),
    TransactionRecord(
      id: '#TRX-20231024-0086',
      terminalInfo: 'Dibatalkan Kasir',
      time: '24 Okt 2023, 20:15',
      outlet: 'Pasar Kuliner',
      customer: 'Walk-in',
      subCustomer: 'Salah Input Menu',
      orderType: 'Walk-in POS',
      paymentMethod: 'Void',
      total: 'Rp 28.000',
      status: 'Dibatalkan',
      subtotal: 'Rp 25.455',
      pb1: 'Rp 2.545',
      specialNote: 'Dibatalkan supervisor karena kasir salah pilih varian.',
      items: [
        OrderItemDetail(
          name: '1x Bakmie Spesial Komplit',
          price: 'Rp 28.000',
          notes: ['Voided'],
        ),
      ],
    ),
  ];
}