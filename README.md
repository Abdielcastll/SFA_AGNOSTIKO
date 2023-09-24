# Field Sales

Desarrollo de aplicación financiera retail y distribuidor para suite Agnostiko.

## Estructura del proyecto

```
├── android                 # Archivos de compilación para android
├── assets                  # Directorio de archivos estaticos para la app (imagenes, tipografia, etc)
├── lib                     # Codigo fuente
    ├── dialogs             # Dialogs para uso en el proyecto
    ├── examples            # Estructuras mockeadas
    ├── helper              # Codigo generado para uso del carrito
    ├── l10n                # Archivos de lenguajes de la app
    ├── src                 # Codigo fuente de la aplicacion (paginas, componentes, pharos, etc)
    └── main.dart           # Punto de entrada de la app flutter
├── l10n.yaml               # Configuracion de plugin para lenguajes
├── pubspec.yaml            # Archivo de dependencias flutter
└── README.md
```

## Ejecutar aplicacion modo debug

```bash
flutter run --dart-define=IMPLEMENTATION=<compilacion-sdkone>
```

## Compilar instalador APK

```bash
flutter build apk --dart-define=IMPLEMENTATION=<compilacion-sdkone>
```

### Implementaciones disponibles:

- newland_nsdk # Terminales Newland Android 7.1
- pax # Terminales PAX

## Multitenant

La configuracion multitenant se encuentra dentro de [lib/src/utils/multitenant-config.dart](./lib/src/utils/multitenant-config.dart) y depende de la configuracion del terminal dentro del TMS Agnostiko o InsightOne y de su agente para terminales para obtenerla.

Para inicializar la funcion multitenant es necesario ejecutar el metodo `initialize`, si no se requiere la funcion multitenant se puede utilizar el metodo `initializePhone` para inicializar la BD por defecto configurada con firebase.
