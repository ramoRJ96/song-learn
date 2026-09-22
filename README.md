# Song Learn

Application Flutter pour apprendre une chanson à la batterie, puis au piano. Outils 100 % open source ou gratuits.

Architecture : Clean Architecture (`domain` / `data` / `presentation`), SOLID, Riverpod.

## Palier actuel

Kit batterie 2,5D + groove rock de démo. Les sons sont des one-shots générés. L’extraction depuis une chanson (Demucs + DrumScript) viendra ensuite.

## Lancer

```bash
flutter pub get
flutter run -d chrome
```

Sur Android (émulateur ou téléphone), le son est plus fiable qu’en Bluetooth.

## Générer les samples

```bash
dart run tool/generate_drums.dart
```
