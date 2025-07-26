//
//  ChangeAppIconImpl.swift
//  ChangeAppIcon
//
//  Created by Linh Le on 26/7/25.
//

import UIKit

@objc public class ChangeAppIconImpl: NSObject {
  @objc public func getIcon() -> String {
    var currentIcon: String = "Default"
    if Thread.isMainThread {
        currentIcon = UIApplication.shared.alternateIconName ?? "Default"
    } else {
        DispatchQueue.main.sync {
            currentIcon = UIApplication.shared.alternateIconName ?? "Default"
        }
    }
    return currentIcon
  }
  
  @objc public func changeIcon(iconName: String?) {
      guard UIApplication.shared.supportsAlternateIcons else {
          print("❌ Device does not support alternate icons.")
          return
      }

      DispatchQueue.main.async {
          UIApplication.shared.setAlternateIconName(iconName) { error in
              if let error = error {
                  print("❌ Error changing icon: \(error.localizedDescription)")
              } else {
                  print("✅ Icon changed to: \(iconName ?? "Default")")
              }
          }
      }
  }
}
