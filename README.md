# @linhlm23496/react-native-change-app-icon

A React Native library that allows you to **dynamically change your app icon** at runtime — supporting both **iOS** and **Android**.

- ✅ Supports standard icon changing (via system UI)
- ⚠️ Supports **silent icon change on iOS** via private API (opt-in)

---

## ✨ Features

- 🔄 Change app icon at runtime (iOS & Android)
- 🤫 Optional: Silent icon switching on iOS _(private API)_
- ✅ Fully typed with TypeScript
- ⚙️ Built with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)

---

## 📸 Demo

> 🖼️ **Insert GIF demo here**
>
> Add a GIF or screenshot showing icon changing in action.

---

## 📦 Installation

```bash
npm install @linhlm23496/react-native-change-app-icon
```

or

```bash
yarn add @linhlm23496/react-native-change-app-icon
```

---

## ⚙️ iOS Setup

### 1. Add Alternate Icons to `Info.plist`

```xml
<key>CFBundleIcons</key>
<dict>
  <key>CFBundleAlternateIcons</key>
  <dict>
    <key>XSquare</key>
    <dict>
      <key>CFBundleIconFiles</key>
      <array>
        <string>XSquare</string>
      </array>
    </dict>
  </dict>
</dict>
```

Ensure your icons (e.g. `alternateIcon1.png`) are added to the Xcode asset catalog.

---

### 2. (Optional) Enable Silent Icon Change (⚠️ iOS only)

Silent icon change uses **private API** and should **not** be used in production App Store builds.

#### Add Compilation Flag

In **Xcode > Build Settings > Active Compilation Conditions**, add:

```
ENABLE_SILENT_ICON_CHANGE
```

#### Or modify `Podfile`:

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'ChangeAppIcon'
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] ||= ['$(inherited)']
        config.build_settings['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] << 'ENABLE_SILENT_ICON_CHANGE'
      end
    end
  end
end
```

---

## 🧪 Usage

```ts
import ChangeAppIcon from '@linhlm23496/react-native-change-app-icon';

// ✅ Change to alternate icon
await ChangeAppIcon.changeIcon('XSquare');

// 🔁 Get current icon
await ChangeAppIcon.getIcon();

// 🤫 iOS only: silently change icon (if enabled)
await ChangeAppIcon.changeIconSilently('XSquare');
```

---

## 📌 Notes

- `changeIconSilently` is available **only if** you compile with `ENABLE_SILENT_ICON_CHANGE` flag.
- iOS will prompt the user for permission when using the default `changeIcon()`.
- Android support depends on the launcher (e.g. works on Samsung OneUI, Pixel, etc.).

---

## ⚙️ Android Setup

### 🏗️ Manifest Setup

To support dynamic icon changes on Android, you'll need to define **activity aliases** in your `AndroidManifest.xml`.

Each icon variant should be declared using `<activity-alias>` that points to a common `MainActivity`. One alias must have `android:name=".Default"` — this is required as the fallback/default icon.

#### ✅ Example:

```xml
<activity
  android:name=".MainActivity"
  android:enabled="false"
  android:exported="true" >
  <intent-filter>
    <action android:name="android.intent.action.MAIN" />
    <category android:name="android.intent.category.LAUNCHER" />
  </intent-filter>
</activity-alias>

<!-- Default icon alias (required) -->
<activity-alias
  android:name=".Default"
  android:enabled="false"
  android:exported="true"
  android:icon="@mipmap/ic_launcher_default"
  android:targetActivity=".MainActivity">
  <intent-filter>
    <action android:name="android.intent.action.MAIN" />
    <category android:name="android.intent.category.LAUNCHER" />
  </intent-filter>
</activity-alias>

<!-- Alternate icon alias -->
<activity-alias
  android:name=".XSquare"
  android:enabled="false"
  android:exported="true"
  android:icon="@mipmap/ic_launcher_xsquare"
  android:targetActivity=".MainActivity" />
```

- Only **one alias can be enabled** at a time.
- You can name aliases whatever you want (e.g., `.Holiday2024`, `.IconB`) — but `.Default` **must exist**.

---

### 🚦 Android Icon Change Flow

```mermaid
graph TD
  A[App first install] --> B[MainActivity is default launcher]
  B --> C{User calls getIcon()}
  C -->|No alias enabled| D[Return "MainActivity"]
  D --> E{User calls changeIcon("XSquare")}
  E --> F[Enable XSquare]
  F --> G[App goes background]
  G --> H[Disable MainActivity alias, exitProcess(0)]
  H --> I[App restarts with XSquare]

  I --> J{User changes again}
  J --> K[Alias changes immediately]
```

---

### ✅ Behavior Summary

- 🆕 **First Install**:
  - `MainActivity` is the only active launcher.
  - All aliases are disabled (`enabled="false"`).
  - `getIcon()` will return `"MainActivity"`.

- 🔁 **First `changeIcon(...)` call**:
  - Enables selected alias.
  - App is sent to background.
  - On `onActivityPaused()`, `MainActivity` is disabled and app is restarted.

- ⚡ **Subsequent icon changes**:
  - Icon switches immediately.
  - No restart is required.
  - Only declared aliases can be used.

### 🚀 Silent vs Normal Icon Change (Android)

> On Android, `changeIconSilently()` behaves exactly like `changeIcon()`. There is **no functional difference**. It's only separated to match the iOS API.

---

### 🧠 Notes

- Aliases must be declared **statically** in the `AndroidManifest.xml`. You cannot create them dynamically at runtime.
- Icon switching only works on launchers that support alias-based switching (e.g., Pixel Launcher, Samsung OneUI, etc.).
- Some OEM launchers (e.g., older Chinese brands) may not respect the alias change.

---

## 🧑‍💻 Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and development workflow.

---

## 📄 License

Apache-2.0 © [LMLGroup]

---

Made with ❤️ using [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
