package com.changeappicon

import android.annotation.SuppressLint
import android.app.Activity
import android.app.Application
import android.content.ComponentName
import android.content.pm.PackageManager
import android.os.Bundle
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.module.annotations.ReactModule
import kotlin.system.exitProcess

@ReactModule(name = ChangeAppIconModule.NAME)
class ChangeAppIconModule(reactContext: ReactApplicationContext) :
  NativeChangeAppIconSpec(reactContext), Application.ActivityLifecycleCallbacks {

  private val packageManager: PackageManager = reactContext.packageManager
  private val packageName: String = reactContext.packageName
  private val classesToKill: MutableSet<String> = mutableSetOf()
  private var isNeedRestart = false

  companion object {
    const val NAME = "ChangeAppIcon"
    private const val MAIN_ACTIVITY_BASE_NAME = ".MainActivity"
    private const val MAIN_ACTIVITY_DEFAULT_NAME = "Default"
  }

  override fun getName(): String {
    return NAME
  }

  private fun getAllLauncherAliases(): List<String> {
    val result = mutableListOf<String>()
    try {
      val packageInfo = packageManager.getPackageInfo(
        packageName,
        PackageManager.GET_ACTIVITIES or PackageManager.GET_DISABLED_COMPONENTS
      )
      packageInfo.activities?.forEach { activityInfo ->
        if (activityInfo.targetActivity != null) {
          result.add(activityInfo.name)
        }
      }
    } catch (_: Exception) {
    }
    return result
  }

  @SuppressLint("QueryPermissionsNeeded")
  fun getEnabledAlias(activities: List<String>): String {
    for (activity in activities) {
        val state = packageManager.getComponentEnabledSetting(ComponentName(packageName, activity))
        if (state == PackageManager.COMPONENT_ENABLED_STATE_ENABLED) {
          return activity
        }
    }
    isNeedRestart = true
    return "$packageName$MAIN_ACTIVITY_BASE_NAME"
  }

  override fun getIcon(promise: Promise) {
    try {
      val alias = getEnabledAlias(getAllLauncherAliases())
      promise.resolve(alias.removePrefix("$packageName."))
    } catch (e: Exception) {
      promise.reject("GET_ICON_FAILED", e)
    }
  }

  override fun changeIcon(iconName: String?, promise: Promise) {
    val activity = reactApplicationContext.currentActivity
    if (activity == null) {
      promise.reject("ACTIVITY_NOT_FOUND", "The activity is null. Check if the app is running properly.")
      return
    }

    val activities = getAllLauncherAliases()
    val currentAlias = getEnabledAlias(activities)
    val newIconName = if (iconName.isNullOrEmpty()) MAIN_ACTIVITY_DEFAULT_NAME else iconName
    val activeClass = "$packageName.$newIconName"

    if (currentAlias == activeClass || (currentAlias == "$packageName$MAIN_ACTIVITY_BASE_NAME" && iconName.isNullOrEmpty())) {
      promise.reject("ICON_ALREADY_USED", "This icon is the current active icon. $currentAlias")
      return
    }

    // Validate new icon name
    if (!activities.contains(activeClass)) {
      promise.reject("INVALID_ICON", "Icon alias \"$newIconName\" is not recognized.")
      return
    }

    try {
      // Enable new alias
      packageManager.setComponentEnabledSetting(
        ComponentName(packageName, activeClass),
        PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
        PackageManager.DONT_KILL_APP
      )

      if (isNeedRestart) {
        classesToKill.add(currentAlias)
        activity.application.registerActivityLifecycleCallbacks(this)
      } else {
        // Disable previous alias
        packageManager.setComponentEnabledSetting(
          ComponentName(packageName, currentAlias),
          PackageManager.COMPONENT_ENABLED_STATE_DEFAULT,
          PackageManager.DONT_KILL_APP
        )
        promise.resolve("Your icon changed to $newIconName")
      }
    } catch (e: Exception) {
      promise.reject("ICON_INVALID", e.localizedMessage)
    }
  }

  override fun changeIconSilently(name: String?, promise: Promise) {
    changeIcon(name, promise)
  }

  private fun completeIconChange() {
    val currentAlias = getEnabledAlias(getAllLauncherAliases())
    classesToKill.remove(currentAlias)

    for (className in classesToKill) {
      packageManager.setComponentEnabledSetting(
        ComponentName(packageName, className),
        PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
        PackageManager.DONT_KILL_APP
      )
    }
    classesToKill.clear()

    exitProcess(0)
  }

  override fun onActivityCreated(p0: Activity, p1: Bundle?) {
    TODO("Not yet implemented")
  }

  override fun onActivityStarted(p0: Activity) {
    TODO("Not yet implemented")
  }

  override fun onActivityResumed(p0: Activity) {
    TODO("Not yet implemented")
  }

  override fun onActivityPaused(p0: Activity) {
    completeIconChange()
  }

  override fun onActivityStopped(p0: Activity) {
    TODO("Not yet implemented")
  }

  override fun onActivitySaveInstanceState(p0: Activity, p1: Bundle) {
    TODO("Not yet implemented")
  }

  override fun onActivityDestroyed(p0: Activity) {
    TODO("Not yet implemented")
  }
}
