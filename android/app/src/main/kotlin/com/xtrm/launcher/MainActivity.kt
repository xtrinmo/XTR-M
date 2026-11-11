package com.xtrm.launcher

import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import android.hardware.display.DisplayManager
import android.net.TrafficStats
import android.net.Uri
import android.os.BatteryManager
import android.os.Debug
import android.os.StatFs
import android.os.SystemClock
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.RandomAccessFile

class MainActivity : FlutterActivity(), DisplayManager.DisplayListener {
    private lateinit var displayManager: DisplayManager
    private var channel: MethodChannel? = null
    private var previousRx = TrafficStats.getTotalRxBytes()
    private var previousTx = TrafficStats.getTotalTxBytes()
    private var previousTime = SystemClock.elapsedRealtime()
    private var previousCpu: Pair<Long, Long>? = null
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        displayManager = getSystemService(DISPLAY_SERVICE) as DisplayManager
        displayManager.registerDisplayListener(this, null)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "pocketdex/system")
        channel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "hasExternalDisplay" -> result.success(displayManager.displays.any { it.displayId != 0 })
                "requestOverlaySettings" -> { startActivity(Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, Uri.parse("package:$packageName"))); result.success(null) }
                "resourceStats" -> try { result.success(readStats()) } catch (_: Exception) { result.success(mapOf("error" to "N/A")) }
                "openCastSettings" -> try { startActivity(Intent("android.settings.CAST_SETTINGS")); result.success(true) } catch (_: Exception) { result.success(false) }
                else -> result.notImplemented()
            }
        }
    }
    private fun readStats(): Map<String, Any?> {
        val am = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val mem = ActivityManager.MemoryInfo(); am.getMemoryInfo(mem)
        val cpu = readCpu()
        val battery = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        val level = battery.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY).takeIf { it >= 0 }
        val intent = registerReceiver(null, android.content.IntentFilter(Intent.ACTION_BATTERY_CHANGED))
        val temp = intent?.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, -1)?.takeIf { it >= 0 }?.div(10.0)
        val fs = StatFs(filesDir.absolutePath)
        val rx = TrafficStats.getTotalRxBytes(); val tx = TrafficStats.getTotalTxBytes(); val now = SystemClock.elapsedRealtime()
        val rate = if (TrafficStats.UNSUPPORTED == rx || TrafficStats.UNSUPPORTED == tx || now <= previousTime) null else ((rx-previousRx)+(tx-previousTx))*1000L/(now-previousTime)
        previousRx=rx; previousTx=tx; previousTime=now
        return mapOf("ramUsed" to (mem.totalMem-mem.availMem), "ramTotal" to mem.totalMem, "cpuPercent" to cpu, "batteryPercent" to level, "batteryTempC" to temp, "storageFree" to fs.availableBytes, "storageTotal" to fs.totalBytes, "networkBytesPerSecond" to rate)
    }
    private fun readCpu(): Double? = try {
        RandomAccessFile("/proc/stat", "r").use { f ->
            val p=f.readLine().trim().split(Regex("\\s+")); val v=p.drop(1).map { it.toLong() }; val idle=v[3]+(v.getOrNull(4)?:0L); val total=v.sum(); val old=previousCpu; previousCpu=Pair(idle,total)
            if(old==null || total<=old.second) null else ((1.0-(idle-old.first).toDouble()/(total-old.second))*100.0).coerceIn(0.0,100.0)
        }
    } catch (_: Exception) { null }
    override fun onDisplayAdded(id: Int) { channel?.invokeMethod("externalDisplayChanged", displayManager.displays.any { it.displayId != 0 }) }
    override fun onDisplayRemoved(id: Int) { channel?.invokeMethod("externalDisplayChanged", displayManager.displays.any { it.displayId != 0 }) }
    override fun onDisplayChanged(id: Int) = Unit
    override fun onDestroy() { if (::displayManager.isInitialized) displayManager.unregisterDisplayListener(this); super.onDestroy() }
}
