import 'package:go_router/go_router.dart';
import '../features/splash/presentation/screens/splash_screen.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/otp_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/wallet/presentation/screens/send_screen.dart';
import '../features/wallet/presentation/screens/receive_screen.dart';
import '../features/nfc/presentation/screens/nfc_pay_screen.dart';
import '../features/cards/presentation/screens/cards_screen.dart';
import '../features/notifications/presentation/screens/notifications_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/home/presentation/screens/main_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash',       builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/onboarding',   builder: (_, __) => const OnboardingScreen()),
    GoRoute(path: '/login',        builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/register',     builder: (_, __) => const RegisterScreen()),
    GoRoute(path: '/otp',          builder: (_, s) => OtpScreen(phone: s.uri.queryParameters['phone'] ?? '')),
    ShellRoute(
      builder: (_, __, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/home',          builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/send',          builder: (_, __) => const SendScreen()),
        GoRoute(path: '/receive',       builder: (_, __) => const ReceiveScreen()),
        GoRoute(path: '/nfc-pay',       builder: (_, __) => const NfcPayScreen()),
        GoRoute(path: '/cards',         builder: (_, __) => const CardsScreen()),
        GoRoute(path: '/notifications', builder: (_, __) => const NotificationsScreen()),
        GoRoute(path: '/profile',       builder: (_, __) => const ProfileScreen()),
      ],
    ),
  ],
);
