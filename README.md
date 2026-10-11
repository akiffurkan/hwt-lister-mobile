<div align="center">

# ⌚ HWT Lister Mobile
### Haute Horlogerie Huawei Watch Face Gallery for Android

[![Flutter](https://img.shields.io/badge/Flutter-3.47+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20Cross--Platform-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://android.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-D4AF37?style=for-the-badge)](LICENSE)

<p align="center">
  A luxury, native Flutter mobile client for browsing, inspecting, and managing <b>Huawei Watch Face (<code>.hwt</code>)</b> archives on Android devices.
</p>

</div>

---

## ✨ Features

- 📁 **Instant `/Huawei` Storage Integration:**
  - Automatically provisions and monitors the root storage directory (`/storage/emulated/0/Huawei`) on your device.
  - Drop your `.hwt` watch face files straight into the `Huawei` folder in your file manager; the app scans and presents them immediately.
- 👑 **Haute Horlogerie Luxury Design:**
  - Bespoke Dark Obsidian (`#090B10`) & Cream Ivory Gold luxury themes.
  - Golden circular watch bezels, soft ambient glows, and tracked typography powered by Google Fonts (Cinzel & Montserrat).
- 🛡️ **Smart Cover Extraction & AOD Protection:**
  - Extracts high-resolution covers (`preview/cover.jpg`, `cover.png`, `icon_small.png`).
  - Distinguishes AMOLED standby (`aod.jpg`) images from primary face previews, providing an interactive AOD comparison toggle in the details modal.
- 📜 **Full XML Metadata & Archive Inspector:**
  - Parses `watch_face_config.xml` and `description.xml` inside archives.
  - Inspect title, designer, version, target hardware, file size, image asset counts, and raw archive tree.
- 🔄 **In-App File Import & Native Sharing:**
  - Tap **HWT Ekle** to pick watch faces from Downloads, Telegram, WhatsApp, or Google Drive and copy them straight to `/storage/emulated/0/Huawei`.
  - Share `.hwt` packages directly with other apps or devices using native Android share sheets.
- 🔍 **Real-Time Filtering & Multi-Criteria Sorting:**
  - Fast search by title, designer, model, or filename.
  - Sort by Name (A-Z / Z-A), File Size (Largest / Smallest), or Modification Date.

---

## 🏗️ Architecture & Technology Stack

```
lib/
├── main.dart                      # Application root & System UI overlays
├── models/
│   └── watch_face.dart            # WatchFace immutable data model
├── services/
│   ├── hwt_service.dart           # Pure Dart ZIP extraction, AOD protection & XML parser
│   └── storage_service.dart       # /storage/emulated/0/Huawei folder manager & file picker
├── theme/
│   └── luxury_theme.dart          # Haute Horlogerie gold gradients & dark/light palettes
├── widgets/
│   ├── stats_header.dart          # Crown header, directory selector & metrics pills
│   ├── search_filter_bar.dart     # Search input & multi-criteria sorting menu
│   ├── watch_card.dart            # Luxury circular watch face grid card
│   └── watch_detail_sheet.dart    # Full preview, AOD toggle, XML inspector & file share
└── screens/
    └── home_screen.dart           # Main gallery screen with pull-to-refresh & empty states
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.47.0`)
- [Dart SDK](https://dart.dev/get-dart) (`>= 3.13.0`)
- Android SDK (API 21+ supported, Android 11+ with Scoped Storage permission handling)

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/akiffurkan/hwt-lister-mobile.git
cd hwt-lister-mobile

# 2. Install dependencies
flutter pub get

# 3. Run on connected Android device or emulator
flutter run
```

### Building Release APK

```bash
flutter build apk --release
```
The optimized APK will be generated at `build/app/outputs/flutter-apk/app-release.apk`.

---

## 📱 How to Use on Your Phone

1. Install the app on your Android phone.
2. Open your favorite File Manager app (e.g. Samsung My Files, Files by Google, Solid Explorer).
3. Open **Internal Storage (Dahili Depolama)** and locate the **`Huawei`** folder automatically created by the app (`/storage/emulated/0/Huawei`).
4. Copy your `.hwt` watch face files into this folder.
5. Open **HWT Lister Mobile** and pull down to refresh — all watch faces will be displayed with high-resolution previews and metadata!

---

## 📄 License

This project is open-source and released under the [MIT License](LICENSE).

<div align="center">
  <sub>Crafted with passion & precision by <b><a href="https://github.com/akiffurkan">Akif Furkan EMİR</a></b></sub>
</div>
