import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/localization_service.dart';
import '../theme/luxury_theme.dart';

class LanguageSheet extends StatelessWidget {
  final AppLocale appLocale;
  final bool isDark;

  const LanguageSheet({
    super.key,
    required this.appLocale,
    required this.isDark,
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Sürükleme Tutamacı
                  Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.black12,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Başlık & İkon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.language, color: LuxuryColors.gold, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        appLocale.t('language'),
                        style: GoogleFonts.cinzel(
                          color: isDark ? LuxuryColors.goldLight : LuxuryColors.goldDark,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Dil Seçenekleri Listesi
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? LuxuryColors.darkCard : LuxuryColors.lightCard,
                      borderRadius: BorderRadius.circular(16),
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
                          child: InkWell(
                            borderRadius: BorderRadius.vertical(
                              top: index == 0 ? const Radius.circular(16) : Radius.zero,
                              bottom: index == AppLanguage.values.length - 1
                                  ? const Radius.circular(16)
                                  : Radius.zero,
                            ),
                            onTap: () async {
                              await appLocale.setLanguage(lang);
                              if (context.mounted) {
                                await Future.delayed(const Duration(milliseconds: 220));
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  Text(
                                    lang.flag,
                                    style: const TextStyle(fontSize: 26),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          lang.nativeName,
                                          style: GoogleFonts.montserrat(
                                            color: isSelected
                                                ? LuxuryColors.gold
                                                : (isDark ? Colors.white : Colors.black87),
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          lang.englishName,
                                          style: GoogleFonts.montserrat(
                                            color: isDark ? Colors.white54 : Colors.black45,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    isSelected ? Icons.check_circle_rounded : Icons.radio_button_off_rounded,
                                    color: isSelected
                                        ? LuxuryColors.gold
                                        : (isDark ? Colors.white24 : Colors.black26),
                                    size: 22,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Kapat Butonu
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: isDark ? LuxuryColors.darkBorder : LuxuryColors.lightBorder,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        appLocale.t('close'),
                        style: GoogleFonts.montserrat(
                          color: isDark ? Colors.white70 : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
}
