package com.iconica.flutter_thermal_printer.services

import com.starmicronics.starioextension.StarIoExt

/**
 * Service to handle the printer settings.
 *
 * @implSpec This service supports all the Star Micronics thermal printers that
 * are/were available and supported by the StarIO SDK as of 13-MAR-2024.
 *
 * @author Mark Kiepe
 * @since 1.0.0
 * @version 1.0.0
 */
class PrinterSettingsService {

    /**
     * This method returns the port settings option based on the provided emulation.
     *
     * @param emulation {@link String} The emulation type of the printer in string format.
     * @return {@link String} The port settings option as a string.
     *
     * The method uses a when expression to match the provided emulation with the corresponding port settings option.
     * If the emulation is EscPosMobile, it returns "mini".
     * If the emulation is EscPos, it returns "escpos".
     * If the emulation is StarPRNT or StarPRNTL, it returns "Portable;l".
     * For all other emulations, it returns the string representation of the emulation.
     */
    fun getPortSettingsOption(
        emulation: String
    ): String {
        return when (emulation) {
            StarIoExt.Emulation.EscPosMobile.toString() -> "mini"
            StarIoExt.Emulation.EscPos.toString() -> "escpos"
            StarIoExt.Emulation.StarPRNT.toString(), StarIoExt.Emulation.StarPRNTL.toString() -> "Portable;l"
            else -> emulation
        }
    }

    /**
     * This method retrieves the emulation of the printer based on the model name.
     *
     * @implSpec This method supports all the Star Micronics thermal printers that
     * are/were available and supported by the StarIO SDK as of 13-MAR-2024.
     *
     * @param modelName {@link String} The model name of the printer.
     * @return {@link StarIoExt.Emulation} The emulation of the printer.
     */
    fun getEmulation(modelName: String): StarIoExt.Emulation {
        val starPRNTModels = listOf(
            "mC-Print2",
            "MCP21",
            "MCP20",
            "mC-Print3",
            "MCP31",
            "MCP30",
            "mC-Label3",
            "MCL32",
            "mPOP",
            "TSP100",
            "TSP100IV",
            "TSP143IV",
            "Star TSP143IV-UE",
            "TSP100IV SK",
            "Star TSP143IV-UE SK",
            "TSP143IIILAN",
            "TSP143IV",
            "TSP143IIIW",
            "SM-L200",
            "SM-L300",
            "SK1-211",
            "SK1-221",
            "SK1-V211",
            "SK1-211 Presenter",
            "SK1-221 Presenter",
            "SK1-V211 Presenter",
            "SK1-311",
            "SK1-321",
            "SK1-V311",
            "SK1-311 Presenter",
            "SK1-V311 Presenter",
        )

        val starLineModels = listOf(
            "Star Micronics",
            "FVP10",
            "TSP650II",
            "TSP654II",
            "TSP654",
            "TSP650IISK",
            "TSP700II",
            "TSP743II",
            "TSP800II",
            "TSP847II",
            "TUP500",
        )

        val starGraphicModels = listOf(
            "TSP100IIIW",
            "TSP100IIIBI",
            "TSP100IIIU",
            "Star TSP143IIIU",
            "Star TSP143IIU+",
            "TSP100ECO",
            "TSP100U",
            "TSP100GT",
            "TSP100LAN",
        )

        val escPosMobileModels = listOf(
            "SM-S210i",
            "SM-S220i",
            "SM-S230i",
            "Star SM-S230i",
            "SM-T300",
            "SM-T300i",
            "SM-T400",
            "SM-T400i",
        )

        val escPosModels = listOf(
            "BSC10",
        )

        val starDotImpactModels = listOf(
            "SP700",
            "SP712",
            "SP742",
            "SP717",
            "SP747",
        )

        return when (modelName) {
            in starPRNTModels -> StarIoExt.Emulation.StarPRNT
            in starLineModels -> StarIoExt.Emulation.StarLine
            in starGraphicModels -> StarIoExt.Emulation.StarGraphic
            in escPosMobileModels -> StarIoExt.Emulation.EscPosMobile
            in escPosModels -> StarIoExt.Emulation.EscPos
            in starDotImpactModels -> StarIoExt.Emulation.StarDotImpact
            else -> StarIoExt.Emulation.StarLine
        }
    }
}
