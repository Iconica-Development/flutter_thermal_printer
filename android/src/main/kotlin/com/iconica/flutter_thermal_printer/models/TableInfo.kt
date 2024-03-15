package com.iconica.flutter_thermal_printer.models

/**
 * Table DTO
 *
 * @param table The table to be printed.
 *
 * @since 1.0.0
 * @version 1.0.0
 * @author Mark Kiepe
 */
class TableInfo(var table: Map<Int, List<String>> = mapOf())
{
    /**
     * Constructor for the TableInfo class.
     *
     * @param table The table to be printed.
     */
    constructor(table: List<List<String>>) : this() {
        for (i in table.indices) {
            this.table = this.table + mapOf(i to table[i])
        }
    }

    /**
     * Get the maximum column count.
     *
     * @return {@link Int} The maximum column count.
     */
    fun getColumnCount(): Int {
        var max = 0
        for (i in 0 until getRowCount()) {
            val count = getColumnCount(i)
            max = maxOf(max, count)
        }
        return max
    }

    /**
     * Get the column count for a specific row.
     *
     * @param row {@link Int} The row to get the column count for.
     * @return {@link Int} The column count for the row.
     */
    fun getColumnCount(row: Int): Int {
        return table[row]?.size ?: 0
    }

    /**
     * Get the row count.
     *
     * @return {@link Int} The row count.
     */
    fun getRowCount(): Int {
        return table.size
    }

    /**
     * Get the text for a specific cell.
     *
     * @param row {@link Int} The row of the cell.
     * @param column {@link Int} The column of the cell.
     * @return {@link String} The text of the cell.
     */
    fun getText(row: Int, column: Int): String {
        return table[row]?.get(column) ?: ""
    }
}
