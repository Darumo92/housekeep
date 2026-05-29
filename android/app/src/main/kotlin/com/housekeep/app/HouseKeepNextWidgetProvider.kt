package com.housekeep.app

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.SharedPreferences
import android.os.Bundle
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class HouseKeepNextWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        val data = HomeWidgetPlugin.getData(context)
        appWidgetIds.forEach { widgetId ->
            appWidgetManager.updateAppWidget(widgetId, buildViews(context, data))
        }
    }

    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: Bundle,
    ) {
        val data = HomeWidgetPlugin.getData(context)
        appWidgetManager.updateAppWidget(appWidgetId, buildViews(context, data))
    }

    private fun buildViews(context: Context, data: SharedPreferences): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.housekeep_widget_next)
        views.setTextViewText(
            R.id.widget_next_label,
            data.getString("label_next", "PRÓXIMO") ?: "PRÓXIMO",
        )

        val isPro = data.getBoolean("is_pro", false)
        if (!isPro) {
            showState(views, data.getString("upgrade_title", "Hazte PRO") ?: "Hazte PRO")
            views.setOnClickPendingIntent(
                R.id.widget_root,
                WidgetCommon.launchIntent(context, "/paywall"),
            )
            return views
        }

        val hasEvent = data.getBoolean("event_0_visible", false) &&
            data.getInt("event_count", 0) > 0
        if (!hasEvent) {
            showState(views, data.getString("all_clear_text", "Todo al día ✓") ?: "Todo al día ✓")
            views.setOnClickPendingIntent(
                R.id.widget_root,
                WidgetCommon.launchIntent(context, "/"),
            )
            return views
        }

        views.setViewVisibility(R.id.widget_state_message, View.GONE)
        views.setViewVisibility(R.id.widget_next_body, View.VISIBLE)
        views.setTextViewText(
            R.id.widget_next_title,
            data.getString("event_0_title", "") ?: "",
        )
        val subtitle = data.getString("event_0_subtitle", "") ?: ""
        views.setTextViewText(R.id.widget_next_subtitle, subtitle)
        views.setViewVisibility(
            R.id.widget_next_subtitle,
            if (subtitle.isEmpty()) View.GONE else View.VISIBLE,
        )
        views.setTextViewText(
            R.id.widget_next_due,
            data.getString("event_0_due", "") ?: "",
        )
        val urgency = data.getString("event_0_urgency", "ok") ?: "ok"
        views.setInt(
            R.id.widget_next_stripe,
            "setBackgroundResource",
            WidgetCommon.stripeColor(urgency),
        )
        views.setInt(
            R.id.widget_next_due,
            "setBackgroundResource",
            WidgetCommon.statusBackground(urgency),
        )
        views.setTextColor(
            R.id.widget_next_due,
            context.getColor(WidgetCommon.statusTextColor(urgency)),
        )
        views.setImageViewResource(
            R.id.widget_next_icon,
            WidgetCommon.iconRes(data.getString("event_0_icon", "document")),
        )
        val route = data.getString("event_0_route", "/") ?: "/"
        views.setOnClickPendingIntent(
            R.id.widget_root,
            WidgetCommon.launchIntent(context, route),
        )
        return views
    }

    private fun showState(views: RemoteViews, message: String) {
        views.setViewVisibility(R.id.widget_state_message, View.VISIBLE)
        views.setViewVisibility(R.id.widget_next_body, View.GONE)
        views.setTextViewText(R.id.widget_state_message, message)
    }
}
