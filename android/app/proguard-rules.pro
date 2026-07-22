# WorkManager — uses reflection to instantiate WorkDatabase
-keep class androidx.work.** { *; }
-keep class androidx.work.impl.** { *; }
-keepclassmembers class * extends androidx.work.Worker { *; }
-keepclassmembers class * extends androidx.work.ListenableWorker {
    public <init>(android.content.Context, androidx.work.WorkerParameters);
}

# Room — WorkDatabase is a Room database created via reflection
-keep class * extends androidx.room.RoomDatabase { *; }
-keep @androidx.room.Database class * { *; }
-keepclassmembers @androidx.room.Database class * { *; }
-keep @androidx.room.Entity class * { *; }
-keep @androidx.room.Dao interface * { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# flutter_local_notifications
-keep class com.dexterous.** { *; }

# Jetpack Glance is excluded from the build (see build.gradle.kts): the app uses
# classic RemoteViews widgets only. home_widget's bytecode still references a few
# Glance symbols in code paths we never call, so silence R8's missing-class
# warnings for the removed package.
-dontwarn androidx.glance.**

# Gson — flutter_local_notifications serializes scheduled notifications with
# Gson TypeToken reflection. R8 strips generic signatures, breaking
# pendingNotificationRequests() with "Missing type parameter".
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.google.gson.** { *; }
-keep class * extends com.google.gson.reflect.TypeToken
-keep public class * implements java.lang.reflect.Type
