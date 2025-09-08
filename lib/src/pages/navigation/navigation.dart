// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:io';

import 'package:agnostiko/agnostiko.dart';
import 'package:agnostiko/device/src/device.dart';
import 'package:agnostiko/ped/src/crypto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/core/font_size.dart';
import 'package:pwa_sales2go_flutter/pharos/pharos.dart';
import 'package:pwa_sales2go_flutter/src/features/product/data/product_list_info.dart';
import 'package:pwa_sales2go_flutter/src/features/product/domain/repositories/backoffice_services.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/catalogue/catalogue_page_kiosko.dart';
import 'package:pwa_sales2go_flutter/src/pages/profile/profile_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/catalogue/catalogue_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/diary_tabs.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/provider/remote_config_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/utils/comm.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_sales2go_flutter/src/utils/notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationPages extends StatelessWidget {
  const NavigationPages({Key? key}) : super(key: key);

  Future<DeviceType> _getDeviceType(BuildContext context) async {
    FontSize.initialize(context);
    await ProductListInfo.instance;
    return await getDeviceType();
  }

  Future<void> validateKeyInitialization(BuildContext context) async {
    bool keyExists = await cryptoDUKPTCheckKeyExists(1);
    if (keyExists) {
      print('Ya existe la llave');

      _tryKeyInitialization(context);
    } else {
      _tryKeyInitialization(context);
    }
  }

  Future<void> _tryKeyInitialization(BuildContext context) async {
    // showCircularProgressDialog(context, 'Procesando');
    try {
      await _keyInitializationPharos(context);

      print('Llaves inicializadas');
    } on SocketException catch (e) {
      Navigator.pop(context);

      print('error ${e.message}');
    } on StateError catch (e) {
      Navigator.pop(context);
      print('error ${e.message}');
    } catch (e) {
      // Navigator.pop(context);
      print('error $e');
    }
  }

// Function to show login dialog with attempt counter
  Future<bool> _showLoginDialog(
      BuildContext context, AuthService authService) async {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    bool isLoading = false;
    int attempts = 0;
    bool success = false;

    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: Text("Inicio de sesión pharos (${attempts + 1}/3)"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(labelText: "Email"),
                      ),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(labelText: "Contraseña"),
                        obscureText: true,
                      ),
                      if (isLoading) ...[
                        SizedBox(height: 20),
                        CircularProgressIndicator(),
                      ],
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context)
                          .pop(false), // Cancel and return false
                      child: Text("Cancelar"),
                    ),
                    TextButton(
                      onPressed: () async {
                        print("attempting login");
                        if (attempts >= 3)
                          return; // Prevent further attempts after 3

                        setState(() => isLoading = true);
                        print("attempting login call");

                        success = await authService.authenticateUser(
                          emailController.text,
                          passwordController.text,
                        );
                        print("htto: $success");
                        if (success) {
                          // Save user credentials in SharedPreferences
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setString(
                              'saved_email', emailController.text);
                          await prefs.setString(
                              'saved_password', passwordController.text);
                          print("Credentials saved to SharedPreferences");
                        }
                        setState(() {
                          isLoading = false;
                          attempts++;
                        });

                        if (success || attempts >= 3) {
                          print("pop dialog $success, $attempts");

                          Navigator.of(context).pop(success);
                        }
                      },
                      child: Text("Ingresar"),
                    ),
                  ],
                );
              },
            );
          },
        ) ??
        false; // If dialog is dismissed, return false
  }

