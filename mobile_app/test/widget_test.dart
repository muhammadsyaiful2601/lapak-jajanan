import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lapak_jajanan/app.dart';

void main() {
  testWidgets('Scaffold aplikasi admin menampilkan dashboard', (tester) async {
    await tester.pumpWidget(const LapakJajananApp());

    expect(find.text('Lapak Jajanan'), findsWidgets);
    expect(find.text('Dashboard Admin'), findsOneWidget);
    expect(find.byIcon(Icons.point_of_sale_outlined), findsWidgets);
  });
}
