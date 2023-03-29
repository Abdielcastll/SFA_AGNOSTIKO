// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/idtype_model.dart';
import 'package:pwa_sales2go_flutter/src/models/prices_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/services/database_streams.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_navigation.dart';

class AddClientPage extends StatefulWidget {
  const AddClientPage({super.key, this.userZoneDocument});

  final DocumentReference? userZoneDocument;

  @override
  State<AddClientPage> createState() => _AddClientPageState();
}

class _AddClientPageState extends State<AddClientPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      StreamProvider<ZoneSummary?>.value(
        value: DatabaseServiceStreams().zoneSummary,
        initialData: null,
        catchError: (context, error) {
          print('ERRROR ON STREAM PROVIDER OF ZONES SUMMARY IN ADD CLIENT');
          print(error);
        },
      ),
      StreamProvider<List<Prices>?>.value(
        initialData: [],
        catchError: (context, error) {
          print('ERROR ON STREAM PROVIDER OF PRICES IN ADD CLIENT');
          print(error);
        },
        value: pricesCollection.snapshots().map(priceListfromSnapshot),
      ),
      StreamProvider<IdTypeSummary?>.value(
        initialData: null,
        catchError: (context, error) {
          print('ERROR ON STREAM PROVIDER ON IDTYPES IN ADD CLIENT');
          print(error);
        },
        value: DatabaseServiceStreams().idTypeSummary,
      ),
    ], child: AddClientPageBody(userZoneDocument: widget.userZoneDocument));
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
  TextEditingController? newClientName = TextEditingController();
  TextEditingController? newClientId = TextEditingController();
  TextEditingController? newclientPhone = TextEditingController();
  TextEditingController? newClientEmail = TextEditingController();
  TextEditingController? newClientAddress1 = TextEditingController();
  TextEditingController? newClientAddress2 = TextEditingController();
  TextEditingController? newClientMasterDiscount = TextEditingController();
  bool isSpecialContributor = false;
  String? selectedIdType = 'V';
  String? selectedPriceList = 'GENER-03';
  late String? latitude = '';
  late String? longitude = '';

  File? imageFile;

  // final List<String> idTypes = ['V', 'K', 'J'];
  final List<String> pricesList = [
    'GENER-03',
    'GENER-04',
    'GENER-11',
    'TPGBASE'
  ];

  getFromGallery(context) async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return pickedFile;
    } else {
      return;
    }
  }

  cropImage(filePath, imageFile) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    if (croppedImage != null) {
      return croppedImage;
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permission');
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    final pricesSummary = Provider.of<List<Prices>?>(context) ?? [];
    final idSummary = Provider.of<IdTypeSummary?>(context)?.summary ?? {};
    final zonesSummary = Provider.of<ZoneSummary?>(context)?.summary ?? {};
    List<String> idSummaryValues = List.from(idSummary.values);
    String? newClientSalesZone = zonesSummary[widget.userZoneDocument?.id];

    print('TEST ADD CLIENT PROVIDERS');
    print(widget.userZoneDocument?.id);
    print(pricesSummary);
    print(idSummary);
    print(idSummaryValues);
    print(zonesSummary);
    print(newClientSalesZone);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
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
                        color: myTheme.colorScheme.onPrimaryContainer,
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
                      TextMessageForTextField(message: 'Nombre / Razón Social'),
                      SizedBox(width: 5),
                      PointTextWidget(),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextFieldForNewClient(
                    controller: newClientName,
                    hintMessage: 'John Doe',
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
                              print(selectedIdType);
                            },
                            buttonHeight: 45,
                            buttonWidth: 100,
                            itemHeight: 40,
                            alignment: Alignment.center,
                            buttonElevation: 0,
                            buttonPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            buttonDecoration: BoxDecoration(
                              border: Border.all(
                                color: myTheme.colorScheme.primary,
                              ),
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                            ),
                            dropdownElevation: 1,
                            dropdownDecoration: BoxDecoration(
                              border: Border.all(
                                color: myTheme.colorScheme.primary,
                              ),
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                            ),
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
                Container(
                  margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      TextMessageForTextField(message: 'Contribuidor especial'),
                      Container(
                        width: 50,
                        height: 50,
                        child: Checkbox(
                          shape: CircleBorder(),
                          checkColor: Colors.white,
                          activeColor: myTheme.colorScheme.primary,
                          value: isSpecialContributor,
                          side: MaterialStateBorderSide.resolveWith(
                            (states) => BorderSide(
                              // width: 2.0,
                              color: myTheme.colorScheme.onPrimaryContainer,
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
                          message: 'Telefono / Correo Electronico'),
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
                        hintMessage: '000 0000',
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
                        hintMessage: 'example@gmail.com',
                        textInputType: TextInputType.emailAddress,
                        maxLines: 1,
                        readOnly: false,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      TextMessageForTextField(message: 'Dirección Fiscal'),
                      SizedBox(width: 5),
                      PointTextWidget(),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextFieldForNewClient(
                    controller: newClientAddress1,
                    hintMessage: '',
                    textInputType: TextInputType.streetAddress,
                    maxLines: 4,
                    readOnly: false,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      TextMessageForTextField(message: 'Dirección de Despacho'),
                      SizedBox(width: 5),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextFieldForNewClient(
                    controller: newClientAddress2,
                    hintMessage: '',
                    textInputType: TextInputType.streetAddress,
                    maxLines: 4,
                    readOnly: false,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      TextMessageForTextField(message: 'Zona de Ventas'),
                      SizedBox(width: 5),
                      PointTextWidget(),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextFieldForNewClient(
                    controller: null,
                    hintMessage: newClientSalesZone,
                    textInputType: TextInputType.name,
                    maxLines: 1,
                    readOnly: true,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      TextMessageForTextField(message: 'Lista de precios'),
                      SizedBox(width: 5),
                      PointTextWidget(),
                    ],
                  ),
                ),
                Container(
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
                      items: pricesList
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
                      buttonHeight: 45,
                      buttonWidth: MediaQuery.of(context).size.width,
                      itemHeight: 40,
                      alignment: Alignment.center,
                      buttonElevation: 0,
                      buttonPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      buttonDecoration: BoxDecoration(
                        border: Border.all(
                          color: myTheme.colorScheme.primary,
                        ),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      dropdownElevation: 1,
                      dropdownDecoration: BoxDecoration(
                        border: Border.all(
                          color: myTheme.colorScheme.primary,
                        ),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
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
                      TextMessageForTextField(message: 'Descuento maestro (%)'),
                      SizedBox(width: 5),
                      PointTextWidget(),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextFieldForNewClient(
                    controller: newClientMasterDiscount,
                    hintMessage: '',
                    textInputType: TextInputType.phone,
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
                      TextMessageForTextField(message: 'Geolocalización'),
                      SizedBox(width: 5),
                    ],
                  ),
                ),
                Row(
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
                          Icons.search,
                          color: myTheme.colorScheme.primary,
                        ),
                        onPressed: () {
                          // Geolocator
                          _getCurrentLocation().then((value) {
                            latitude = '${value.latitude}';
                            longitude = '${value.longitude}';
                            setState(() {});
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  // AppLocalizations.of(context)!.selectFile,
                  'Seleccionar Archivo',
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () async {
                    var pickedFile = await getFromGallery(context);
                    if (pickedFile != null) {
                      print('Imagen seleccionada');
                      var croppedImage =
                          await cropImage(pickedFile.path, imageFile);
                      if (croppedImage != null) {
                        print('Imagen recortada');
                        setState(() {
                          imageFile = File(croppedImage.path);
                        });
                      } else {
                        print('Error croppeando');
                      }
                    } else {
                      print('error seleccionando');
                      return;
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera,
                          color: myTheme.colorScheme.secondary,
                        ),
                        Text(
                          // AppLocalizations.of(context)!.gallery,
                          'Galeria',
                          style: TextStyle(
                            color: myTheme.colorScheme.primary,
                            fontFamily: 'Poppins-regular',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                imageFile == null
                    ? Container()
                    : Container(
                        margin: EdgeInsets.only(top: 5),
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: myTheme.colorScheme.primary,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.file(
                          imageFile!,
                          height: 300,
                          width: 300,
                        ),
                      ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () async {
                    // Registrar nuevo Cliente
                    if (newClientName!.text.toString().isEmpty ||
                        newClientId!.text.toString().isEmpty ||
                        !RegExp(r'^[0-9_.]+$')
                            .hasMatch(newClientId!.text.toString()) ||
                        newclientPhone!.text.toString().isEmpty ||
                        newClientEmail!.text.toString().isEmpty ||
                        newClientAddress1!.text.toString().isEmpty ||
                        newClientMasterDiscount!.text.toString().isEmpty ||
                        !RegExp(r'^[0-9_.]+$').hasMatch(
                          newClientMasterDiscount!.text.toString(),
                        )) {
                      print(imageFile);
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            backgroundColor: myTheme.colorScheme.error,
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
                      final String newClientNameForFirebase =
                          newClientName!.text.toString();
                      final int newClientIdForFirebase =
                          int.parse(newClientId!.text.toString());
                      final String newclientPhoneForFirebase =
                          newclientPhone!.text.toString();
                      final String newClientEmailForFirebase =
                          newClientEmail!.text.toString();
                      final String newClientAddress1ForFirebase =
                          newClientAddress1!.text.toString();
                      final String newClientAddress2ForFirebase =
                          newClientAddress2!.text.toString();
                      final int newClientMasterDiscountForFirebase = int.parse(
                          newClientMasterDiscount?.text.toString() ?? '0');
                      // final isSpecialContributorForFirebase = isSpecialContributor;
                      // final String selectedIdTypeForFirebase = selectedIdType!;
                      // final String newClientSalesZoneForFirebase =
                      //     newClientSalesZone!;
                      final userUid =
                          Provider.of<UserModel?>(context, listen: false)!.uid;
                      print(imageFile);

                      await registerClient(
                        isSpecialContributor: isSpecialContributor,
                        newClientAddress1: newClientAddress1ForFirebase,
                        newClientAddress2: newClientAddress2ForFirebase,
                        newClientEmail: newClientEmailForFirebase,
                        newClientId: newClientIdForFirebase,
                        newClientMasterDiscount:
                            newClientMasterDiscountForFirebase,
                        newClientName: newClientNameForFirebase,
                        newClientSalesZone: newClientSalesZone!,
                        newclientPhone: newclientPhoneForFirebase,
                        selectedIdType: selectedIdType!,
                        uid: userUid!,
                        selectedPricesList: selectedPriceList!,
                        image: imageFile,
                        latitude: latitude,
                        longitude: longitude,
                      ).whenComplete(() {
                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 1),
                              content: Text(
                                "Registro exitoso",
                                style: const TextStyle(
                                  fontFamily: 'Poppins-regular',
                                ),
                              ),
                            ),
                          );
                      }).whenComplete(() {
                        Navigator.pop(context);
                      });
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      myTheme.colorScheme.primary,
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                  icon: Icon(Icons.person_add_alt_1),
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
    return TextField(
      readOnly: readOnly,
      controller: controller,
      style: TextStyle(
        fontSize: 14,
        fontFamily: 'Poppins-regular',
        color: myTheme.colorScheme.primary,
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
          color: myTheme.colorScheme.primary.withOpacity(0.7),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: myTheme.colorScheme.primary,
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
    return Text(
      message,
      style: TextStyle(
        fontFamily: 'Poppins-regular',
        color: myTheme.colorScheme.primary,
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
    return Text(
      '·',
      style: TextStyle(
        fontFamily: 'Poppins-regular',
        color: myTheme.colorScheme.error,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
