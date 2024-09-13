// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/provider/remote_config_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/services/database_streams.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/utils/determinePosition.dart';
import 'package:pwa_sales2go_flutter/src/utils/requestFileBottomSheet.dart';
import 'package:pwa_sales2go_flutter/src/widgets/loading/loading_widget.dart';

class AddClientPage extends StatefulWidget {
  const AddClientPage({super.key, this.userZoneDocument});

  final DocumentReference? userZoneDocument;

  @override
  State<AddClientPage> createState() => _AddClientPageState();
}

class _AddClientPageState extends State<AddClientPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<ZoneSummary?>.value(
          value: DatabaseServiceStreams().zoneSummary,
          initialData: null,
          catchError: (context, error) {
            print('ERRROR ON STREAM PROVIDER OF ZONES SUMMARY IN ADD CLIENT');
            print(error);
            return null;
          },
        ),
        StreamProvider<PricesSummary?>.value(
          initialData: null,
          catchError: (context, error) {
            print('ERROR ON STREAM PROVIDER OF PRICES IN ADD CLIENT');
            print(error);
            return null;
          },
          value: listaDePreciosRef
              .doc('resumen')
              .snapshots()
              .map(pricesSummaryFromSnapshot),
        ),
        StreamProvider<IdTypeSummary?>.value(
          initialData: null,
          catchError: (context, error) {
            print('ERROR ON STREAM PROVIDER ON IDTYPES IN ADD CLIENT');
            print(error);
            return null;
          },
          value: DatabaseServiceStreams().idTypeSummary,
        ),
      ],
      child: AddClientPageBody(userZoneDocument: widget.userZoneDocument),
    );
  }
}

class AddClientPageBody extends StatefulWidget {
  const AddClientPageBody({
    super.key,
    this.userZoneDocument,
  });

  final DocumentReference? userZoneDocument;

  @override
  State<AddClientPageBody> createState() => _AddClientPageBodyState();
}

class _AddClientPageBodyState extends State<AddClientPageBody> {
  bool isSimple = globalRemoteConfig.isClienteSimple!;

  TextEditingController? newClientName = TextEditingController();
  TextEditingController? newClientId = TextEditingController();
  TextEditingController? newclientPhone = TextEditingController();
  TextEditingController? newClientEmail = TextEditingController();
  TextEditingController? newClientAddress1 = TextEditingController();
  TextEditingController? newClientAddress2 = TextEditingController();
  TextEditingController? newClientMasterDiscount = TextEditingController();
  bool isSpecialContributor = false;
  bool isGeolocatorLoading = false;
  String? selectedIdType = 'V';
  String? selectedPriceList = 'GENER-03';
  late String? latitude = '';
  late String? longitude = '';

  // Future<Position> _getCurrentLocation() async {
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return Future.error('Location services are disabled');
  //   }
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permission');
  //   }
  //   return await Geolocator.getCurrentPosition(
  //     forceAndroidLocationManager: true,
  //   );
  // }

