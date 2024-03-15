package com.iconica.flutter_thermal_printer.services

import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Typeface
import android.os.Build
import android.text.Layout
import android.text.StaticLayout
import android.text.TextPaint
import androidx.annotation.RequiresApi

import com.iconica.flutter_thermal_printer.models.TableInfo

/**
 * Exception for incorrect Android version.
 *
 * @param message {@link String} The message to display.
 */
class IncorrectAndroidVersionException(message: String) : Exception(message)

/**
 * This class is responsible for converting text to a bitmap.
 *
 * @version 1.0.0
 * @since 1.0.0
 * @author Mark Kiepe
 */
class PrinterBuilder {

    /**
     * Create a bitmap from text.
     *
     * @see Bitmap
     * @see Typeface
     * @see StaticLayout
     *
     * @param text {@link String} The text to create the bitmap from.
     * @param font {@link Typeface} The font to use.
     * @param width {@link Int} The width of the bitmap.
     * @return {@link Bitmap} The bitmap created from the text.
     *
     * @throws IncorrectAndroidVersionException If the Android version is not M or above.
     */
    @Throws(IncorrectAndroidVersionException::class)
    fun createBitmapFromText(text: String, width: Int): Bitmap {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val paint = TextPaint(Paint.DITHER_FLAG)
            paint.color = Color.BLACK
            paint.typeface = Typeface.MONOSPACE
            paint.textSize = 24f

            val layout = StaticLayout.Builder.obtain(text, 0, text.length, paint, width)
                .setAlignment(Layout.Alignment.ALIGN_NORMAL)
                .setLineSpacing(0f, 1f)
                .setIncludePad(true)
                .build()

            val bitmap = Bitmap.createBitmap(width, layout.height, Bitmap.Config.ARGB_8888)
            val canvas = Canvas(bitmap)
            canvas.drawColor(Color.WHITE)
            layout.draw(canvas)
            return bitmap
        } else {
            throw IncorrectAndroidVersionException(
                "This method is only available on Android M and above"
            )
        }
    }

    /**
     * Create a bitmap from a table.
     *
     * @see Bitmap
     * @see Typeface
     *
     * @param paperWidth {@link Int} The width of the paper.
     * @param tableInfo {@link TableInfo} The table to create the bitmap from.
     * @return {@link Bitmap} The bitmap created from the table.
     *
     * @throws IncorrectAndroidVersionException If the Android version is not M or above.
     */
    @Throws(IncorrectAndroidVersionException::class)
    fun createBitmapFromTableInfo(paperWidth: Int, tableInfo: TableInfo): Bitmap {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val textPaint = TextPaint(Paint.ANTI_ALIAS_FLAG)
            textPaint.color = Color.BLACK
            textPaint.typeface = Typeface.MONOSPACE
            textPaint.textSize = 24f

            val rows = tableInfo.getRowCount()
            val columns = tableInfo.getColumnCount()
            val columnWidth = paperWidth / columns

            var totalHeight = 0

            for (i in 0 until rows) {
                totalHeight += calculateRowHeight(tableInfo, columnWidth, i)
            }

            val bitmap = Bitmap.createBitmap(paperWidth, totalHeight, Bitmap.Config.ARGB_8888)
            val canvas = Canvas(bitmap)
            canvas.drawColor(Color.WHITE)

            var y = 0
            for (i in 0 until rows) {
                val rowHeight = calculateRowHeight(tableInfo, columnWidth, i)
                for (j in 0 until columns) {
                    val x = j * columnWidth

                    val alignment = when (j) {
                        0 -> Layout.Alignment.ALIGN_NORMAL
                        columns - 1 -> Layout.Alignment.ALIGN_OPPOSITE
                        else -> Layout.Alignment.ALIGN_CENTER
                    }

                    val text = tableInfo.getText(i, j)
                    val layout =
                        StaticLayout.Builder.obtain(text, 0, text.length, textPaint, columnWidth)
                            .setAlignment(alignment)
                            .setLineSpacing(0f, 1f)
                            .setIncludePad(true)
                            .build()

                    canvas.save()
                    canvas.translate(x.toFloat(), y.toFloat())
                    layout.draw(canvas)
                    canvas.restore()
                }
                y += rowHeight
            }

            return bitmap
        } else {
            throw IncorrectAndroidVersionException(
                "This method is only available on Android M and above"
            )
        }
    }

    @RequiresApi(Build.VERSION_CODES.M)
    private fun calculateTextHeight(text: String, width: Int): Int {
        val paint = TextPaint(Paint.ANTI_ALIAS_FLAG)
        paint.textSize = 24f
        val layout = StaticLayout.Builder.obtain(text, 0, text.length, paint, width)
            .setAlignment(Layout.Alignment.ALIGN_NORMAL)
            .setLineSpacing(0f, 1f)
            .setIncludePad(true)
            .build()
        return layout.height
    }

    @RequiresApi(Build.VERSION_CODES.M)
    private fun calculateRowHeight(tableInfo: TableInfo, columnWidth: Int, row: Int): Int {
        var maxHeight = 0
        for (j in 0 until tableInfo.getColumnCount(row)) {
            maxHeight =
                maxOf(maxHeight, calculateTextHeight(tableInfo.getText(row, j), columnWidth))
        }
        return maxHeight
    }
}