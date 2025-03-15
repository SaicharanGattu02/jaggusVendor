package vendor.jaggus.app

import android.app.*
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.media.MediaPlayer
import android.os.Build
import android.os.IBinder
import android.os.PowerManager
import androidx.core.app.NotificationCompat

class MyForegroundService : Service() {

    private var mediaPlayer: MediaPlayer? = null
    private val CHANNEL_ID = "jaggus_foreground_service"
    private var wakeLock: PowerManager.WakeLock? = null

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
        acquireWakeLock() // Prevents service from stopping in background
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == "STOP") {
            stopSelf()
            return START_NOT_STICKY
        }

        val title = intent?.getStringExtra("title") ?: "Jaggus Alert"
        val body = intent?.getStringExtra("body") ?: "Custom notification sound is playing..."

        if (mediaPlayer == null) {
            mediaPlayer = MediaPlayer.create(this, R.raw.jaggus_tone).apply {
                isLooping = true // Ensure continuous looping
                setOnCompletionListener { start() } // Restart when completed
                start()
            }
        }

        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle(title)
            .setContentText(body)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setOngoing(true)
            .addAction(R.drawable.ic_stop, "STOP", stopPendingIntent()) // Stop action
            .build()

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            startForeground(1, notification, ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PLAYBACK)
        } else {
            startForeground(1, notification)
        }

        return START_STICKY
    }

    override fun onDestroy() {
        super.onDestroy()
        mediaPlayer?.stop()
        mediaPlayer?.release()
        mediaPlayer = null
        releaseWakeLock()
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                CHANNEL_ID,
                "Jaggus Service Channel",
                NotificationManager.IMPORTANCE_HIGH
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(serviceChannel)
        }
    }

    private fun stopPendingIntent(): PendingIntent {
        val stopIntent = Intent(this, MyForegroundService::class.java).apply {
            action = "STOP"
        }
        return PendingIntent.getService(this, 0, stopIntent, PendingIntent.FLAG_IMMUTABLE)
    }

    private fun acquireWakeLock() {
        val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock = powerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "Jaggus::WakeLock")
        wakeLock?.acquire()
    }

    private fun releaseWakeLock() {
        wakeLock?.release()
        wakeLock = null
    }
}



//class MyForegroundService : Service() {
//
//    private var mediaPlayer: MediaPlayer? = null
//    private val CHANNEL_ID = "jaggus_foreground_service"
//
//    override fun onCreate() {
//        super.onCreate()
//        createNotificationChannel()
//    }
//
//    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
//        if (intent?.action == "STOP") {
//            stopSelf()
//            return START_NOT_STICKY
//        }
//
//        val title = intent?.getStringExtra("title") ?: "Jaggus Alert!"
//        val body = intent?.getStringExtra("body") ?: "Custom notification sound is playing..."
//
//        if (mediaPlayer == null) {
//            mediaPlayer = MediaPlayer.create(this, R.raw.jaggus_tone)
//            mediaPlayer?.isLooping = true
//            mediaPlayer?.start()
//        }
//
//        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
//            .setContentTitle(title) // Updated title
//            .setContentText(body) // Updated body
//            .setSmallIcon(R.mipmap.ic_launcher)
//            .setOngoing(true)
//            .addAction(R.drawable.ic_stop, "STOP", stopPendingIntent())
//            .build()
//
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
//            startForeground(1, notification, ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PLAYBACK)
//        } else {
//            startForeground(1, notification)
//        }
//
//        return START_STICKY
//    }
//
//    override fun onDestroy() {
//        super.onDestroy()
//        mediaPlayer?.stop()
//        mediaPlayer?.release()
//        mediaPlayer = null
//    }
//
//    override fun onBind(intent: Intent?): IBinder? {
//        return null
//    }
//
//    private fun createNotificationChannel() {
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            val serviceChannel = NotificationChannel(
//                CHANNEL_ID,
//                "Jaggus Service Channel",
//                NotificationManager.IMPORTANCE_HIGH
//            )
//            val manager = getSystemService(NotificationManager::class.java)
//            manager.createNotificationChannel(serviceChannel)
//        }
//    }
//
//    private fun stopPendingIntent(): PendingIntent {
//        val stopIntent = Intent(this, MyForegroundService::class.java)
//        stopIntent.action = "STOP"
//        return PendingIntent.getService(this, 0, stopIntent, PendingIntent.FLAG_IMMUTABLE)
//    }
//}
