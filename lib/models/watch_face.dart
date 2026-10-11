import 'dart:typed_data';

class WatchFace {
  final String id;
  final String filePath;
  final String fileName;
  final int fileSizeBytes;
  final String formattedSize;
  final DateTime modifiedDate;
  final Uint8List? coverBytes;
  final Uint8List? aodBytes;
  final String title;
  final String author;
  final String version;
  final String description;
  final String? device;
  final int imageCount;
  final List<String> fileList;
  final Map<String, String> xmlMetadata;

  WatchFace({
    required this.id,
    required this.filePath,
    required this.fileName,
    required this.fileSizeBytes,
    required this.formattedSize,
    required this.modifiedDate,
    this.coverBytes,
    this.aodBytes,
    required this.title,
    required this.author,
    required this.version,
    required this.description,
    this.device,
    required this.imageCount,
    required this.fileList,
    required this.xmlMetadata,
  });

  String get displayName => title.isNotEmpty ? title : fileName.replaceAll(RegExp(r'\.hwt$', caseSensitive: false), '');
}
