import 'package:flutter/material.dart';
import 'core/api.dart';
import 'core/theme.dart';
import 'core/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Api.loadToken();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'Recupera tu Voz',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    routerConfig: router,
  );
}
