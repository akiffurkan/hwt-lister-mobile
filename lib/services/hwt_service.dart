import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:xml/xml.dart' as xml;
import '../models/watch_face.dart';

class HwtService {
  static String formatBytes(int bytes) {
    if (bytes >= 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    } else if (bytes >= 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else if (bytes >= 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    }
    return '$bytes B';
  }

  static Future<WatchFace?> parseHwtFile(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final stat = await file.stat();
      final archive = ZipDecoder().decodeBytes(bytes);

      Uint8List? coverBytes;
      Uint8List? aodBytes;

      final imageFiles = <ArchiveFile>[];
      final fileList = <String>[];
      int imageCount = 0;

      for (final archiveFile in archive.files) {
        if (archiveFile.isFile) {
          final name = archiveFile.name;
          fileList.add(name);
          final lower = name.toLowerCase();

          if (lower.endsWith('.png') ||
              lower.endsWith('.jpg') ||
              lower.endsWith('.jpeg') ||
              lower.endsWith('.webp') ||
              lower.endsWith('.bmp')) {
            imageCount++;
            if (archiveFile.size > 500) {
              imageFiles.add(archiveFile);
            }
          }
        }
      }

      // 1. AOD görselini tespit et
      for (final img in imageFiles) {
        if (img.name.toLowerCase().contains('aod')) {
          aodBytes = Uint8List.fromList(img.content);
          break;
        }
      }

      // 2. Ana Kapak (Cover) Öncelik Sıralaması (AOD hariç)
      ArchiveFile? selectedCover;

      // Öncelik 1: cover.jpg, cover.png, preview.png, preview.jpg
      for (final img in imageFiles) {
        final lower = img.name.toLowerCase();
        if (lower.contains('aod')) continue;
        final base = lower.split('/').last;
        if (base == 'cover.jpg' ||
            base == 'cover.png' ||
            base == 'cover.jpeg' ||
            base == 'preview.png' ||
            base == 'preview.jpg') {
          selectedCover = img;
          break;
        }
      }

      // Öncelik 2: icon_small veya icon
      if (selectedCover == null) {
        for (final img in imageFiles) {
          final lower = img.name.toLowerCase();
          if (lower.contains('aod')) continue;
          final base = lower.split('/').last;
          if (base.contains('icon_small') || base == 'icon.png' || base == 'icon.jpg') {
            selectedCover = img;
            break;
          }
        }
      }

      // Öncelik 3: Adında 'preview', 'cover' veya 'icon' geçen herhangi bir görsel
      if (selectedCover == null) {
        for (final img in imageFiles) {
          final lower = img.name.toLowerCase();
          if (lower.contains('aod')) continue;
          if (lower.contains('preview') || lower.contains('cover') || lower.contains('icon')) {
            selectedCover = img;
            break;
          }
        }
      }

      // Öncelik 4: AOD olmayan en büyük görsel
      if (selectedCover == null) {
        final nonAod = imageFiles.where((f) => !f.name.toLowerCase().contains('aod')).toList();
        if (nonAod.isNotEmpty) {
          nonAod.sort((a, b) => b.size.compareTo(a.size));
          selectedCover = nonAod.first;
        }
      }

      if (selectedCover != null) {
        coverBytes = Uint8List.fromList(selectedCover.content);
      }

      // 3. XML Metadata ayrıştırma
      final xmlMetadata = <String, String>{};
      String title = '';
      String author = '';
      String version = '';
      String description = '';
      String? device;

      final xmlFiles = archive.files.where((f) => f.isFile && f.name.toLowerCase().endsWith('.xml')).toList();

      // Sıralama: watch_face_config -> description -> diğerleri
      xmlFiles.sort((a, b) {
        final aLow = a.name.toLowerCase();
        final bLow = b.name.toLowerCase();
        final aScore = aLow.contains('watch_face_config') ? 0 : (aLow.contains('description') ? 1 : 2);
        final bScore = bLow.contains('watch_face_config') ? 0 : (bLow.contains('description') ? 1 : 2);
        return aScore.compareTo(bScore);
      });

      for (final xmlFile in xmlFiles) {
        try {
          final xmlString = utf8.decode(xmlFile.content, allowMalformed: true);
          final document = xml.XmlDocument.parse(xmlString);

          for (final element in document.findAllElements('*')) {
            final tagName = element.name.local.toLowerCase();
            final text = element.innerText.trim();

            if (text.isNotEmpty) {
              xmlMetadata[tagName] = text;

              if (title.isEmpty && (tagName == 'title' || tagName == 'watchname' || tagName == 'name')) {
                title = text;
              }
              if (author.isEmpty && (tagName == 'author' || tagName == 'designer')) {
                author = text;
              }
              if (version.isEmpty && (tagName == 'version' || tagName == 'versionname')) {
                version = text;
              }
              if (description.isEmpty && (tagName == 'description' || tagName == 'briefinfo')) {
                description = text;
              }
              if (device == null && (tagName == 'device' || tagName == 'targetdevice' || tagName == 'devicetype')) {
                device = text;
              }
            }

            for (final attr in element.attributes) {
              final attrName = attr.name.local.toLowerCase();
              final attrVal = attr.value.trim();
              if (attrVal.isNotEmpty) {
                xmlMetadata['${tagName}_$attrName'] = attrVal;
              }
            }
          }
        } catch (_) {}
      }

      final fileName = file.uri.pathSegments.last;
      return WatchFace(
        id: file.path,
        filePath: file.path,
        fileName: fileName,
        fileSizeBytes: stat.size,
        formattedSize: formatBytes(stat.size),
        modifiedDate: stat.modified,
        coverBytes: coverBytes,
        aodBytes: aodBytes,
        title: title,
        author: author,
        version: version,
        description: description,
        device: device,
        imageCount: imageCount,
        fileList: fileList,
        xmlMetadata: xmlMetadata,
      );
    } catch (e) {
      return null;
    }
  }
}
