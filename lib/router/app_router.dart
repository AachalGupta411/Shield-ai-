import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';
import '../screens/alerts_screen.dart';
import '../screens/home_screen.dart';
import '../screens/landing_screen.dart';
import '../screens/login_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/scan_screen.dart';
import '../screens/sms_screen.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/mobile_shell.dart';

ScanTab _parseScanTab(String? tab) => switch (tab) {
      'sms' => ScanTab.sms,
      'upi' => ScanTab.upi,
      'phone' => ScanTab.phone,
      'link' => ScanTab.link,
      _ => ScanTab.qr,
    };

int _navIndex(String location) {
  if (location.startsWith('/scan')) return 1;
  if (location.startsWith('/sms')) return 2;
  if (location.startsWith('/alerts')) return 3;
  if (location.startsWith('/profile')) return 4;
  return 0;
}

GoRouter createRouter(AuthService auth) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: auth,
    redirect: (context, state) {
      if (auth.loading) return null;

      final loc = state.matchedLocation;
      final isAuth = auth.isAuthenticated;
      final isPublic = loc == '/' || loc == '/login';

      if (!isAuth && !isPublic) return '/login';
      if (isAuth && (loc == '/' || loc == '/login')) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, __) => const LandingScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      ShellRoute(
        builder: (context, state, child) {
          final index = _navIndex(state.matchedLocation);
          return MobileShell(
            bottomNavigationBar: AppBottomNav(currentIndex: index),
            child: child,
          );
        },
        routes: [
          GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
          GoRoute(
            path: '/scan',
            builder: (context, state) => ScanScreen(
              initialTab: _parseScanTab(state.uri.queryParameters['tab']),
            ),
          ),
          GoRoute(path: '/sms', builder: (_, __) => const SmsScreen()),
          GoRoute(path: '/alerts', builder: (_, __) => const AlertsScreen()),
          GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
        ],
      ),
    ],
  );
}
