package com.housekeep.app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.os.Bundle
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin

class HouseKeepWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        val data = HomeWidgetPlugin.getData(context)
        appWidgetIds.forEach { widgetId ->
            val views = buildViews(context, appWidgetManager, widgetId, data)
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: Bundle,
    ) {
        val data = HomeWidgetPlugin.getData(context)
        val views = buildViews(context, appWidgetManager, appWidgetId, data)
        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    private fun buildViews(
        context: Context,
        manager: AppWidgetManager,
        widgetId: Int,
        data: SharedPreferences,
    ): RemoteViews {
        val options = manager.getAppWidgetOptions(widgetId)
        val minHeight = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT, 0)
        val useMedium = minHeight >= 110
        val layoutId = if (useMedium) {
            R.layout.housekeep_widget_medium
        } else {
            R.layout.housekeep_widget_small
        }
        val views = RemoteViews(context.packageName, layoutId)

        views.setTextViewText(
            R.id.widget_brand,
            data.getString("label_brand", "HouseKeep") ?: "HouseKeep",
        )

        val isPro = data.getBoolean("is_pro", false)
        val eventCount = data.getInt("event_count", 0)

        if (!isPro) {
            renderUpgrade(context, views, data)
            return views
        }

        if (eventCount == 0) {
            renderAllClear(context, views, data)
            return views
        }

        renderEvents(context, views, data, useMedium)
        return views
    }

    private fun renderBadges(views: RemoteViews, data: SharedPreferences) {
        val pending = data.getInt("pending_count", 0)
        val soon = data.getInt("soon_count", 0)
        if (pending > 0) {
            val label = data.getString("label_pending", "pendientes") ?: "pendientes"
            views.setTextViewText(R.id.widget_badge_pending, "$pending $label")
            views.setViewVisibility(R.id.widget_badge_pending, View.VISIBLE)
        } else {
            views.setViewVisibility(R.id.widget_badge_pending, View.GONE)
        }
        if (soon > 0) {
            val label = data.getString("label_soon", "pronto") ?: "pronto"
            views.setTextViewText(R.id.widget_badge_soon, "$soon $label")
            views.setViewVisibility(R.id.widget_badge_soon, View.VISIBLE)
        } else {
            views.setViewVisibility(R.id.widget_badge_soon, View.GONE)
        }
    }

    private fun hideBadges(views: RemoteViews) {
        views.setViewVisibility(R.id.widget_badge_pending, View.GONE)
        views.setViewVisibility(R.id.widget_badge_soon, View.GONE)
    }

    private fun renderUpgrade(
        context: Context,
        views: RemoteViews,
        data: SharedPreferences,
    ) {
        val title = data.getString("upgrade_title", "Hazte PRO") ?: "Hazte PRO"
        val subtitle = data.getString("upgrade_subtitle", "") ?: ""
        hideBadges(views)
        views.setViewVisibility(R.id.widget_state_message, View.VISIBLE)
        views.setViewVisibility(R.id.widget_state_subtitle, View.VISIBLE)
        views.setViewVisibility(R.id.widget_events_container, View.GONE)
        views.setTextViewText(R.id.widget_state_message, title)
        views.setTextViewText(R.id.widget_state_subtitle, subtitle)
        views.setOnClickPendingIntent(
            R.id.widget_root,
            launchIntent(context, "/paywall"),
        )
    }

    private fun renderAllClear(
        context: Context,
        views: RemoteViews,
        data: SharedPreferences,
    ) {
        val text = data.getString("all_clear_text", "Todo al día ✓") ?: "Todo al día ✓"
        hideBadges(views)
        views.setViewVisibility(R.id.widget_state_message, View.VISIBLE)
        views.setViewVisibility(R.id.widget_state_subtitle, View.GONE)
        views.setViewVisibility(R.id.widget_events_container, View.GONE)
        views.setTextViewText(R.id.widget_state_message, text)
        views.setOnClickPendingIntent(
            R.id.widget_root,
            launchIntent(context, "/"),
        )
    }

    private fun renderEvents(
        context: Context,
        views: RemoteViews,
        data: SharedPreferences,
        useMedium: Boolean,
    ) {
        renderBadges(views, data)
        views.setViewVisibility(R.id.widget_state_message, View.GONE)
        views.setViewVisibility(R.id.widget_state_subtitle, View.GONE)
        views.setViewVisibility(R.id.widget_events_container, View.VISIBLE)
        if (useMedium) {
            views.setViewVisibility(
                R.id.widget_event_divider,
                if (data.getBoolean("event_1_visible", false)) View.VISIBLE else View.GONE,
            )
        }

        val slots = if (useMedium) 3 else 1
        val slotIds = listOf(
            SlotIds(
                container = R.id.widget_event_0,
                title = R.id.widget_event_0_title,
                subtitle = R.id.widget_event_0_subtitle,
                due = R.id.widget_event_0_due,
                stripe = R.id.widget_event_0_stripe,
            ),
            SlotIds(
                container = R.id.widget_event_1,
                title = R.id.widget_event_1_title,
                subtitle = R.id.widget_event_1_subtitle,
                due = R.id.widget_event_1_due,
                stripe = R.id.widget_event_1_stripe,
            ),
            SlotIds(
                container = R.id.widget_event_2,
                title = R.id.widget_event_2_title,
                subtitle = R.id.widget_event_2_subtitle,
                due = R.id.widget_event_2_due,
                stripe = R.id.widget_event_2_stripe,
            ),
        )

        for (i in slotIds.indices) {
            val ids = slotIds[i]
            val visible = i < slots && data.getBoolean("event_${i}_visible", false)
            if (!visible) {
                views.setViewVisibility(ids.container, View.GONE)
                continue
            }
            views.setViewVisibility(ids.container, View.VISIBLE)
            views.setTextViewText(
                ids.title,
                data.getString("event_${i}_title", "") ?: "",
            )
            val subtitle = data.getString("event_${i}_subtitle", "") ?: ""
            views.setTextViewText(ids.subtitle, subtitle)
            views.setViewVisibility(
                ids.subtitle,
                if (subtitle.isEmpty()) View.GONE else View.VISIBLE,
            )
            views.setTextViewText(
                ids.due,
                data.getString("event_${i}_due", "") ?: "",
            )
            val urgency = data.getString("event_${i}_urgency", "ok") ?: "ok"
            views.setInt(
                ids.stripe,
                "setBackgroundResource",
                stripeColor(urgency),
            )
            if (!useMedium || i == 0) {
                views.setInt(
                    ids.due,
                    "setBackgroundResource",
                    WidgetCommon.statusBackground(urgency),
                )
                views.setTextColor(
                    ids.due,
                    context.getColor(WidgetCommon.statusTextColor(urgency)),
                )
            } else {
                views.setTextColor(ids.due, context.getColor(R.color.widget_text_secondary))
            }
            val route = data.getString("event_${i}_route", "/") ?: "/"
            views.setOnClickPendingIntent(ids.container, launchIntent(context, route))

            if (useMedium && i == 0) {
                views.setImageViewResource(
                    R.id.widget_event_0_icon,
                    WidgetCommon.iconRes(data.getString("event_0_icon", "document")),
                )
            }
        }
    }

    private fun stripeColor(urgency: String): Int = when (urgency) {
        "overdue", "urgent" -> R.color.widget_stripe_urgent
        "upcoming" -> R.color.widget_stripe_upcoming
        else -> R.color.widget_stripe_ok
    }

    private fun launchIntent(context: Context, route: String): PendingIntent {
        val uri = Uri.parse("housekeep://widget?route=$route")
        return HomeWidgetLaunchIntent.getActivity(
            context,
            MainActivity::class.java,
            uri,
        )
    }

    private data class SlotIds(
        val container: Int,
        val title: Int,
        val subtitle: Int,
        val due: Int,
        val stripe: Int,
    )
}
