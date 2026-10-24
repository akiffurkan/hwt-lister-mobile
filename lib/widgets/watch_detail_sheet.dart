import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../models/watch_face.dart';
import '../services/localization_service.dart';
import '../theme/luxury_theme.dart';

class WatchDetailSheet extends StatefulWidget {
  final WatchFace watch;
  final AppLocale appLocale;
  final bool isDark;
  final Future<void> Function(WatchFace watch)? onDelete;

  const WatchDetailSheet({
    super.key,
    required this.watch,
    required this.appLocale,
    required this.isDark,
    this.onDelete,
  });

  @override
  State<WatchDetailSheet> createState() => _WatchDetailSheetState();
}

class _WatchDetailSheetState extends State<WatchDetailSheet> {
  bool _showAod = false;
  bool _showAllFiles = false;

  void _shareFile() {
    SharePlus.instance.share(
      ShareParams(
        files: [XFile(widget.watch.filePath)],
        text: widget.appLocale.t('shareWatchFaceText', {'name': widget.watch.displayName}),
      ),
    );
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: widget.isDark ? LuxuryColors.darkCard : LuxuryColors.lightCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: widget.isDark ? LuxuryColors.darkBorder : LuxuryColors.lightBorder,
          ),
        ),
        title: Row(
          children: [
            const Icon(Icons.delete_forever_outlined, color: Colors.redAccent, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.appLocale.t('deleteDialogTitle'),
                style: GoogleFonts.cinzel(
                  color: widget.isDark ? LuxuryColors.goldLight : LuxuryColors.goldDark,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          widget.appLocale.t('deleteDialogContent', {'name': widget.watch.displayName}),
          style: GoogleFonts.montserrat(
            color: widget.isDark ? Colors.white70 : Colors.black87,
            fontSize: 13,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              widget.appLocale.t('cancel'),
              style: GoogleFonts.montserrat(
                color: widget.isDark ? Colors.white60 : Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              widget.appLocale.t('deleteConfirm'),
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      Navigator.of(context).pop();
      if (widget.onDelete != null) {
        await widget.onDelete!(widget.watch);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final watch = widget.watch;
    final appLocale = widget.appLocale;
    final isDark = widget.isDark;
    final dateStr = DateFormat('dd.MM.yyyy HH:mm').format(watch.modifiedDate);

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
              const SizedBox(height: 18),

              // Büyük Dairesel Saat Önizlemesi
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 210,
                    height: 210,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: LuxuryColors.gold,
                        width: 3.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: LuxuryColors.gold.withValues(alpha: 0.3),
                          blurRadius: 24,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: (_showAod && watch.aodBytes != null)
                          ? Image.memory(watch.aodBytes!, fit: BoxFit.cover)
                          : (watch.coverBytes != null
                              ? Image.memory(watch.coverBytes!, fit: BoxFit.cover)
                              : Container(
                                  color: isDark ? LuxuryColors.darkCard : Colors.grey.shade200,
                                  child: const Icon(Icons.watch_outlined, size: 70, color: LuxuryColors.gold),
                                )),
                    ),
                  ),
                  if (watch.aodBytes != null)
                    Positioned(
                      bottom: 0,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: LuxuryColors.gold,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          visualDensity: VisualDensity.compact,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: () {
                          setState(() {
                            _showAod = !_showAod;
                          });
                        },
                        icon: Icon(_showAod ? Icons.wb_sunny : Icons.nightlight_round, size: 14),
                        label: Text(
                          _showAod ? appLocale.t('normalCover') : appLocale.t('aodPreview'),
                          style: GoogleFonts.montserrat(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Kadran İsmi ve Yazar
              Text(
                watch.displayName,
                textAlign: TextAlign.center,
                style: GoogleFonts.cinzel(
                  color: isDark ? LuxuryColors.goldLight : LuxuryColors.goldDark,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              if (watch.author.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  appLocale.t('designer', {'author': watch.author}),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: isDark ? Colors.white70 : Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              const SizedBox(height: 16),

              // Paylaş & Sil Butonları
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: LuxuryColors.gold),
                      foregroundColor: LuxuryColors.gold,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                    onPressed: _shareFile,
                    icon: const Icon(Icons.share_outlined, size: 18),
                    label: Text(
                      appLocale.t('shareHwt'),
                      style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.8)),
                      foregroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                    onPressed: _confirmDelete,
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: Text(
                      appLocale.t('deleteHwt'),
                      style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Özellik Kartları Grid
              _buildSpecsGrid(watch, appLocale, isDark, dateStr),
              const SizedBox(height: 16),

              // Açıklama Metni (Varsa)
              if (watch.description.isNotEmpty) ...[
                _buildSectionHeader(appLocale.t('description'), isDark),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? LuxuryColors.darkCard : LuxuryColors.lightCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? LuxuryColors.darkBorder : LuxuryColors.lightBorder,
                    ),
                  ),
                  child: Text(
                    watch.description,
                    style: GoogleFonts.montserrat(
                      color: isDark ? Colors.white70 : Colors.black87,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // XML Metadata Detayları
              if (watch.xmlMetadata.isNotEmpty) ...[
                _buildSectionHeader(appLocale.t('xmlConfig'), isDark),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? LuxuryColors.darkCard : LuxuryColors.lightCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? LuxuryColors.darkBorder : LuxuryColors.lightBorder,
                    ),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: watch.xmlMetadata.length,
                    separatorBuilder: (_, _) => Divider(
                      height: 1,
                      color: isDark ? Colors.white10 : Colors.black12,
                    ),
                    itemBuilder: (context, index) {
                      final key = watch.xmlMetadata.keys.elementAt(index);
                      final value = watch.xmlMetadata[key] ?? '';
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                key,
                                style: GoogleFonts.montserrat(
                                  color: LuxuryColors.gold,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                value,
                                style: GoogleFonts.montserrat(
                                  color: isDark ? Colors.white70 : Colors.black87,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Arşiv Dosya Listesi
              _buildSectionHeader(appLocale.t('archiveContent', {'count': '${watch.fileList.length}'}), isDark),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? LuxuryColors.darkCard : LuxuryColors.lightCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? LuxuryColors.darkBorder : LuxuryColors.lightBorder,
                  ),
                ),
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _showAllFiles
                          ? watch.fileList.length
                          : (watch.fileList.length > 6 ? 6 : watch.fileList.length),
                      itemBuilder: (context, index) {
                        final file = watch.fileList[index];
                        final isImg = file.endsWith('.png') || file.endsWith('.jpg') || file.endsWith('.jpeg');
                        return ListTile(
                          dense: true,
                          visualDensity: VisualDensity.compact,
                          leading: Icon(
                            isImg ? Icons.image_outlined : (file.endsWith('.xml') ? Icons.code : Icons.insert_drive_file_outlined),
                            color: isImg ? LuxuryColors.gold : Colors.grey,
                            size: 16,
                          ),
                          title: Text(
                            file,
                            style: GoogleFonts.montserrat(
                              color: isDark ? Colors.white70 : Colors.black87,
                              fontSize: 11,
                            ),
                          ),
                        );
                      },
                    ),
                    if (watch.fileList.length > 6)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _showAllFiles = !_showAllFiles;
                          });
                        },
                        child: Text(
                          _showAllFiles
                              ? appLocale.t('showLess')
                              : appLocale.t('showMore', {'count': '${watch.fileList.length}'}),
                          style: GoogleFonts.montserrat(
                            color: LuxuryColors.gold,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.cinzel(
          color: isDark ? LuxuryColors.goldLight : LuxuryColors.goldDark,
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSpecsGrid(WatchFace watch, AppLocale appLocale, bool isDark, String dateStr) {
    final items = [
      {'label': appLocale.t('fileSize'), 'value': watch.formattedSize, 'icon': Icons.data_usage},
      {'label': appLocale.t('version'), 'value': watch.version.isNotEmpty ? watch.version : appLocale.t('notSpecified'), 'icon': Icons.tag},
      {'label': appLocale.t('targetDevice'), 'value': watch.device ?? appLocale.t('defaultDevice'), 'icon': Icons.watch},
      {'label': appLocale.t('imageCount'), 'value': appLocale.t('imagesUnit', {'count': '${watch.imageCount}'}), 'icon': Icons.photo_library_outlined},
      {'label': appLocale.t('dateModified'), 'value': dateStr, 'icon': Icons.calendar_today_outlined},
      {'label': appLocale.t('fileName'), 'value': watch.fileName, 'icon': Icons.insert_drive_file_outlined},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 2.5,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? LuxuryColors.darkCard : LuxuryColors.lightCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark ? LuxuryColors.darkBorder : LuxuryColors.lightBorder,
            ),
          ),
          child: Row(
            children: [
              Icon(item['icon'] as IconData, color: LuxuryColors.gold, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item['label'] as String,
                      style: GoogleFonts.montserrat(
                        color: isDark ? Colors.white38 : Colors.black38,
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['value'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
