import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/habits_screen.dart';
import '../screens/goals_screen.dart';
import '../screens/moods_screen.dart';
import '../screens/journal_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/community_screen.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final goRouterRefreshProvider = Provider<GoRouterRefreshStream>((ref) {
  final stream = ref.watch(authProvider.notifier).stream;
  final refresh = GoRouterRefreshStream(stream);
  ref.onDispose(refresh.dispose);
  return refresh;
});

final goRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);
  final refresh = ref.watch(goRouterRefreshProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refresh,
    redirect: (context, state) {
      final isAuth = auth.isAuthenticated;
      final isLoading = auth.isLoading;
      final goingToAuth = state.matchedLocation == '/login' || state.matchedLocation == '/register';
      if (state.matchedLocation == '/splash') {
        if (isLoading) return null;
        return isAuth ? '/' : '/login';
      }
      if (!isAuth && !goingToAuth) return '/login';
      if (isAuth && goingToAuth) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (_, __) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (_, __) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'habits',
            name: 'habits',
            builder: (_, __) => const HabitsScreen(),
          ),
          GoRoute(
            path: 'goals',
            name: 'goals',
            builder: (_, __) => const GoalsScreen(),
          ),
          GoRoute(
            path: 'moods',
            name: 'moods',
            builder: (_, __) => const MoodsScreen(),
          ),
          GoRoute(
            path: 'journal',
            name: 'journal',
            builder: (_, __) => const JournalScreen(),
          ),
          GoRoute(
            path: 'chat',
            name: 'chat',
            builder: (_, __) => const ChatScreen(),
          ),
          GoRoute(
            path: 'community',
            name: 'community',
            builder: (_, __) => const CommunityScreen(),
          ),
        ],
      ),
    ],
  );
});
