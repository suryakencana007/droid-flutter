# UI kit: forui

Komponen UI memakai [forui](https://forui.dev), library open source bergaya
shadcn/ui untuk Flutter. Dipilih pada Oktober 2026 dari tiga kandidat
(`shadcn_ui`, `forui`, `shadcn_flutter`) karena:

- Sudah mengikuti pemisahan `material_ui`/`cupertino_ui` di Flutter 3.47, jadi
  tidak akan ada migrasi paksa saat Material dilepas dari core.
- 52 komponen dengan form paling lengkap, termasuk Data Table, Sheet, Skeleton.
- CLI untuk generate tema, style, dan snippet.
- Maintainer paling aktif di antara kandidat.

Catatan: forui masih versi 0.x. Versi dipin minor di `pubspec.yaml`
(`^0.27.5`). Baca changelog sebelum menaikkan minor.

## Cara pakai

Semua layer mengimpor forui lewat satu pintu:

```dart
import 'package:droid/shared/ui/index.dart';
```

File itu mengekspor `package:forui/forui.dart`, `package:forui_lucide` (ikon
Lucide, `FLucideIcons.sun`), helper `Gap`, `AppSpacing`, dan `UiTheme`.
Mengimpor `package:forui` langsung dari layer lain ditolak oleh
`test/architecture/fsd_layers_test.dart`.

Contoh yang sudah ada:

| Layer    | File                                                | Komponen           |
|----------|-----------------------------------------------------|--------------------|
| app      | `lib/app/app.dart`                                  | `FTheme`, `FToaster`, `FTooltipGroup` |
| entities | `lib/entities/user/ui/user_card.dart`               | `FCard`, `FAvatar` |
| features | `lib/features/toggle_theme/ui/toggle_theme_button.dart` | `FButton.icon` |
| pages    | `lib/pages/home/ui/home_page.dart`                  | `FButton`, `showFToast`, `context.theme.typography` |

Widget Material masih boleh dipakai berdampingan (`Scaffold`, `AppBar`,
`ListView`). Tema Material diturunkan dari tema forui lewat
`toApproximateMaterialTheme()` di `lib/app/theme/app_theme.dart`.

## Material lewat `material_ui`, bukan `flutter/material.dart`

Sejak Flutter 3.47, Material dan Cupertino dipisah ke package `material_ui`
dan `cupertino_ui`; versi bawaan di `package:flutter` deprecated dan forui
sudah memakai package yang baru. Karena `ThemeData` keduanya adalah tipe yang
berbeda, seluruh project mengimpor:

```dart
import 'package:material_ui/material_ui.dart';
```

Import `package:flutter/material.dart` atau `package:flutter/cupertino.dart`
ditolak oleh test arsitektur.

## Tema

Preset saat ini: `FTheme.neutral` varian `touch` (lihat
`lib/shared/ui/theme/ui_theme.dart`). Untuk tema custom:

```bash
just theme            # dart run forui theme create, interaktif
```

atau rancang di [Forui Create](https://forui.dev/create) lalu tempel hasilnya ke
`ui_theme.dart`. Style per komponen bisa digenerate dengan
`just forui style create button`, snippet layout dengan
`just forui snippet create card`.

## Mengakses token di widget

```dart
final theme = context.theme;        // FThemeData
theme.colors.foreground;
theme.colors.mutedForeground;
theme.typography.xl2;               // xs3 ... xl8
theme.cardStyle.titleTextStyle;
```
