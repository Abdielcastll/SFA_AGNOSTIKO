import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:pwa_sales2go_flutter/src/utils/multitenant-config.dart';

RemoteConfig globalRemoteConfig = RemoteConfig();

class RemoteConfig {
  bool? aplicacionDescuentoMaestro;
  bool? aplicacionModuloDescuentos;
  bool? configAplicaciones;
  bool? configDescuentoMaestro;
  bool? configModuloDescuentos;
  bool? controlDeDespacho;
  bool? crearVentasDist;
  bool? envioOrdenesTicketsComms;
  bool? escannerDeProductos;
  bool? gestionCatalogo;
  bool? gestionCobranza;
  bool? gestionDespachoEntrega;
  bool? gestionInventarioSucursales;
  bool? gestionPromociones;
  bool? gestionVistas;
  bool? guardarOrdenPedido;
  bool? inventarioSucursales;
  bool? promocionesVisualizacion;
  bool? ventasDist;
  bool? ventasRetail;
  bool? visitas;
  bool? vistasGeolocalizadas;
  bool? visualizacionCatalogo;
  bool? zonasDeVenta;
  bool? notificaciones;

  RemoteConfig({
    this.aplicacionDescuentoMaestro,
    this.aplicacionModuloDescuentos,
    this.configAplicaciones,
    this.configDescuentoMaestro,
    this.configModuloDescuentos,
    this.controlDeDespacho,
    this.crearVentasDist,
    this.envioOrdenesTicketsComms,
    this.escannerDeProductos,
    this.gestionCatalogo,
    this.gestionCobranza,
    this.gestionDespachoEntrega,
    this.gestionInventarioSucursales,
    this.gestionPromociones,
    this.gestionVistas,
    this.guardarOrdenPedido,
    this.inventarioSucursales,
    this.promocionesVisualizacion,
    this.ventasDist,
    this.ventasRetail,
    this.visitas,
    this.vistasGeolocalizadas,
    this.visualizacionCatalogo,
    this.zonasDeVenta,
  });

  Map<String, dynamic> toMap() {
    return {
      'aplicacionDescuentoMaestro': aplicacionDescuentoMaestro,
      'aplicacionModuloDescuentos': aplicacionModuloDescuentos,
      'configAplicaciones': configAplicaciones,
      'configDescuentoMaestro': configDescuentoMaestro,
      'configModuloDescuentos': configModuloDescuentos,
      'controlDeDespacho': controlDeDespacho,
      'crearVentasDist': crearVentasDist,
      'envioOrdenesTicketsComms': envioOrdenesTicketsComms,
      'escannerDeProductos': escannerDeProductos,
      'gestionCatalogo': gestionCatalogo,
      'gestionCobranza': gestionCobranza,
      'gestionDespachoEntrega': gestionDespachoEntrega,
      'gestionInventarioSucursales': gestionInventarioSucursales,
      'gestionPromociones': gestionPromociones,
      'gestionVistas': gestionVistas,
      'guardarOrdenPedido': guardarOrdenPedido,
      'inventarioSucursales': inventarioSucursales,
      'promocionesVisualizacion': promocionesVisualizacion,
      'ventasDist': ventasDist,
      'ventasRetail': ventasRetail,
      'visitas': visitas,
      'vistasGeolocalizadas': vistasGeolocalizadas,
      'visualizacionCatalogo': visualizacionCatalogo,
      'zonasDeVenta': zonasDeVenta,
    };
  }
}

class RemoteConfigProvider {
  Future<void> getRemoteConfig() async {
    FirebaseRemoteConfig remoteConfig =
        FirebaseRemoteConfig.instanceFor(app: multitenantConfig.tenantApp!);
    await remoteConfig.fetch();
    await remoteConfig.activate();
    var allConfigs = remoteConfig.getAll();

    // print('RemoteConfig firebase:');
    // allConfigs.forEach((key, value) {
    //   print('$key: ${value.asBool()}');
    // });

    RemoteConfig remoteConfigModel = RemoteConfig(
      aplicacionDescuentoMaestro:
          allConfigs['aplicacionDescuentoMaestro']?.asBool() ?? true,
      aplicacionModuloDescuentos:
          allConfigs['aplicacionModuloDescuentos']?.asBool() ?? true,
      configAplicaciones: allConfigs['configAplicaciones']?.asBool() ?? true,
      configDescuentoMaestro:
          allConfigs['configDescuentoMaestro']?.asBool() ?? true,
      configModuloDescuentos:
          allConfigs['configModuloDescuentos']?.asBool() ?? true,
      controlDeDespacho: allConfigs['controlDeDespacho']?.asBool() ?? true,
      crearVentasDist: allConfigs['crearVentasDist']?.asBool() ?? true,
      envioOrdenesTicketsComms:
          allConfigs['envioOrdenesTicketsComms']?.asBool() ?? true,
      escannerDeProductos: allConfigs['escannerDeProductos']?.asBool() ?? true,
      gestionCatalogo: allConfigs['gestionCatalogo']?.asBool() ?? true,
      gestionCobranza: allConfigs['gestionCobranza']?.asBool() ?? true,
      gestionDespachoEntrega:
          allConfigs['gestionDespachoEntrega']?.asBool() ?? true,
      gestionInventarioSucursales:
          allConfigs['gestionInventarioSucursales']?.asBool() ?? true,
      gestionPromociones: allConfigs['gestionPromociones']?.asBool() ?? true,
      gestionVistas: allConfigs['gestionVistas']?.asBool() ?? true,
      guardarOrdenPedido: allConfigs['guardarOrdenPedido']?.asBool() ?? true,
      inventarioSucursales:
          allConfigs['inventarioSucursales']?.asBool() ?? true,
      promocionesVisualizacion:
          allConfigs['promocionesVisualizacion']?.asBool() ?? true,
      ventasDist: allConfigs['ventasDist']?.asBool() ?? true,
      ventasRetail: allConfigs['ventasRetail']?.asBool() ?? true,
      visitas: allConfigs['visitas']?.asBool() ?? true,
      vistasGeolocalizadas:
          allConfigs['vistasGeolocalizadas']?.asBool() ?? true,
      visualizacionCatalogo:
          allConfigs['visualizacionCatalogo']?.asBool() ?? true,
      zonasDeVenta: allConfigs['zonasDeVenta']?.asBool() ?? true,
    );

    globalRemoteConfig = remoteConfigModel;
    //printProperties(globalRemoteConfig);
  }

  void printProperties(RemoteConfig model) {
    final properties = model.toMap();
    print('RemoteConfig saved:');
    properties.forEach((key, value) {
      print('$key: $value');
    });
  }
}
