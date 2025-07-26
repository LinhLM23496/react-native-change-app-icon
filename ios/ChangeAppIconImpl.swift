//
//  ChangeAppIconImpl.swift
//  ChangeAppIcon
//
//  Created by Linh Le on 26/7/25.
//

import Foundation
import UIKit

@objc public class ChangeAppIconImpl: NSObject {
    @objc public static let shared = ChangeAppIconImpl()

    // MARK: - 1. Get current icon name
    @objc public func getIcon() -> String {
        if Thread.isMainThread {
            return UIApplication.shared.alternateIconName ?? "Default"
        } else {
            // Prevent app crash by ensuring UI APIs are accessed only from the main thread
            var iconName: String?
            DispatchQueue.main.sync {
                iconName = UIApplication.shared.alternateIconName
            }
            return iconName ?? "Default"
        }
    }

    // MARK: - 2. Change icon (with system alert)
    @objc public func changeIcon(to iconName: String?) {
        guard isAlternateIconSupported() else {
            print("❌ Alternate icons not supported on this device.")
            return
        }

        guard shouldChangeIcon(to: iconName) else {
            print("ℹ️ No need to change icon. Already using the desired icon.")
            return
        }

        DispatchQueue.main.async {
            UIApplication.shared.setAlternateIconName(iconName) { error in
                if let error = error {
                    print("❌ Failed to change icon: \(error.localizedDescription)")
                } else {
                    print("✅ Icon changed to \(iconName ?? "Default")")
                }
            }
        }
    }

    // MARK: - 3. Change icon silently (no alert - uses private API)
    #if ENABLE_SILENT_ICON_CHANGE
    @objc public func changeIconSilently(to iconName: String?) {
        guard isAlternateIconSupported() else {
            print("❌ Alternate icons not supported on this device.")
            return
        }

        guard shouldChangeIcon(to: iconName) else {
            print("ℹ️ No need to change icon. Already using the desired icon.")
            return
        }

        DispatchQueue.main.async {
            let selectorString = "_setAlternateIconName:completionHandler:"
            let selector = NSSelectorFromString(selectorString)

            guard UIApplication.shared.responds(to: selector),
                  let imp = UIApplication.shared.method(for: selector) else {
                print("❌ UIApplication does not respond to selector \(selectorString)")
                return
            }

            typealias Function = @convention(c) (NSObject, Selector, NSString?, @escaping (NSError?) -> ()) -> ()
            let function = unsafeBitCast(imp, to: Function.self)

            function(UIApplication.shared, selector, iconName as NSString?) { error in
                if let error = error {
                    print("❌ Failed to change icon silently: \(error.localizedDescription)")
                } else {
                    print("✅ Silently changed icon to \(iconName ?? "Default")")
                }
            }
        }
    }
  
    #else
    @objc public func changeIconSilently(to iconName: String?) {
      NSException(name: .genericException, reason: "Silent icon change is not enabled in this build.", userInfo: nil).raise()    }
    #endif

    // MARK: - 4. Check: supports alternate icon (iOS 10.3+)
    private func isAlternateIconSupported() -> Bool {
        var isSupported = false

        if Thread.isMainThread {
            isSupported = UIApplication.shared.responds(to: #selector(getter: UIApplication.supportsAlternateIcons))
                && UIApplication.shared.supportsAlternateIcons
        } else {
            DispatchQueue.main.sync {
                isSupported = UIApplication.shared.responds(to: #selector(getter: UIApplication.supportsAlternateIcons))
                    && UIApplication.shared.supportsAlternateIcons
            }
        }

        return isSupported
    }

    // MARK: - 5. Check if we need to change icon
    private func shouldChangeIcon(to newIconName: String?) -> Bool {
        let currentIconName = getIcon()

        let normalizedNew = normalizeIconName(newIconName)
        let normalizedCurrent = normalizeIconName(currentIconName)

        return normalizedNew != normalizedCurrent
    }

    private func normalizeIconName(_ name: String?) -> String {
        // Treat nil, "Default", "AppIcon" all as the default
        let defaultNames: Set<String> = ["Default", "AppIcon", "", "default"]
        guard let lower = name?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() else {
            return "default"
        }
        return defaultNames.contains(lower) ? "default" : lower
    }
}