// Function to show a simple message dialog
  void _showMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _keyInitializationPharos(BuildContext context) async {
    AuthService authService = AuthService();
    bool success = false;

    // Step 1: Try serial number authentication first
    String? serialNumber = await getSerialNumber();
    if (serialNumber != null) {
      success = await authService.authenticateUserBySerialNumber(serialNumber);
      print("tried serial");
    }

    if (!success) {
      String? savedEmail = 'npg@gmail.com';
      String? savedPassword = 'Npg%1234';

      if (savedEmail != null && savedPassword != null) {
        print("Using saved credentials for login...");
        success = await authService.authenticateUser(savedEmail, savedPassword);
      }
    }

    // Step 3: If saved credentials fail or don’t exist, show login dialog (max 3 attempts)
    if (!success) {
      print("Prompting user for login...");
      success = await _showLoginDialog(context, authService);
    }

    // Step 4: If all user attempts fail, use default credentials
    if (!success) {
      print("Using default user credentials...");
      if (!context.mounted) return;

      _showMessage(context, "Usando usuario por defecto: pvt@gmail.com");

      success = await authService.authenticateUser(
        // "psh@gmail.com", // usuario prosa real
        // "Psh%1234",
        "pvt@gmail.com", //pruebas productivas
        "Pvt%1234",
      );
    }

    // FINAL CHECK: If still not authenticated, stop execution
    if (!success) {
      print("auth failed");

      if (!context.mounted) return;

      _showMessage(
          context, "Autenticación fallida. Intente nuevamente más tarde.");
      return;
    }

    // --- AUTHENTICATION SUCCESS: CONTINUE WITH KEY INITIALIZATION ---
    final capx = CapX(1);
    final tk =
        await capx.getEncryptedTransportKey("assets/capx/public_pharos.pem");

    final pharosMsgKeyInit = await pharosGenerateKeyInitialization(
      cipheredTK: tk.keyData,
      kcv: tk.kcv,
    );

    print('Generar mensaje a pharos');
    print(pharosMsgKeyInit);

    final pharosResponse = await processKeyInitPharos(pharosMsgKeyInit);
    print('pharos responde $pharosResponse');

    final encryptedK0 = pharosResponse.encryptedNewKey;
    final ksn = pharosResponse.newKeyKsn;

    try {
      await cryptoLoadIPEK(
        1,
        ksn.toHexBytes(),
        encryptedK0.toHexBytes(),
        kekIndex: 10,
      );
      var ksno = await cryptoDUKPTGetKSN(1);
      print("setksn: ${ksno!.toHexStr()}");
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    validateKeyInitialization(context);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    initializeGenericClient();
    return FutureBuilder<DeviceType>(
      future: _getDeviceType(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading spinner while waiting for the device type
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Handle any errors
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // Once we have the device type, we can build the screens
          final deviceType = snapshot.data;
          List<Widget> destinationWidgets = [
            if (globalRemoteConfig.visualizacionCatalogo == true)
              NavigationDestination(
                icon: Icon(
                  Icons.store_outlined,
                  size: 24,
                  color: Color.fromARGB(255, 196, 196, 196),
                ),
                selectedIcon: Icon(
                  Icons.store,
                  size: 24,
                  color: Color.fromARGB(255, 196, 196, 196),
                ),
                label: AppLocalizations.of(context)!.home,
              ),
            if (globalRemoteConfig.showAgendaMenu == true)
              NavigationDestination(
                icon: Icon(
                  Icons.calendar_today_outlined,
                  size: 24,
                  color: Color.fromARGB(255, 196, 196, 196),
                ),
                selectedIcon: Icon(
                  Icons.calendar_today,
                  size: 24,
                  color: Color.fromARGB(255, 196, 196, 196),
                ),
                label: AppLocalizations.of(context)!.diary,
              ),
            if (globalRemoteConfig.clientesEnabled == true &&
                globalRemoteConfig.clientesMenuDisabled == false)
              NavigationDestination(
                icon: Icon(
                  Icons.group_outlined,
                  size: 24,
                  color: Color.fromARGB(255, 196, 196, 196),
                ),
                selectedIcon: Icon(
                  Icons.group,
                  size: 24,
                  color: Color.fromARGB(255, 196, 196, 196),
                ),
                label: AppLocalizations.of(context)!.clients,
              ),
            if (deviceType != DeviceType.PINPAD)
              NavigationDestination(
                icon: Icon(
                  Icons.person_outline,
                  size: 24,
                  color: Color.fromARGB(255, 196, 196, 196),
                ),
                selectedIcon: Icon(
                  Icons.person,
                  size: 24,
                  color: Color.fromARGB(255, 196, 196, 196),
                ),
                label: AppLocalizations.of(context)!.profile,
              ),
          ];

          final screens = [
            if (globalRemoteConfig.visualizacionCatalogo == true)
              const CataloguePage(),
            if (globalRemoteConfig.showAgendaMenu == true) const DiaryTabs(),
            if (globalRemoteConfig.clientesEnabled == true &&
                globalRemoteConfig.clientesMenuDisabled == false)
              const ClientsPage(),
            if (deviceType != DeviceType.PINPAD) const ProfilePage(),
          ];

          CounterLimitFirestore counterLimitFirestore =
              Provider.of<CounterLimitFirestore>(context);
          CurrentUserInfo user = Provider.of<CurrentUserInfo>(context);
          NotificationService notificationService =
              context.watch<NotificationService>();

          if (user.role != null && user.role != '') {
            notificationService.initialize(user.uid);
          }

          if (globalRemoteConfig.conversionKiosko == true) {
            return Scaffold(
              body: const CataloguePageKiosko(),
            );
          } else if (destinationWidgets.length < 2) {
            return Scaffold(
              body: CataloguePage(),
            );
          } else if (destinationWidgets.isEmpty) {
            return Scaffold(
              body: Center(
                child: Text("Ningun modulo activo"),
              ),
            );
          } else {
            return Scaffold(
              body: IndexedStack(
                index: counterLimitFirestore.currentScreen,
                children: screens,
              ),
              bottomNavigationBar: NavigationBarTheme(
                data: NavigationBarThemeData(
                  indicatorColor: themeProvider.myTheme.colorScheme.tertiary
                      .withOpacity(0.2),
                  labelTextStyle: MaterialStateProperty.all(
                    const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 196, 196, 196),
                      fontFamily: 'Poppins-Regular',
                    ),
                  ),
                ),
                child: NavigationBar(
                  height: 56.0,
                  backgroundColor: themeProvider.myTheme.colorScheme.primary,
                  labelBehavior:
                      NavigationDestinationLabelBehavior.onlyShowSelected,
                  animationDuration: const Duration(seconds: 1),
                  selectedIndex: counterLimitFirestore.currentScreen,
                  onDestinationSelected: (int i) {
                    counterLimitFirestore.setNewScreen(i);
                  },
                  destinations: destinationWidgets,
                ),
              ),
            );
          }
        }
      },
    );
  }
}
