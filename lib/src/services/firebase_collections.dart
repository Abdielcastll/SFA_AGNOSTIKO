// Colecciones de informacion dentro de la DB

// Colecciones de productos
import 'package:cloud_firestore/cloud_firestore.dart';

final productsCollection = FirebaseFirestore.instance.collection('productos');

// Coleccion de Zonas
final zonesCollection = FirebaseFirestore.instance.collection('zonas');

// Coleccion de tamanos
final sizesCollection = FirebaseFirestore.instance.collection('tamanos');

// Coleccion de sub categorias
final subCategoriesCollection =
    FirebaseFirestore.instance.collection('subcategorias');

// Coleccion de stock
final stockCollection = FirebaseFirestore.instance.collection('stock');

// Collecion de roles
final rolesCollection = FirebaseFirestore.instance.collection('roles');

// Collecion de promociones
final promotionsCollection =
    FirebaseFirestore.instance.collection('promociones');

// Collecion de monedas
final coinCollection = FirebaseFirestore.instance.collection('monedas');

// Collecion de precios
final pricesCollection =
    FirebaseFirestore.instance.collection('lista_de_precios');

// Collecion de lineas
final linesCollection = FirebaseFirestore.instance.collection('lineas');

// Collecion de equipos
final teamsCollection = FirebaseFirestore.instance.collection('equipos');

// Collecion de dispositivos
final devicesCollection = FirebaseFirestore.instance.collection('dispositivos');

// Collecion de disenos
final designsCollection = FirebaseFirestore.instance.collection('disenos');

// Collecion de config
final configCollection = FirebaseFirestore.instance.collection('config');

// Collecion de clientes
final clientsCollection = FirebaseFirestore.instance.collection('clientes');

// Collecion de categorias
final categoriesCollection =
    FirebaseFirestore.instance.collection('categorias');

// Collecion de catalogo
final catalogueCollection = FirebaseFirestore.instance.collection('catalogos');

// Collecion de catalogo_productos
final brandsCollection = FirebaseFirestore.instance.collection('marcas');

//Coleccion de Calidades
final qualityCollection = FirebaseFirestore.instance.collection('calidades');

//Coleccion de tipos de Id
final idTypeCollection = FirebaseFirestore.instance.collection('tipos_id');
