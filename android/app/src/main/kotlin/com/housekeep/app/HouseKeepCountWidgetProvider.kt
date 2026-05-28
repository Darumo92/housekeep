package com.housekeep.app

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.SharedPreferences
import android.os.Bundle
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class HouseKeepCountWidgetProvider : AppWidgetProvider() {

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
        val views = RemoteViews(context.packageName, R.layout.housekeep_widget_count)
        views.setTextViewText(
            R.id.widget_brand,
            data.getString("label_brand", "HouseKeep") ?: "HouseKeep",
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

        val pending = data.getInt("pending_count", 0)
        if (pending == 0) {
            showState(views, data.getString("all_clear_text", "Todo al día ✓") ?: "Todo al día ✓")
            views.setOnClickPendingIntent(
                R.id.widget_root,
                WidgetCommon.launchIntent(context, "/"),
            )
            return views
        }

        views.setViewVisibility(R.id.widget_state_message, View.GONE)
        views.setViewVisibility(R.id.widget_count_number, View.VISIBLE)
        views.setViewVisibility(R.id.widget_count_label, View.VISIBLE)
        views.setTextViewText(R.id.widget_count_number, pending.toString())
        views.setTextViewText(
            R.id.widget_count_label,
            data.getString("label_things", "cosas pendientes") ?: "cosas pendientes",
        )

        val week = data.getInt("week_count", 0)
        if (week > 0) {
            val label = data.getString("label_week", "esta semana") ?: "esta semana"
            views.setViewVisibility(R.id.widget_count_week, View.VISIBLE)
            views.setTextViewText(R.id.widget_count_week, "$week $label")
        } else {
            views.setViewVisibility(R.id.widget_count_week, View.GONE)
        }

        views.setOnClickPendingIntent(
            R.id.widget_root,
            WidgetCommon.launchIntent(context, "/"),
        )
        return views
    }

    private fun showState(views: RemoteViews, message: String) {
        views.setViewVisibility(R.id.widget_state_message, View.VISIBLE)
        views.setViewVisibility(R.id.widget_count_number, View.GONE)
        views.setViewVisibility(R.id.widget_count_label, View.GONE)
        views.setViewVisibility(R.id.widget_count_week, View.GONE)
        views.setTextViewText(R.id.widget_state_message, message)
    }
}
