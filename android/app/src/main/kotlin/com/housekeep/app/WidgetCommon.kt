package com.housekeep.app

import android.app.PendingIntent
import android.content.Context
import android.net.Uri
import es.antonborri.home_widget.HomeWidgetLaunchIntent

object WidgetCommon {
    fun launchIntent(context: Context, route: String): PendingIntent {
        val uri = Uri.parse("housekeep://widget?route=$route")
        return HomeWidgetLaunchIntent.getActivity(
            context,
            MainActivity::class.java,
            uri,
        )
    }

    fun stripeColor(urgency: String): Int = when (urgency) {
        "overdue", "urgent" -> R.color.widget_stripe_urgent
        "upcoming" -> R.color.widget_stripe_upcoming
        else -> R.color.widget_stripe_ok
    }

    fun statusBackground(urgency: String): Int = when (urgency) {
        "overdue", "urgent" -> R.drawable.widget_badge_pending
        "upcoming" -> R.drawable.widget_badge_soon
        else -> R.drawable.widget_chip
    }

    fun statusTextColor(urgency: String): Int = when (urgency) {
        "overdue", "urgent" -> R.color.widget_badge_pending_text
        "upcoming" -> R.color.widget_badge_soon_text
        else -> R.color.widget_accent
    }

    fun iconRes(key: String?): Int = when (key) {
        "maintenance" -> R.drawable.widget_ic_maintenance
        "warranty" -> R.drawable.widget_ic_warranty
        else -> R.drawable.widget_ic_document
    }
}
