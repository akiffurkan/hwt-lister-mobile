import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/watch_face.dart';
import '../services/hwt_service.dart';
import '../services/storage_service.dart';
import '../theme/luxury_theme.dart';
import '../widgets/search_filter_bar.dart';
import '../widgets/stats_header.dart';
import '../widgets/watch_card.dart';
import '../widgets/watch_detail_sheet.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDark;

  const HomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDark,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<WatchFace> _allWatches = [];
  List<WatchFace> _filteredWatches = [];
  bool _isLoading = true;
  String _statusMessage = 'Huawei klasörü taranıyor...';
  String _currentPath = StorageService.androidPrimaryHuaweiPath;
  SortOption _currentSort = SortOption.nameAsc;
  int _totalBytes = 0;

  @override
  void initState() {
    super.initState();
    _initAndLoad();
  }

  Future<void> _initAndLoad({String? customPath}) async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'İzinler kontrol ediliyor...';
    });

    await StorageService.requestPermissions();

    setState(() {
      _statusMessage = 'Huawei klasörü taranıyor...';
    });

    final files = await StorageService.scanHwtFiles(customDirectoryPath: customPath);

    if (customPath != null) {
      _currentPath = customPath;
    }

    final loadedWatches = <WatchFace>[];
    int totalBytes = 0;

    for (int i = 0; i < files.length; i++) {
      final file = files[i];
      if (mounted) {
        setState(() {
          _statusMessage = 'Kadran ayrıştırılıyor (${i + 1}/${files.length})...';
        });
      }
      final parsed = await HwtService.parseHwtFile(file);
      if (parsed != null) {
        loadedWatches.add(parsed);
        totalBytes += parsed.fileSizeBytes;
      }
    }

    if (mounted) {
      setState(() {
        _allWatches = loadedWatches;
        _totalBytes = totalBytes;
        _isLoading = false;
        _applyFilterAndSort();
      });
    }
  }

  void _applyFilterAndSort() {
    final query = _searchController.text.trim().toLowerCase();
    var list = _allWatches.where((w) {
      if (query.isEmpty) return true;
      return w.displayName.toLowerCase().contains(query) ||
          w.author.toLowerCase().contains(query) ||
          w.description.toLowerCase().contains(query) ||
          w.fileName.toLowerCase().contains(query);
    }).toList();

    switch (_currentSort) {
      case SortOption.nameAsc:
        list.sort((a, b) => a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()));
        break;
      case SortOption.nameDesc:
        list.sort((a, b) => b.displayName.toLowerCase().compareTo(a.displayName.toLowerCase()));
        break;
      case SortOption.sizeDesc:
        list.sort((a, b) => b.fileSizeBytes.compareTo(a.fileSizeBytes));
        break;
      case SortOption.sizeAsc:
        list.sort((a, b) => a.fileSizeBytes.compareTo(b.fileSizeBytes));
        break;
      case SortOption.dateDesc:
        list.sort((a, b) => b.modifiedDate.compareTo(a.modifiedDate));
        break;
      case SortOption.dateAsc:
        list.sort((a, b) => a.modifiedDate.compareTo(b.modifiedDate));
        break;
    }

    setState(() {
      _filteredWatches = list;
    });
  }

  Future<void> _handleImport() async {
    final imported = await StorageService.pickAndImportHwtFiles();
    if (imported.isNotEmpty && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: LuxuryColors.darkCard,
          content: Text(
            '${imported.length} kadran Huawei klasörüne aktarıldı!',
            style: GoogleFonts.montserrat(color: LuxuryColors.goldLight),
          ),
        ),
      );
      _initAndLoad();
    }
  }

  Future<void> _handlePickFolder() async {
    final pickedPath = await StorageService.pickCustomDirectory();
    if (pickedPath != null && mounted) {
      _initAndLoad(customPath: pickedPath);
    }
  }

  void _openDetails(WatchFace watch) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WatchDetailSheet(watch: watch, isDark: widget.isDark),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            StatsHeader(
              totalCount: _allWatches.length,
              totalSize: HwtService.formatBytes(_totalBytes),
              currentPath: _currentPath,
              onRefresh: () => _initAndLoad(),
              onImport: _handleImport,
              onPickFolder: _handlePickFolder,
              onToggleTheme: widget.onToggleTheme,
              isDark: isDark,
            ),
            SearchFilterBar(
              searchController: _searchController,
              onSearchChanged: (_) => _applyFilterAndSort(),
              currentSort: _currentSort,
              onSortChanged: (sort) {
                setState(() {
                  _currentSort = sort;
                  _applyFilterAndSort();
                });
              },
              isDark: isDark,
            ),
            Expanded(
              child: _isLoading
                  ? _buildLoadingState(isDark)
                  : (_filteredWatches.isEmpty
                      ? _buildEmptyState(isDark)
                      : RefreshIndicator(
                          color: LuxuryColors.gold,
                          backgroundColor: isDark ? LuxuryColors.darkSurface : Colors.white,
                          onRefresh: () => _initAndLoad(),
                          child: GridView.builder(
                            padding: const EdgeInsets.fromLTRB(14, 6, 14, 24),
                            itemCount: _filteredWatches.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.78,
                            ),
                            itemBuilder: (context, index) {
                              final watch = _filteredWatches[index];
                              return WatchCard(
                                watch: watch,
                                isDark: isDark,
                                onTap: () => _openDetails(watch),
                              );
                            },
                          ),
                        )),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: LuxuryColors.gold,
        foregroundColor: Colors.black,
        elevation: 6,
        onPressed: _handleImport,
        icon: const Icon(Icons.add, size: 20),
        label: Text(
          'HWT Ekle',
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 44,
            height: 44,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(LuxuryColors.gold),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            _statusMessage,
            style: GoogleFonts.montserrat(
              color: isDark ? Colors.white70 : Colors.black87,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: LuxuryColors.gold.withValues(alpha: 0.08),
                border: Border.all(color: LuxuryColors.gold.withValues(alpha: 0.4), width: 1.5),
              ),
              child: const Icon(
                Icons.watch_outlined,
                size: 56,
                color: LuxuryColors.gold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Huawei Klasöründe Kadran Bulunamadı',
              textAlign: TextAlign.center,
              style: GoogleFonts.cinzel(
                color: isDark ? LuxuryColors.goldLight : LuxuryColors.goldDark,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Cihazınızın Dahili Depolama alanında bulunan "Huawei" klasörüne (.hwt) dosyalarınızı kopyalayın veya aşağıdaki buton ile dosyalarınızı seçin.',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: isDark ? Colors.white60 : Colors.black54,
                fontSize: 12,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isDark ? LuxuryColors.darkCard : LuxuryColors.lightCard,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? LuxuryColors.darkBorder : LuxuryColors.lightBorder,
                ),
              ),
              child: Text(
                _currentPath,
                style: GoogleFonts.montserrat(
                  color: LuxuryColors.gold,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LuxuryColors.gold,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _handleImport,
                  icon: const Icon(Icons.file_upload_outlined, size: 18),
                  label: Text(
                    'Dosya Seç & Aktar',
                    style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: LuxuryColors.gold),
                    foregroundColor: LuxuryColors.gold,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => _initAndLoad(),
                  icon: const Icon(Icons.refresh, size: 18),
                  label: Text(
                    'Tekrar Tara',
                    style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
