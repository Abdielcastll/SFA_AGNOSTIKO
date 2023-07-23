// Colecciones de informacion dentro de la DB

// Colecciones de productos
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';

final productsCollection = firebase.collection('productos');

// Coleccion de Zonas
final zonesCollection = firebase.collection('zonas');

// Coleccion de tamanos
final sizesCollection = firebase.collection('tamanos');

// Coleccion de sub categorias
final subCategoriesCollection = firebase.collection('subcategorias');

// Coleccion de stock
final stockCollection = firebase.collection('stock');

// Collecion de roles
final rolesCollection = firebase.collection('roles');

// Collecion de promociones
final promotionsCollection = firebase.collection('promociones');

// Collecion de monedas
final coinCollection = firebase.collection('monedas');

// Collecion de precios
final pricesCollection = firebase.collection('listas_de_precios');

// Collecion de lineas
final linesCollection = firebase.collection('lineas');

// Collecion de equipos
final teamsCollection = firebase.collection('equipos');

// Collecion de dispositivos
final devicesCollection = firebase.collection('dispositivos');

// Collecion de disenos
final designsCollection = firebase.collection('disenos');

// Collecion de config
final configCollection = firebase.collection('config');

// Collecion de clientes
final clientsCollection = firebase.collection('clientes');

// Collecion de categorias
final categoriesCollection = firebase.collection('categorias');

// Collecion de catalogo
final catalogueCollection = firebase.collection('catalogos');

// Collecion de catalogo_productos
final brandsCollection = firebase.collection('marcas');

//Coleccion de Calidades
final qualityCollection = firebase.collection('calidades');

//Coleccion de tipos de Id
final idTypeCollection = firebase.collection('tipos_id');

//Coleccion del usuarios
final usersCollection = firebase.collection('usuarios');

final banksCollection = firebase.collection('bancos');
