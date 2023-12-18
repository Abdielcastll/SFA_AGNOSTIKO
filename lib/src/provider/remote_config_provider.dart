import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:pwa_sales2go_flutter/src/utils/multitenant-config.dart';

class RemoteConfigProvider {
  bool aplicacionDescuentoMaestro = true;
  bool aplicacionModuloDescuentos = true;
  bool cobranza = true;
  bool configAplicaciones = true;
  bool configDescuentoMaestro = true;
  bool configModuloDescuentos = true;
  bool controlDeDespacho = true;
  bool crearVentasDist = true;
  bool envioOrdenesTicketsComms = true;
  bool escannerDeProductos = true;
  bool gestionCatalogo = true;
  bool gestionCobranza = true;
  bool gestionDespachoEntrega = true;
  bool gestionInventarioSucursales = true;
  bool gestionPromociones = true;
  bool gestionVistas = true;
  bool guardarOrdenPedido = true;
  bool inventarioSucursales = true;
  bool promocionesVisualizacion = true;
  bool ventasDist = true;
  bool ventasRetail = true;
  bool visitas = true;
  bool vistasGeolocalizadas = true;
  bool visualizacionCatalogo = true;
  bool zonasDeVenta = true;

  Future<void> getRemoteConfig() async {
    FirebaseRemoteConfig remoteConfig =
        FirebaseRemoteConfig.instanceFor(app: multitenantConfig.tenantApp!);
    await remoteConfig.fetch();
    await remoteConfig.activate();
    var allConfigs = remoteConfig.getAll();

    allConfigs.forEach((key, value) {
      String propertyName = _transformKeyToPropertyName(key);
      _updateProperty(propertyName, value.asBool());
    });
    printBooleanVariables();
  }

  // Helper method to transform Firebase Remote Config key to property name
  String _transformKeyToPropertyName(String key) {
    List<String> parts = key.split('_');
    String propertyName = parts.first;
    for (int i = 1; i < parts.length; i++) {
      propertyName += parts[i][0].toUpperCase() + parts[i].substring(1);
    }
    return propertyName;
  }

  // Helper method to update individual properties
  void _updateProperty(String propertyName, bool value) {
    switch (propertyName) {
      case 'aplicacionDescuentoMaestro':
        aplicacionDescuentoMaestro = value;
        break;
      case 'aplicacionModuloDescuentos':
        aplicacionModuloDescuentos = value;
        break;
      case 'cobranza':
        cobranza = value;
        break;
      case 'configAplicaciones':
        configAplicaciones = value;
        break;
      case 'configDescuentoMaestro':
        configDescuentoMaestro = value;
        break;
      case 'configModuloDescuentos':
        configModuloDescuentos = value;
        break;
      case 'controlDeDespacho':
        controlDeDespacho = value;
        break;
      case 'crearVentasDist':
        crearVentasDist = value;
        break;
      case 'envioOrdenesTicketsComms':
        envioOrdenesTicketsComms = value;
        break;
      case 'escannerDeProductos':
        escannerDeProductos = value;
        break;
      case 'gestionCatalogo':
        gestionCatalogo = value;
        break;
      case 'gestionCobranza':
        gestionCobranza = value;
        break;
      case 'gestionDespachoEntrega':
        gestionDespachoEntrega = value;
        break;
      case 'gestionInventarioSucursales':
        gestionInventarioSucursales = value;
        break;
      case 'gestionPromociones':
        gestionPromociones = value;
        break;
      case 'gestionVistas':
        gestionVistas = value;
        break;
      case 'guardarOrdenPedido':
        guardarOrdenPedido = value;
        break;
      case 'inventarioSucursales':
        inventarioSucursales = value;
        break;
      case 'promocionesVisualizacion':
        promocionesVisualizacion = value;
        break;
      case 'ventasDist':
        ventasDist = value;
        break;
      case 'ventasRetail':
        ventasRetail = value;
        break;
      case 'visitas':
        visitas = value;
        break;
      case 'vistasGeolocalizadas':
        vistasGeolocalizadas = value;
        break;
      case 'visualizacionCatalogo':
        visualizacionCatalogo = value;
        break;
      case 'zonasDeVenta':
        zonasDeVenta = value;
        break;
      default:
        break;
    }
  }

  void printBooleanVariables() {
    print('remoteConfigVals:');
    print("aplicacionDescuentoMaestro: $aplicacionDescuentoMaestro");
    print("aplicacionModuloDescuentos: $aplicacionModuloDescuentos");
    print("cobranza: $cobranza");
    print("configAplicaciones: $configAplicaciones");
    print("configDescuentoMaestro: $configDescuentoMaestro");
    print("configModuloDescuentos: $configModuloDescuentos");
    print("controlDeDespacho: $controlDeDespacho");
    print("crearVentasDist: $crearVentasDist");
    print("envioOrdenesTicketsComms: $envioOrdenesTicketsComms");
    print("escannerDeProductos: $escannerDeProductos");
    print("gestionCatalogo: $gestionCatalogo");
    print("gestionCobranza: $gestionCobranza");
    print("gestionDespachoEntrega: $gestionDespachoEntrega");
    print("gestionInventarioSucursales: $gestionInventarioSucursales");
    print("gestionPromociones: $gestionPromociones");
    print("gestionVistas: $gestionVistas");
    print("guardarOrdenPedido: $guardarOrdenPedido");
    print("inventarioSucursales: $inventarioSucursales");
    print("promocionesVisualizacion: $promocionesVisualizacion");
    print("ventasDist: $ventasDist");
    print("ventasRetail: $ventasRetail");
    print("visitas: $visitas");
    print("vistasGeolocalizadas: $vistasGeolocalizadas");
    print("visualizacionCatalogo: $visualizacionCatalogo");
    print("zonasDeVenta: $zonasDeVenta");
  }
}
