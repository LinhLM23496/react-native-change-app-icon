# react-native-change-app-icon

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
npm install react-native-change-app-icon
```

or

```bash
yarn add react-native-change-app-icon
```

---

## ⚙️ iOS Setup

### 1. Add Alternate Icons to `Info.plist`

```xml
<key>CFBundleIcons</key>
<dict>
  <key>CFBundleAlternateIcons</key>
  <dict>
    <key>alternateIcon1</key>
    <dict>
      <key>CFBundleIconFiles</key>
      <array>
        <string>alternateIcon1</string>
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
import ChangeAppIcon from 'react-native-change-app-icon';

// ✅ Change to alternate icon
await ChangeAppIcon.changeIcon('alternateIcon1');

// 🔁 Get current icon
await ChangeAppIcon.getIcon();

// 🤫 iOS only: silently change icon (if enabled)
await ChangeAppIcon.changeIconSilently('alternateIcon1');
```

---

## 📌 Notes

- `changeIconSilently` is available **only if** you compile with `ENABLE_SILENT_ICON_CHANGE` flag.
- iOS will prompt the user for permission when using the default `changeIcon()`.
- Android support depends on the launcher (e.g. works on Samsung OneUI, Pixel, etc.).

---

## 🧑‍💻 Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and development workflow.

---

## 📄 License

Apache-2.0 © [LMLGroup]

---

Made with ❤️ using [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
