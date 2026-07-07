# Chairful — Brand Assets

Single source of truth for the **Chairful** logo and app icons. Tagline: **"Keep every chair full."**

## Colors
| Token | Hex | Use |
|-------|-----|-----|
| Teal (primary) | `#0E7C6B` | icon background, "ful", accents |
| Mint | `#7FD8CC` | accents on dark |
| Ink | `#0F172A` | "Chair", wordmark on light |

## Files
| File | What | Where it's used |
|------|------|-----------------|
| `chairful-icon.svg` / `.png` | App icon — teal squircle + white side-chair mark (1024²) | `flutter_launcher_icons` source (`image_path`) |
| `chairful-icon-foreground.svg` / `.png` | Adaptive-icon foreground — chair only, transparent (1024²) | Android adaptive `adaptive_icon_foreground` |
| `chairful-wordmark.svg` | "Chairful" wordmark (Chair = ink, ful = teal) | headers, splash, marketing |
| `chairful-lockup.svg` / `.png` | Icon + wordmark + tagline | decks, docs, store listing |

## Regenerate PNGs from SVG
Requires Node + `sharp`. Use **Windows-style paths** (sharp is a native win binary):
```js
const sharp = require('sharp');
const B = 'D:/vamshi/Salone/brand';
sharp(B+'/chairful-icon.svg', {density:400}).resize(1024,1024).png().toFile(B+'/chairful-icon.png');
```

## Apply to the app
1. Copy `chairful-icon.png` → `mobile/salon_admin_app_v2/assets/icon/icon_full.png`
2. Copy `chairful-icon-foreground.png` → `.../assets/icon/icon_fg.png`
3. In the app: `dart run flutter_launcher_icons`
4. Set `android:label="Chairful"` in the app's `AndroidManifest.xml`.

> Adaptive background color is the teal `#0E7C6B` (set in the app's `flutter_launcher_icons` config).
