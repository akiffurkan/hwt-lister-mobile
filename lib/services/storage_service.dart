import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class StorageService {
  // Kullanıcının dosya yöneticisinde ("Dahili Depolama") doğrudan göreceği Huawei klasörü yolu
  static const String androidPrimaryHuaweiPath = '/storage/emulated/0/Huawei';
  static const String androidDownloadHuaweiPath = '/storage/emulated/0/Download/Huawei';

  /// Gerekli depolama izinlerini ister (Android 11+ için MANAGE_EXTERNAL_STORAGE, eski sürümler için STORAGE)
  static Future<bool> requestPermissions() async {
    if (!Platform.isAndroid) return true;

    try {
      if (await Permission.manageExternalStorage.isGranted) {
        return true;
      }
      final manageStatus = await Permission.manageExternalStorage.request();
      if (manageStatus.isGranted) {
        return true;
      }

      final storageStatus = await Permission.storage.request();
      return storageStatus.isGranted;
    } catch (_) {
      return false;
    }
  }

  /// Dosyalarda doğrudan görünen Huawei klasörünü oluşturur veya kontrol eder
  static Future<List<Directory>> getTargetDirectories() async {
    final dirs = <Directory>[];

    if (Platform.isAndroid) {
      // 1. Birincil Dahili Depolama / Huawei
      try {
        final primaryDir = Directory(androidPrimaryHuaweiPath);
        if (!await primaryDir.exists()) {
          await primaryDir.create(recursive: true);
        }
        dirs.add(primaryDir);
      } catch (_) {}

      // 2. İndirilenler / Huawei
      try {
        final dlDir = Directory(androidDownloadHuaweiPath);
        if (!await dlDir.exists()) {
          await dlDir.create(recursive: true);
        }
        dirs.add(dlDir);
      } catch (_) {}
    }

    // 3. Harici Uygulama Belgeleri / Huawei (Güvenli Fallback)
    try {
      final extDir = await getExternalStorageDirectory();
      if (extDir != null) {
        final appHuaweiDir = Directory('${extDir.path}/Huawei');
        if (!await appHuaweiDir.exists()) {
          await appHuaweiDir.create(recursive: true);
        }
        dirs.add(appHuaweiDir);
      }
    } catch (_) {}

    // 4. Uygulama Belgeleri (iOS / Desktop Fallback)
    try {
      final docDir = await getApplicationDocumentsDirectory();
      final localHuawei = Directory('${docDir.path}/Huawei');
      if (!await localHuawei.exists()) {
        await localHuawei.create(recursive: true);
      }
      dirs.add(localHuawei);
    } catch (_) {}

    return dirs;
  }

  /// Tüm Huawei klasörlerini tarayarak bulunan .hwt dosyalarını listeler
  static Future<List<File>> scanHwtFiles({String? customDirectoryPath}) async {
    final hwtFiles = <String, File>{}; // Path -> File benzersizliği için

    final scanDirs = <Directory>[];

    if (customDirectoryPath != null && customDirectoryPath.isNotEmpty) {
      scanDirs.add(Directory(customDirectoryPath));
    }

    final targetDirs = await getTargetDirectories();
    scanDirs.addAll(targetDirs);

    for (final dir in scanDirs) {
      try {
        if (await dir.exists()) {
          final entities = dir.listSync(recursive: true, followLinks: false);
          for (final entity in entities) {
            if (entity is File) {
              final lower = entity.path.toLowerCase();
              if (lower.endsWith('.hwt') || (lower.endsWith('.zip') && lower.contains('gt2'))) {
                hwtFiles[entity.path] = entity;
              }
            }
          }
        }
      } catch (_) {}
    }

    return hwtFiles.values.toList();
  }

  /// Dışarıdan seçilen HWT dosyalarını birincil Huawei klasörüne kopyalar
  static Future<List<File>> pickAndImportHwtFiles() async {
    final pickedFiles = await FilePicker.pickFiles(
      type: FileType.any,
    );

    if (pickedFiles.isEmpty) return [];

    final importedFiles = <File>[];
    final targetDirs = await getTargetDirectories();
    final primaryDir = targetDirs.isNotEmpty ? targetDirs.first : null;

    for (final picked in pickedFiles) {
      if (picked.path != null) {
        final sourceFile = File(picked.path!);
        final lower = picked.name.toLowerCase();

        if (lower.endsWith('.hwt') || lower.endsWith('.zip')) {
          if (primaryDir != null) {
            try {
              final targetPath = '${primaryDir.path}/${picked.name}';
              final copied = await sourceFile.copy(targetPath);
              importedFiles.add(copied);
            } catch (_) {
              importedFiles.add(sourceFile);
            }
          } else {
            importedFiles.add(sourceFile);
          }
        }
      }
    }

    return importedFiles;
  }

  /// Kullanıcının özel bir klasör seçmesini sağlar
  static Future<String?> pickCustomDirectory() async {
    return await FilePicker.getDirectoryPath();
  }

  /// Kadran (.hwt) dosyasını kalıcı olarak siler
  static Future<bool> deleteWatchFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
    } catch (_) {}
    return false;
  }
}
