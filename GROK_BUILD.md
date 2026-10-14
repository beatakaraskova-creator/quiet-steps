# Quiet Steps — what to tell Grok Build

Work only inside the `quiet_steps` folder.

## Visuals only (safe)

Tell Grok Build to edit these files and **not** the step files:

- `lib/models/look_pack.dart` — colours of each pack
- `lib/services/look.dart` — how a look is saved
- `lib/screens/look_screen.dart` — the Look page
- `lib/screens/home_screen.dart` — home layout and background photo
- `lib/screens/history_screen.dart`
- `lib/screens/settings_screen.dart`
- `lib/widgets/step_ring.dart` — the ring
- `lib/widgets/colour_wheel.dart`
- `lib/widgets/glass_panel.dart`
- `lib/screens/photo_crop_screen.dart`

## Do not touch unless steps are broken

- `lib/services/step_engine.dart`
- `lib/services/step_math.dart`
- `lib/services/step_task.dart`
- `lib/services/store.dart` (except new look settings)

## Prompt you can paste

```
You are in the quiet_steps Flutter app.

Change LOOK only. Do not change step counting, sensors, or storage of steps.

I want:
- [describe the look: colours, layout, bigger numbers, softer cards, etc.]

Background photo is already supported. Keep Look → “Use a photo”.

Edit only files under lib/screens, lib/widgets, lib/models/look_pack.dart, lib/services/look.dart.
```

Photo of a dog (or anything) is chosen in the app: Look → Use a photo. You do not put that picture into Grok Build unless you want it baked into the project as a default asset.
