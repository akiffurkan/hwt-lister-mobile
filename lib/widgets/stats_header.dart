import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/localization_service.dart';
import '../theme/luxury_theme.dart';

class StatsHeader extends StatelessWidget {
  final int totalCount;
  final String totalSize;
  final String currentPath;
  final VoidCallback onRefresh;
  final VoidCallback onImport;
  final VoidCallback onPickFolder;
  final VoidCallback onOpenSettings;
  final AppLocale appLocale;
  final bool isDark;

  const StatsHeader({
    super.key,
    required this.totalCount,
    required this.totalSize,
    required this.currentPath,
    required this.onRefresh,
    required this.onImport,
    required this.onPickFolder,
    required this.onOpenSettings,
    required this.appLocale,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      decoration: BoxDecoration(
        color: isDark ? LuxuryColors.darkSurface : LuxuryColors.lightSurface,
        border: Border(
          bottom: BorderSide(
            color: isDark ? LuxuryColors.darkBorder : LuxuryColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Sol: Ayarlar & Dil Rozeti Butonu
              InkWell(
                onTap: onOpenSettings,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark ? LuxuryColors.darkCard : LuxuryColors.lightCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: LuxuryColors.gold.withValues(alpha: 0.5),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(appLocale.current.flag, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      const Icon(Icons.settings_outlined, color: LuxuryColors.gold, size: 18),
                    ],
                  ),
                ),
              ),
              // Orta: Lüks Logo & Başlık
              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.watch_outlined, color: LuxuryColors.gold, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        appLocale.t('appTitle'),
                        style: GoogleFonts.cinzel(
                          color: LuxuryColors.goldLight,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    appLocale.t('appSubtitle'),
                    style: GoogleFonts.montserrat(
                      color: LuxuryColors.gold.withValues(alpha: 0.75),
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.2,
                    ),
                  ),
                ],
              ),
              // Sağ: İçe Aktar ve Yenile Butonları
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.file_upload_outlined, color: LuxuryColors.gold, size: 22),
                    tooltip: appLocale.t('pickAndImport'),
                    onPressed: onImport,
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: LuxuryColors.gold, size: 22),
                    tooltip: appLocale.t('rescan'),
                    onPressed: onRefresh,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Dizin ve İstatistik Rozetleri
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildPill(
                icon: Icons.folder_special_outlined,
                label: currentPath.split('/').last,
                tooltip: currentPath,
                onTap: onPickFolder,
                isInteractive: true,
              ),
              _buildPill(
                icon: Icons.dashboard_customize_outlined,
                label: '$totalCount ${appLocale.t('itemsUnit')}',
              ),
              _buildPill(
                icon: Icons.data_usage_outlined,
                label: totalSize,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPill({
    required IconData icon,
    required String label,
    String? tooltip,
    VoidCallback? onTap,
    bool isInteractive = false,
  }) {
    final pill = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? LuxuryColors.darkCard : LuxuryColors.lightCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isInteractive ? LuxuryColors.gold : (isDark ? LuxuryColors.darkBorder : LuxuryColors.lightBorder),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: LuxuryColors.gold, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.montserrat(
              color: isDark ? Colors.white70 : Colors.black87,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (isInteractive) ...[
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, color: LuxuryColors.gold, size: 16),
          ],
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: tooltip != null ? Tooltip(message: tooltip, child: pill) : pill,
      );
    }

    return tooltip != null ? Tooltip(message: tooltip, child: pill) : pill;
  }
}
