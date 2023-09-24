# Field Sales

Desarrollo de aplicación financiera retail y distribuidor para suite Agnostiko.

## Estructura del proyecto

```
├── android                 # Archivos de compilación para android
├── assets                  # Directorio de archivos estaticos para la app (imagenes, tipografia, etc)
├── lib                     # Codigo fuente
    ├── config              # Archivos de configuracion del proyecto
    ├── dialogs             # Dialogs para uso en el proyecto
    ├── examples            # Estructuras mockeadas
    ├── helper              # Codigo generado para uso del carrito
    ├── l10n                # Archivos de lenguajes de la app
    └── src                 # Codigo fuente de la aplicacion (paginas, componentes, pharos, etc)
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


