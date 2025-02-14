import 'package:intl/intl.dart';

class MSIConstants {
  static const msiAvailable = "¡Promoción Disponible!";
  static const msiDescription =
      "¿Deseas realizar el pago a Meses sin Intereses?";
  static const enjoyCardPromo = "Disfruta las promociones de tu tarjeta";
  static const noThanks = "No, gracias";
  static const wantPromo = "¡Sí quiero!";
  static const msiTicketLabel = "Meses sin intereses: ";
  static const chooseMsi = "Elige el número de Meses sin Intereses a aplicar";
  static const confirmSelection = "¿Estás seguro?";

  static final msiFormatter = NumberFormat("00");
  static final msiAmountFormatter = NumberFormat("\$#,##0.00", "es_MX");

  static String msiSelectedMessage(int msi, double msiAmount) =>
      "Pagarás en ${msiFormatter.format(msi)} mensualidades de ${msiAmountFormatter.format(msiAmount)} cada una";

  static String msiOptionButtonText(int msi, double msiAmount) =>
      "${msiFormatter.format(msi)} x ${msiAmountFormatter.format(msiAmount)}";
}
