import 'package:material_ui/material_ui.dart';
import 'package:lapak_jajanan/core/router/app_router.dart';
import 'package:lapak_jajanan/core/theme/app_theme.dart';

class LapakJajananApp extends StatelessWidget {
  const LapakJajananApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Lapak Jajanan — Admin & Owner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}
