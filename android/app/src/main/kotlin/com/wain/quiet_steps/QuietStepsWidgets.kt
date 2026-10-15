package com.wain.quiet_steps

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.content.res.ColorStateList
import android.graphics.Color
import android.os.Build
import android.util.TypedValue
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class QuietStepsSmallWidget : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        QuietStepsWidgets.bind(
            context,
            appWidgetManager,
            appWidgetIds,
            widgetData,
            R.layout.widget_small,
            medium = false,
        )
    }
}

class QuietStepsMediumWidget : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        QuietStepsWidgets.bind(
            context,
            appWidgetManager,
            appWidgetIds,
            widgetData,
            R.layout.widget_medium,
            medium = true,
        )
    }
}

object QuietStepsWidgets {
    private const val DEFAULT_BG = 0xFF141412.toInt()
    private const val DEFAULT_ACCENT = 0xFFC4A574.toInt()
    private const val DEFAULT_INK = 0xFFF3EFE6.toInt()
    private const val DEFAULT_MUTED = 0xFFA8A29A.toInt()

    fun bind(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
        layoutId: Int,
        medium: Boolean,
    ) {
        val stepsLabel = widgetData.str("stepsLabel", "0")
        val status = widgetData.str("status", "")
        val streak = widgetData.str("streak", "")
        val bg = widgetData.color("bg", DEFAULT_BG)
        val accent = widgetData.color("accent", DEFAULT_ACCENT)
        val ink = widgetData.color("ink", DEFAULT_INK)
        val muted = widgetData.color("muted", DEFAULT_MUTED)
        val progress = widgetData.num("progress", 0).coerceIn(0, 1000)
        val big = widgetData.flag("bigSimple")
        val track = Color.argb(64, Color.red(muted), Color.green(muted), Color.blue(muted))
        val stepsSp = if (big) 26f else 22f
        val statusSp = if (big) 15f else 13f
        val streakSp = if (big) 14f else 12f

        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, layoutId)
            views.setInt(R.id.widget_bg, "setColorFilter", bg)
            views.setTextViewText(R.id.widget_steps, stepsLabel)
            views.setTextColor(R.id.widget_steps, ink)
            views.setTextViewTextSize(R.id.widget_steps, TypedValue.COMPLEX_UNIT_SP, stepsSp)
            views.setProgressBar(R.id.widget_progress, 1000, progress, false)
            tintProgress(views, accent, track)
            views.setContentDescription(
                R.id.widget_root,
                listOf(stepsLabel, status).filter { it.isNotEmpty() }.joinToString(" · "),
            )
            if (medium) {
                views.setTextViewText(R.id.widget_streak, streak)
                views.setTextColor(R.id.widget_streak, muted)
                views.setTextViewTextSize(R.id.widget_streak, TypedValue.COMPLEX_UNIT_SP, streakSp)
                views.setTextViewText(R.id.widget_status, status)
                views.setTextColor(R.id.widget_status, ink)
                views.setTextViewTextSize(R.id.widget_status, TypedValue.COMPLEX_UNIT_SP, statusSp)
                views.setInt(R.id.widget_mark, "setColorFilter", accent)
            }
            val launch = HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java)
            views.setOnClickPendingIntent(R.id.widget_root, launch)
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    private fun tintProgress(views: RemoteViews, accent: Int, track: Int) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            views.setColorStateList(
                R.id.widget_progress,
                "setProgressTintList",
                ColorStateList.valueOf(accent),
            )
            views.setColorStateList(
                R.id.widget_progress,
                "setProgressBackgroundTintList",
                ColorStateList.valueOf(track),
            )
        }
    }

    private fun SharedPreferences.str(key: String, fallback: String): String {
        return getString(key, fallback) ?: fallback
    }

    private fun SharedPreferences.num(key: String, fallback: Int): Int {
        return when (val v = all[key]) {
            is Int -> v
            is Long -> v.toInt()
            is Float -> v.toInt()
            is Double -> v.toInt()
            is String -> v.toIntOrNull() ?: fallback
            is Boolean -> if (v) 1 else 0
            else -> fallback
        }
    }

    private fun SharedPreferences.color(key: String, fallback: Int): Int {
        return num(key, fallback)
    }

    private fun SharedPreferences.flag(key: String): Boolean {
        return when (val v = all[key]) {
            is Boolean -> v
            is Int -> v != 0
            is Long -> v != 0L
            is String -> v == "true" || v == "1"
            else -> false
        }
    }
}
