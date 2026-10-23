import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'services/localization_service.dart';
import 'theme/luxury_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: LuxuryColors.darkBg,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const HwtListerApp());
}

class HwtListerApp extends StatefulWidget {
  const HwtListerApp({super.key});

  @override
  State<HwtListerApp> createState() => _HwtListerAppState();
}

class _HwtListerAppState extends State<HwtListerApp> {
  final AppLocale _appLocale = AppLocale();
  bool _isDark = true;

  @override
  void initState() {
    super.initState();
    _loadThemePref();
  }

  Future<void> _loadThemePref() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedDark = prefs.getBool('is_dark_theme');
      if (savedDark != null && mounted) {
        setState(() {
          _isDark = savedDark;
        });
      }
    } catch (_) {}
  }

  Future<void> _toggleTheme() async {
    setState(() {
      _isDark = !_isDark;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_dark_theme', _isDark);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _appLocale,
      builder: (context, _) {
        return MaterialApp(
          title: 'HWT Lister - Haute Horlogerie',
          debugShowCheckedModeBanner: false,
          theme: LuxuryTheme.lightTheme,
          darkTheme: LuxuryTheme.darkTheme,
          themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
          locale: _appLocale.locale,
          supportedLocales: AppLanguage.values.map((l) => l.code).map((c) => Locale(c)).toList(),
          home: HomeScreen(
            appLocale: _appLocale,
            onToggleTheme: _toggleTheme,
            isDark: _isDark,
          ),
        );
      },
    );
  }
}
