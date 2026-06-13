import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  static const _tabs = [
    _Tab(icon: Icons.home_outlined,          activeIcon: Icons.home_rounded,           label: 'الرئيسية', path: '/home'),
    _Tab(icon: Icons.credit_card_outlined,   activeIcon: Icons.credit_card_rounded,    label: 'البطاقات',  path: '/cards'),
    _Tab(icon: Icons.nfc_outlined,           activeIcon: Icons.nfc_rounded,            label: 'دفع NFC',  path: '/nfc-pay'),
    _Tab(icon: Icons.notifications_outlined, activeIcon: Icons.notifications_rounded,  label: 'إشعارات',  path: '/notifications'),
    _Tab(icon: Icons.person_outline,         activeIcon: Icons.person_rounded,         label: 'حسابي',    path: '/profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    return Scaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.glassLight,
              border: Border(top: BorderSide(color: AppColors.borderSubtle)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: _tabs.map((tab) {
                    final active = location == tab.path ||
                        (location == '/' && tab.path == '/home');
                    return _NavItem(tab: tab, active: active, onTap: () {
                      HapticFeedback.selectionClick();
                      context.go(tab.path);
                    });
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Tab {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String path;
  const _Tab({required this.icon, required this.activeIcon, required this.label, required this.path});
}

class _NavItem extends StatelessWidget {
  final _Tab tab;
  final bool active;
  final VoidCallback onTap;
  const _NavItem({required this.tab, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                active ? tab.activeIcon : tab.icon,
                key: ValueKey(active),
                color: active ? AppColors.textPrimary : AppColors.textDisabled,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                color: active ? AppColors.textPrimary : AppColors.textDisabled,
                fontFamily: 'Inter',
              ),
              child: Text(tab.label),
            ),
          ],
        ),
      ),
    );
  }
}
