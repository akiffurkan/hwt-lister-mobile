import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/watch_face.dart';
import '../theme/luxury_theme.dart';

class WatchCard extends StatelessWidget {
  final WatchFace watch;
  final VoidCallback onTap;
  final bool isDark;

  const WatchCard({
    super.key,
    required this.watch,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? LuxuryColors.darkCard : LuxuryColors.lightCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? LuxuryColors.darkBorder : LuxuryColors.lightBorder,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withValues(alpha: 0.4) : Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Dairesel Saat Önizleme Alanı
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 14, 12, 8),
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: LuxuryColors.gold.withValues(alpha: 0.85),
                          width: 2.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: LuxuryColors.gold.withValues(alpha: 0.2),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: watch.coverBytes != null
                            ? Image.memory(
                                watch.coverBytes!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => _buildPlaceholder(),
                              )
                            : _buildPlaceholder(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Başlık ve Bilgiler
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 12),
              child: Column(
                children: [
                  Text(
                    watch.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (watch.author.isNotEmpty) ...[
                    Text(
                      watch.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        color: LuxuryColors.gold,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                  ] else ...[
                    const SizedBox(height: 4),
                  ],
                  // Boyut ve Görsel Sayısı Rozeti
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDark ? LuxuryColors.darkSurface : Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isDark ? LuxuryColors.darkBorder : LuxuryColors.lightBorder,
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          watch.formattedSize,
                          style: GoogleFonts.montserrat(
                            color: isDark ? Colors.white70 : Colors.black87,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (watch.imageCount > 0) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: LuxuryColors.gold.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.image_outlined, color: LuxuryColors.gold, size: 10),
                              const SizedBox(width: 3),
                              Text(
                                '${watch.imageCount}',
                                style: GoogleFonts.montserrat(
                                  color: LuxuryColors.gold,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: isDark ? LuxuryColors.darkSurface : Colors.grey.shade200,
      child: Center(
        child: Icon(
          Icons.watch_outlined,
          color: LuxuryColors.gold.withValues(alpha: 0.5),
          size: 38,
        ),
      ),
    );
  }
}
