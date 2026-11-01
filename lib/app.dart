import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'router/app_router.dart';
import 'services/auth_service.dart';
import 'theme/app_theme.dart';

class ShieldAiApp extends StatefulWidget {
  const ShieldAiApp({super.key});

  @override
  State<ShieldAiApp> createState() => _ShieldAiAppState();
}

class _ShieldAiAppState extends State<ShieldAiApp> {
  late final AuthService _auth;
  late final _router = createRouter(_auth);

  @override
  void initState() {
    super.initState();
    _auth = AuthService()..init();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _auth,
      child: MaterialApp.router(
        title: 'ShieldAI',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        routerConfig: _router,
      ),
    );
  }
}
