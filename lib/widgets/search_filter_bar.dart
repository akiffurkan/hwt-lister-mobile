import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/localization_service.dart';
import '../theme/luxury_theme.dart';

enum SortOption {
  nameAsc,
  nameDesc,
  sizeDesc,
  sizeAsc,
  dateDesc,
  dateAsc,
}

class SearchFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final SortOption currentSort;
  final ValueChanged<SortOption> onSortChanged;
  final AppLocale appLocale;
  final bool isDark;

  const SearchFilterBar({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.currentSort,
    required this.onSortChanged,
    required this.appLocale,
    required this.isDark,
  });

  String _getSortLabel(SortOption option) {
    switch (option) {
      case SortOption.nameAsc:
        return appLocale.t('sortNameAsc');
      case SortOption.nameDesc:
        return appLocale.t('sortNameDesc');
      case SortOption.sizeDesc:
        return appLocale.t('sortSizeDesc');
      case SortOption.sizeAsc:
        return appLocale.t('sortSizeAsc');
      case SortOption.dateDesc:
        return appLocale.t('sortDateDesc');
      case SortOption.dateAsc:
        return appLocale.t('sortDateAsc');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Arama Kutusu
          Expanded(
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: isDark ? LuxuryColors.darkCard : LuxuryColors.lightCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? LuxuryColors.darkBorder : LuxuryColors.lightBorder,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: searchController,
                onChanged: onSearchChanged,
                style: GoogleFonts.montserrat(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 13,
                ),
                decoration: InputDecoration(
                  hintText: appLocale.t('searchHint'),
                  hintStyle: GoogleFonts.montserrat(
                    color: isDark ? Colors.white38 : Colors.black38,
                    fontSize: 12,
                  ),
                  prefixIcon: const Icon(Icons.search, color: LuxuryColors.gold, size: 18),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 16, color: Colors.grey),
                          onPressed: () {
                            searchController.clear();
                            onSearchChanged('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Sıralama Butonu
          Container(
            height: 42,
            decoration: BoxDecoration(
              color: isDark ? LuxuryColors.darkCard : LuxuryColors.lightCard,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: LuxuryColors.gold.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: PopupMenuButton<SortOption>(
              icon: const Icon(Icons.sort_rounded, color: LuxuryColors.gold, size: 20),
              tooltip: appLocale.t('sortTooltip'),
              color: isDark ? LuxuryColors.darkSurface : LuxuryColors.lightSurface,
              onSelected: onSortChanged,
              itemBuilder: (context) => SortOption.values.map((option) {
                final isSelected = option == currentSort;
                return PopupMenuItem<SortOption>(
                  value: option,
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                        color: isSelected ? LuxuryColors.gold : Colors.grey,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getSortLabel(option),
                        style: GoogleFonts.montserrat(
                          color: isSelected ? LuxuryColors.gold : (isDark ? Colors.white70 : Colors.black87),
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