  File? imageFile;
  @override
  void initState() {
    super.initState();
    if (isSimple) {
      setState(() {
        selectedPriceList = 'TPGBASE';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    determinePosition();
    final pricesSummary = Provider.of<PricesSummary?>(context)?.summary ?? {};
    final idSummary = Provider.of<IdTypeSummary?>(context)?.summary ?? {};
    final zonesSummary = Provider.of<ZoneSummary?>(context)?.summary ?? {};

    List<String> idSummaryValues = List.from(idSummary.values);
    List<String> pricesSummaryValues = List.from(pricesSummary.values);
    String? newClientSalesZone = zonesSummary[widget.userZoneDocument?.id];

    // print('TEST ADD CLIENT PROVIDERS');
    // print(widget.userZoneDocument?.id);
    // print(pricesSummary);
    // print(idSummary);
    // print(idSummaryValues);
    // print(zonesSummary);
    // print(newClientSalesZone);
    // print('Monedas');

    // for (var element in coinsExhangesRates) {
    //   // print(element.exchangeRatio);
    // }
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return isGeolocatorLoading
        ? LoadingWidget(
            message: 'Obteniendo localización',
          )
        : WillPopScope(
            onWillPop: () async {
              final bool? shouldPop = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    surfaceTintColor: Color.fromARGB(255, 222, 222, 222),
                    actionsOverflowButtonSpacing: 1,
                    actionsPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    title: Center(
                      child: Text(
                        'Confirmación',
                        style: TextStyle(
                          color: themeProvider
                              .myTheme.colorScheme.onPrimaryContainer,
                          fontFamily: 'Poppins-regular',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Center(
                            child: Text(
                              'Los datos introducidos se borraran una vez salga de esta pantalla',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color:
                                    themeProvider.myTheme.colorScheme.primary,
                                fontFamily: 'Poppins-regular',
                                fontSize: 11,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              '¿Esta seguro que quieres salir?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color:
                                    themeProvider.myTheme.colorScheme.primary,
                                fontFamily: 'Poppins-regular',
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                themeProvider.myTheme.colorScheme.primary,
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                            ),
                            icon: Icon(
                              MaterialIcons.arrow_back_ios,
                              size: 16,
                              color: Colors.white,
                            ),
                            label: Text(
                              'No',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins-regular',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                themeProvider
                                    .myTheme.colorScheme.onPrimaryContainer,
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                            ),
                            icon: Icon(
                              Icons.check,
                              size: 20,
                              color: Colors.white,
                            ),
                            label: Text(
                              'Si',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins-regular',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                },
              );
              return shouldPop!;
            },
            child: Scaffold(
              backgroundColor: Colors.grey[200],
              appBar: AppBar(
                backgroundColor: themeProvider.myTheme.colorScheme.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                leadingWidth: 24.0,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: Container(
                        // margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        height: 50,
                        width: 120,
                        child: Image.asset(
                          'assets/images/agn_full.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const Text(
                      'Registro de Cliente',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins-regular',
                      ),
                    ),
                  ],
                ),
                // ignore: prefer_const_literals_to_create_immutables
              ),
              body: Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    child: Column(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Center(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                            child: Text(
                              'Ingrese los datos a continuación para la creación del cliente',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins-regular',
                                color: themeProvider
                                    .myTheme.colorScheme.onPrimaryContainer,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              TextMessageForTextField(
                                  message: 'Nombre / Razón Social'),
                              SizedBox(width: 5),
                              PointTextWidget(),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextFieldForNewClient(
                            controller: newClientName,
                            hintMessage: isSimple ? '' : 'John Doe',
                            textInputType: TextInputType.name,
                            maxLines: 1,
                            readOnly: false,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              TextMessageForTextField(
                                  message: 'Tipo de ID / N° de identificación'),
                              SizedBox(width: 5),
                              PointTextWidget(),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 100,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    hint: Text(
                                      selectedIdType ?? '',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade500,
                                        fontFamily: 'Poppins-regular',
                                      ),
                                    ),
                                    items: idSummaryValues
                                        // idTypes
                                        .map((item) => DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Poppins-regular',
                                                  color: Colors.grey.shade500,
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                    value: selectedIdType,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedIdType = value as String;
                                      });
                                      // print(selectedIdType);
                                    },
                                    buttonStyleData: ButtonStyleData(
                                      height: 45,
                                      width: 100,
                                      elevation: 0,
                                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: themeProvider
                                              .myTheme.colorScheme.primary,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,
                                      ),
                                    ),
                                    menuItemStyleData: MenuItemStyleData(
                                      height: 40,
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                      elevation: 1,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: themeProvider
                                              .myTheme.colorScheme.primary,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ),
                              Container(
                                width: 200,
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: TextFieldForNewClient(
                                  controller: newClientId,
                                  hintMessage: '11222333',
                                  textInputType: TextInputType.phone,
                                  maxLines: 1,
                                  readOnly: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                        isSimple
                            ? Container()
                            : Container(
                                margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    TextMessageForTextField(
                                        message: 'Contribuidor especial'),
                                    Container(
                                      width: 50,
                                      height: 50,
                                      child: Checkbox(
                                        shape: CircleBorder(),
                                        checkColor: Colors.white,
                                        activeColor: themeProvider
                                            .myTheme.colorScheme.primary,
                                        value: isSpecialContributor,
                                        side:
                                            MaterialStateBorderSide.resolveWith(
                                          (states) => BorderSide(
                                            // width: 2.0,
                                            color: themeProvider.myTheme
                                                .colorScheme.onPrimaryContainer,
                                          ),
                                        ),
                                        onChanged: (bool? value) {
                                          setState(() {
                                            isSpecialContributor = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        Container(
                          margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              TextMessageForTextField(
                                message: 'Telefono / Correo Electronico',
                              ),
                              SizedBox(width: 5),
                              PointTextWidget(),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 150,
                              margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: TextFieldForNewClient(
                                controller: newclientPhone,
                                hintMessage: isSimple ? '' : '000 0000',
                                textInputType: TextInputType.phone,
                                maxLines: 1,
                                readOnly: false,
                              ),
                            ),
                            Container(
                              width: 160,
                              margin: EdgeInsets.fromLTRB(5, 0, 20, 0),
                              child: TextFieldForNewClient(
                                controller: newClientEmail,
                                hintMessage:
                                    isSimple ? '' : 'example@gmail.com',
                                textInputType: TextInputType.emailAddress,
                                maxLines: 1,
                                readOnly: false,
                              ),
                            ),
                          ],
                        ),
                        isSimple
                            ? Container()
                            : Container(
                                margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    TextMessageForTextField(
                                      message: 'Dirección Fiscal',
                                    ),
                                    SizedBox(width: 5),
                                    PointTextWidget(),
                                  ],
                                ),
                              ),
                        isSimple
                            ? Container()
                            : Container(
                                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: TextFieldForNewClient(
                                  controller: newClientAddress1,
                                  hintMessage: '',
                                  textInputType: TextInputType.streetAddress,
                                  maxLines: 4,
                                  readOnly: false,
                                ),
                              ),
                        isSimple
                            ? Container()
                            : Container(
                                margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    TextMessageForTextField(
                                        message: 'Dirección de Despacho'),
                                    SizedBox(width: 5),
                                  ],
                                ),
                              ),
                        isSimple
                            ? Container()
                            : Container(
                                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: TextFieldForNewClient(
                                  controller: newClientAddress2,
                                  hintMessage: '',
                                  textInputType: TextInputType.streetAddress,
                                  maxLines: 4,
                                  readOnly: false,
                                ),
                              ),
                        isSimple
                            ? Container()
                            : Container(
                                margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    TextMessageForTextField(
                                        message: 'Zona de Ventas'),
                                    SizedBox(width: 5),
                                    PointTextWidget(),
                                  ],
                                ),
                              ),
                        isSimple
                            ? Container()
                            : Container(
                                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: TextFieldForNewClient(
                                  controller: null,
                                  hintMessage: newClientSalesZone,
                                  textInputType: TextInputType.name,
                                  maxLines: 1,
                                  readOnly: true,
                                ),
                              ),
                        isSimple
                            ? Container()
                            : Container(
                                margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    TextMessageForTextField(
                                        message: 'Lista de precios'),
                                    SizedBox(width: 5),
                                    PointTextWidget(),
                                  ],
                                ),
                              ),
                        isSimple
                            ? Container()
                            : Container(
                                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    hint: Text(
                                      selectedPriceList ?? '',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade500,
                                        fontFamily: 'Poppins-regular',
                                      ),
                                    ),
                                    items: pricesSummaryValues
                                        .map((item) => DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Poppins-regular',
                                                  color: Colors.grey.shade500,
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                    value: selectedPriceList,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedPriceList = value as String;
                                      });
                                      print(selectedPriceList);
                                    },
                                    menuItemStyleData: MenuItemStyleData(
                                      height: 40,
                                    ),
                                    alignment: Alignment.center,
                                    buttonStyleData: ButtonStyleData(
                                      height: 45,
                                      width: MediaQuery.of(context).size.width,
                                      elevation: 0,
                                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: themeProvider
                                              .myTheme.colorScheme.primary,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,
                                      ),
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                      elevation: 1,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: themeProvider
                                              .myTheme.colorScheme.primary,
                                        ),
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        isSimple
                            ? Container()
                            : Container(
                                margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    TextMessageForTextField(
                                        message: 'Descuento maestro (%)'),
                                    SizedBox(width: 5),
                                    PointTextWidget(),
                                  ],
                                ),
                              ),
                        isSimple
                            ? Container()
                            : Container(
                                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: TextFieldForNewClient(
                                  controller: newClientMasterDiscount,
                                  hintMessage: '',
                                  textInputType: TextInputType.phone,
                                  maxLines: 1,
                                  readOnly: false,
                                ),
                              ),
                        // LOCALIZACION, COMENTADO POR PROBLEMAS DE USO SIN GOOGLE
                        // PLAY SERVICES
                        isSimple
                            ? Container()
                            : Container(
                                margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    TextMessageForTextField(
                                        message: 'Geolocalización'),
                                    SizedBox(width: 5),
                                  ],
                                ),
                              ),
                        isSimple
                            ? Container()
                            : Row(
                                children: [
                                  Container(
                                    width: 120,
                                    margin: EdgeInsets.fromLTRB(20, 0, 10, 0),
                                    child: TextFieldForNewClient(
                                      controller: null,
                                      hintMessage: latitude,
                                      textInputType: TextInputType.name,
                                      maxLines: 1,
                                      readOnly: true,
                                    ),
                                  ),
                                  Container(
                                    width: 120,
                                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: TextFieldForNewClient(
                                      controller: null,
                                      hintMessage: longitude,
                                      textInputType: TextInputType.name,
                                      maxLines: 1,
                                      readOnly: true,
                                    ),
                                  ),
                                  Container(
                                    width: 50,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.place_sharp,
                                        color: themeProvider
                                            .myTheme.colorScheme.primary,
                                      ),
                                      onPressed: () async {
                                        // Obtener Localización (latitud y longitud);
                                        determinePosition().then((value) {
                                          latitude =
                                              '${value?.latitude.toStringAsFixed(4)}';
                                          longitude =
                                              '${value?.longitude.toStringAsFixed(4)}';
                                          print(latitude);
                                          print(longitude);
                                          print('GEOLOCATOR');
                                          setState(() {});
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                        isSimple ? Container() : SizedBox(height: 10),
                        SizedBox(height: 10),
                        isSimple
                            ? Container()
                            : InkWell(
                                onTap: () async {
                                  requestFileBottomSheet(context, (image) {
                                    setState(() {
                                      imageFile = image;
                                    });
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: Row(
                                    // ignore: prefer_const_literals_to_create_immutables
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.camera,
                                        color: themeProvider.myTheme.colorScheme
                                            .onPrimaryContainer,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        // AppLocalizations.of(context)!.gallery,
                                        'Subir Imagen',
                                        style: TextStyle(
                                          color: themeProvider
                                              .myTheme.colorScheme.primary,
                                          fontFamily: 'Poppins-regular',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        isSimple
                            ? Container()
                            : imageFile == null
                                ? Container()
                                : GestureDetector(
                                    onTap: () {
                                      ScaffoldMessenger.of(context)
                                        ..removeCurrentSnackBar()
                                        ..showSnackBar(
                                          SnackBar(
                                            backgroundColor: themeProvider
                                                .myTheme
                                                .colorScheme
                                                .onPrimaryContainer,
                                            duration:
                                                const Duration(seconds: 1),
                                            content: Text(
                                              "Toque la imagen dos veces para removerla ",
                                              style: const TextStyle(
                                                fontFamily: 'Poppins-regular',
                                              ),
                                            ),
                                          ),
                                        );
                                    },
                                    onDoubleTap: () {
                                      setState(() => imageFile = null);
                                      ScaffoldMessenger.of(context)
                                        ..removeCurrentSnackBar()
                                        ..showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.green,
                                            duration:
                                                const Duration(seconds: 1),
                                            content: Text(
                                              "Imagen removida",
                                              style: const TextStyle(
                                                fontFamily: 'Poppins-regular',
                                              ),
                                            ),
                                          ),
                                        );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(20, 5, 20, 0),
                                      // height: 300,
                                      // width: 300,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: themeProvider
                                              .myTheme.colorScheme.primary,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(9),
                                        child: Image.file(
                                          imageFile!,
                                          fit: BoxFit.contain,
                                          // height: 300,
                                          // width: 300,
                                        ),
                                      ),
                                    ),
                                  ),
                        SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () async {
                            // Registrar nuevo Cliente
                            if (isSimple
                                ? (newClientName!.text.toString().isEmpty ||
                                    newClientId!.text.toString().isEmpty ||
                                    !RegExp(r'^[0-9_.]+$').hasMatch(
                                        newClientId!.text.toString()) ||
                                    newclientPhone!.text.toString().isEmpty ||
                                    newClientEmail!.text.toString().isEmpty)
                                : (newClientName!.text.toString().isEmpty ||
                                    newClientId!.text.toString().isEmpty ||
                                    !RegExp(r'^[0-9_.]+$').hasMatch(
                                        newClientId!.text.toString()) ||
                                    newclientPhone!.text.toString().isEmpty ||
                                    newClientEmail!.text.toString().isEmpty ||
                                    newClientAddress1!.text
                                        .toString()
                                        .isEmpty ||
                                    newClientMasterDiscount!.text
                                        .toString()
                                        .isEmpty ||
                                    !RegExp(r'^[0-9_.]+$').hasMatch(
                                      newClientMasterDiscount!.text.toString(),
                                    ))) {
                              print(imageFile);
                              ScaffoldMessenger.of(context)
                                ..removeCurrentSnackBar()
                                ..showSnackBar(
                                  SnackBar(
                                    backgroundColor:
                                        themeProvider.myTheme.colorScheme.error,
                                    duration: const Duration(seconds: 1),
                                    content: Text(
                                      "Uno de los campos requeridos esta vacio",
                                      style: const TextStyle(
                                        fontFamily: 'Poppins-regular',
                                      ),
                                    ),
                                  ),
                                );
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  actionsOverflowButtonSpacing: 1,
                                  actionsPadding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                  title: Center(
                                    child: Text(
                                      'Confirmación',
                                      style: TextStyle(
                                        color: themeProvider.myTheme.colorScheme
                                            .onPrimaryContainer,
                                        fontFamily: 'Poppins-regular',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      // ignore: prefer_const_literals_to_create_immutables
                                      children: [
                                        Center(
                                          child: Text(
                                            'Este registro de cliente será guardado',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: themeProvider
                                                  .myTheme.colorScheme.primary,
                                              fontFamily: 'Poppins-regular',
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            '¿Desea continuar?',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: themeProvider
                                                  .myTheme.colorScheme.primary,
                                              fontFamily: 'Poppins-regular',
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              themeProvider
                                                  .myTheme.colorScheme.primary,
                                            ),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                              ),
                                            ),
                                          ),
                                          icon: Icon(
                                            MaterialIcons.arrow_back_ios,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                          label: Text(
                                            'No',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Poppins-regular',
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton.icon(
                                          onPressed: () async {
                                            final String
                                                newClientNameForFirebase =
                                                newClientName!.text
                                                    .trim()
                                                    .toUpperCase();
                                            final int newClientIdForFirebase =
                                                int.parse(newClientId!.text
                                                    .trim()
                                                    .toString());
                                            final String
                                                newclientPhoneForFirebase =
                                                newclientPhone!.text
                                                    .trim()
                                                    .toString();
                                            final String
                                                newClientEmailForFirebase =
                                                newClientEmail!.text.trim()
                                                  ..toString();
                                            final String
                                                newClientAddress1ForFirebase =
                                                isSimple
                                                    ? ''
                                                    : newClientAddress1!.text
                                                        .trim()
                                                        .toString();
                                            final String
                                                newClientAddress2ForFirebase =
                                                isSimple
                                                    ? ''
                                                    : newClientAddress2!.text
                                                        .trim()
                                                        .toString();
                                            final int
                                                newClientMasterDiscountForFirebase =
                                                isSimple
                                                    ? 0
                                                    : int.parse(
                                                        newClientMasterDiscount
                                                                ?.text
                                                                .trim()
                                                                .toString() ??
                                                            '0');
                                            final userUid =
                                                Provider.of<UserModel?>(context,
                                                        listen: false)!
                                                    .uid;
                                            ScaffoldMessenger.of(context)
                                              ..removeCurrentSnackBar()
                                              ..showSnackBar(
                                                SnackBar(
                                                  backgroundColor: themeProvider
                                                      .myTheme
                                                      .colorScheme
                                                      .primary,
                                                  duration: const Duration(
                                                      seconds: 1),
                                                  content: Text(
                                                    "Registrando Cliente",
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          'Poppins-regular',
                                                    ),
                                                  ),
                                                ),
                                              );

                                            await registerClient(
                                              isSpecialContributor: isSimple
                                                  ? false
                                                  : isSpecialContributor,
                                              newClientAddress1:
                                                  newClientAddress1ForFirebase,
                                              newClientAddress2:
                                                  newClientAddress2ForFirebase,
                                              newClientEmail:
                                                  newClientEmailForFirebase,
                                              newClientId:
                                                  newClientIdForFirebase,
                                              newClientMasterDiscount:
                                                  newClientMasterDiscountForFirebase,
                                              newClientName:
                                                  newClientNameForFirebase,
                                              newClientSalesZone:
                                                  newClientSalesZone!,
                                              newclientPhone:
                                                  newclientPhoneForFirebase,
                                              selectedIdType: selectedIdType!,
                                              uid: userUid!,
                                              selectedPricesList:
                                                  selectedPriceList!,
                                              image:
                                                  isSimple ? null : imageFile,
                                              latitude:
                                                  isSimple ? '' : latitude,
                                              longitude:
                                                  isSimple ? '' : longitude,
                                              userZoneDocument:
                                                  widget.userZoneDocument,
                                            ).whenComplete(() {
                                              ScaffoldMessenger.of(context)
                                                ..removeCurrentSnackBar()
                                                ..showSnackBar(
                                                  SnackBar(
                                                    backgroundColor:
                                                        Colors.green,
                                                    duration: const Duration(
                                                        seconds: 1),
                                                    content: Text(
                                                      "Registro exitoso",
                                                      style: const TextStyle(
                                                        fontFamily:
                                                            'Poppins-regular',
                                                      ),
                                                    ),
                                                  ),
                                                );
                                            }).whenComplete(() {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            });
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              themeProvider.myTheme.colorScheme
                                                  .onPrimaryContainer,
                                            ),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                              ),
                                            ),
                                          ),
                                          icon: Icon(
                                            MaterialCommunityIcons.content_save,
                                            size: 20,
                                          ),
                                          label: Text(
                                            'Si',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Poppins-regular',
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              themeProvider.myTheme.colorScheme.primary,
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                          ),
                          icon: Icon(
                            Icons.person_add_alt_1,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Registrar Cliente',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Poppins-regular',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}

class TextFieldForNewClient extends StatelessWidget {
  const TextFieldForNewClient({
    super.key,
    required this.controller,
    required this.hintMessage,
    required this.textInputType,
    required this.maxLines,
    required this.readOnly,
  });

  final TextEditingController? controller;
  final String? hintMessage;
  final TextInputType? textInputType;
  final int? maxLines;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return TextField(
      readOnly: readOnly,
      controller: controller,
      style: TextStyle(
        fontSize: 14,
        fontFamily: 'Poppins-regular',
        color: themeProvider.myTheme.colorScheme.primary,
      ),
      keyboardType: textInputType,
      maxLines: maxLines,
      maxLength: 100,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 0),
        hintText: hintMessage,
        hintStyle: TextStyle(
          fontFamily: 'Poppins-regular',
          fontSize: 14,
          color: themeProvider.myTheme.colorScheme.primary.withOpacity(0.7),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: themeProvider.myTheme.colorScheme.primary,
          ),
        ),
        counterText: '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      onChanged: (value) {
        print(value);
      },
    );
  }
}

class TextMessageForTextField extends StatelessWidget {
  const TextMessageForTextField({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Text(
      message,
      style: TextStyle(
        fontFamily: 'Poppins-regular',
        color: themeProvider.myTheme.colorScheme.primary,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class PointTextWidget extends StatelessWidget {
  const PointTextWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Text(
      '·',
      style: TextStyle(
        fontFamily: 'Poppins-regular',
        color: themeProvider.myTheme.colorScheme.error,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
