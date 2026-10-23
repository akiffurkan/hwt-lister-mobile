import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/localization_service.dart';
import '../theme/luxury_theme.dart';

class SettingsSheet extends StatelessWidget {
  final AppLocale appLocale;
  final bool isDark;
  final VoidCallback onToggleTheme;
  final String currentPath;
  final VoidCallback onPickFolder;

  const SettingsSheet({
    super.key,
    required this.appLocale,
    required this.isDark,
    required this.onToggleTheme,
    required this.currentPath,
    required this.onPickFolder,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appLocale,
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? LuxuryColors.darkSurface : LuxuryColors.lightSurface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: const Border(
              top: BorderSide(color: LuxuryColors.gold, width: 1.5),
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Üst Sürükleme Çubuğu
                  Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.black12,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Başlık
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.settings_outlined, color: LuxuryColors.gold, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        appLocale.t('settings'),
                        style: GoogleFonts.cinzel(
                          color: isDark ? LuxuryColors.goldLight : LuxuryColors.goldDark,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // DİL SEÇİMİ (Language Selection)
                  _buildSectionHeader(appLocale.t('language'), isDark),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? LuxuryColors.darkCard : LuxuryColors.lightCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? LuxuryColors.darkBorder : LuxuryColors.lightBorder,
                      ),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: AppLanguage.values.length,
                      separatorBuilder: (_, _) => Divider(
                        height: 1,
                        color: isDark ? Colors.white10 : Colors.black12,
                      ),
                      itemBuilder: (context, index) {
                        final lang = AppLanguage.values[index];
                        final isSelected = appLocale.current == lang;

                        return Material(
                          color: Colors.transparent,
                          child: ListTile(
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            leading: Text(
                              lang.flag,
                              style: const TextStyle(fontSize: 24),
                            ),
                            title: Text(
                              lang.nativeName,
                              style: GoogleFonts.montserrat(
                                color: isSelected ? LuxuryColors.gold : (isDark ? Colors.white : Colors.black87),
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              lang.englishName,
                              style: GoogleFonts.montserrat(
                                color: isDark ? Colors.white54 : Colors.black45,
                                fontSize: 11,
                              ),
                            ),
                            trailing: isSelected
                                ? const Icon(Icons.check_circle, color: LuxuryColors.gold, size: 22)
                                : Icon(Icons.circle_outlined, color: isDark ? Colors.white24 : Colors.black26, size: 22),
                            onTap: () {
                              appLocale.setLanguage(lang);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 22),

                  // TEMA SEÇİMİ
                  _buildSectionHeader(appLocale.t('theme'), isDark),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? LuxuryColors.darkCard : LuxuryColors.lightCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? LuxuryColors.darkBorder : LuxuryColors.lightBorder,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: ListTile(
                        leading: Icon(
                          isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                          color: LuxuryColors.gold,
                        ),
                        title: Text(
                          isDark ? appLocale.t('themeDark') : appLocale.t('themeLight'),
                          style: GoogleFonts.montserrat(
                            color: isDark ? Colors.white : Colors.black87,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: Switch(
                          value: isDark,
                          activeThumbColor: LuxuryColors.gold,
                          onChanged: (_) => onToggleTheme(),
                        ),
                        onTap: onToggleTheme,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),

                  // DEPOLAMA DİZİNİ & REHBER
                  _buildSectionHeader(appLocale.t('huaweiFolderHelp'), isDark),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? LuxuryColors.darkCard : LuxuryColors.lightCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? LuxuryColors.darkBorder : LuxuryColors.lightBorder,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appLocale.t('huaweiFolderHelpText'),
                          style: GoogleFonts.montserrat(
                            color: isDark ? Colors.white70 : Colors.black87,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isDark ? LuxuryColors.darkSurface : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isDark ? LuxuryColors.darkBorder : LuxuryColors.lightBorder,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.folder_outlined, color: LuxuryColors.gold, size: 16),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        currentPath,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.montserrat(
                                          color: isDark ? Colors.white : Colors.black87,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: LuxuryColors.gold),
                                foregroundColor: LuxuryColors.gold,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                onPickFolder();
                              },
                              child: const Icon(Icons.folder_open, size: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // UYGULAMA BİLGİSİ
                  _buildSectionHeader(appLocale.t('appInfo'), isDark),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isDark ? LuxuryColors.darkCard : LuxuryColors.lightCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? LuxuryColors.darkBorder : LuxuryColors.lightBorder,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              appLocale.t('versionLabel'),
                              style: GoogleFonts.montserrat(color: isDark ? Colors.white60 : Colors.black54, fontSize: 12),
                            ),
                            Text(
                              'v1.1.1 (Multilingual)',
                              style: GoogleFonts.montserrat(color: LuxuryColors.gold, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Divider(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              appLocale.t('developer'),
                              style: GoogleFonts.montserrat(color: isDark ? Colors.white60 : Colors.black54, fontSize: 12),
                            ),
                            Text(
                              'Akif Furkan EMİR',
                              style: GoogleFonts.montserrat(color: isDark ? Colors.white : Colors.black87, fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.cinzel(
          color: isDark ? LuxuryColors.goldLight : LuxuryColors.goldDark,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
