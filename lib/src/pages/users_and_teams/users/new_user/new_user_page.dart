import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class NewUserPage extends StatefulWidget {
  const NewUserPage({super.key});

  @override
  State<NewUserPage> createState() => _NewUserPageState();
}

class _NewUserPageState extends State<NewUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nuevo usuario',
          style: TextStyle(
            letterSpacing: 0,
            fontSize: 22,
            fontFamily: 'Poppins-regular',
          ),
        ),
        elevation: 0,
        leadingWidth: 24.0,
        backgroundColor: myTheme.colorScheme.primary,
      ),
      backgroundColor: Colors.white,
      body: const NewUserBody(),
    );
  }
}

class NewUserBody extends StatefulWidget {
  const NewUserBody({
    Key? key,
  }) : super(key: key);

  @override
  State<NewUserBody> createState() => _NewUserBodyState();
}

class _NewUserBodyState extends State<NewUserBody> {
  final nameController = TextEditingController();
  final docController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final validatePasswordController = TextEditingController();
  String? roleController;
  final List<String> items = [
    'Debt Collector',
    'Manager',
    'Vendedor',
    'Administrador',
    'Cobrador',
    'Ejemplo 1',
    'Ejemplo 2',
    'Ejemplo 3',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                    child: const Text(
                      'Nombre y Apellido',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins-regular',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                    height: 50,
                    width: 170,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: myTheme.colorScheme.primary.withOpacity(0.2),
                        // color: Colors.transparent,
                      ),
                    ),
                    child: TextField(
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins-regular',
                        color: myTheme.colorScheme.primary,
                      ),
                      keyboardType: TextInputType.name,
                      maxLines: 1,
                      maxLength: 50,
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [
                        FilteringTextInputFormatter.singleLineFormatter
                      ],
                      controller: nameController,

                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(14, 0, 0, 0),
                        hintText: 'Victor Velasquez',
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins-regular',
                          fontSize: 14,
                          color: myTheme.colorScheme.primary.withOpacity(0.2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      // onChanged: searchClient,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child: const Text(
                      'Cedula de Identidad',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins-regular',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                    height: 50,
                    width: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: myTheme.colorScheme.primary.withOpacity(0.2),
                      ),
                    ),
                    child: TextField(
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins-regular',
                        color: myTheme.colorScheme.primary,
                      ),
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      maxLength: 50,
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: docController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(14, 0, 0, 0),
                        hintText: 'XX.XXX.XXX',
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins-regular',
                          fontSize: 14,
                          color: myTheme.colorScheme.primary.withOpacity(0.2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      // onChanged: searchClient,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.fromLTRB(20, 20, 0, 0),
            child: const Text(
              'E-mail',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins-regular',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: myTheme.colorScheme.primary.withOpacity(0.2),
              ),
            ),
            child: TextField(
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins-regular',
                color: myTheme.colorScheme.primary,
              ),
              keyboardType: TextInputType.emailAddress,
              maxLines: 1,
              maxLength: 50,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                FilteringTextInputFormatter.singleLineFormatter
              ],
              controller: emailController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(14, 0, 0, 0),
                hintText: 'example@gmail.com',
                hintStyle: TextStyle(
                  fontFamily: 'Poppins-regular',
                  fontSize: 14,
                  color: myTheme.colorScheme.primary.withOpacity(0.2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                  ),
                ),
              ),
              // onChanged: searchClient,
            ),
          ),
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                    child: const Text(
                      'Contraseña',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins-regular',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: myTheme.colorScheme.primary.withOpacity(0.2),
                      ),
                    ),
                    child: TextField(
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins-regular',
                        color: myTheme.colorScheme.primary,
                      ),
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      maxLines: 1,
                      maxLength: 50,
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [
                        FilteringTextInputFormatter.singleLineFormatter
                      ],
                      controller: passwordController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(14, 0, 0, 0),
                        hintText: 'Contraseña',
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins-regular',
                          fontSize: 14,
                          color: myTheme.colorScheme.primary.withOpacity(0.2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      // onChanged: searchClient,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child: const Text(
                      'Validar Contraseña',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins-regular',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: myTheme.colorScheme.primary.withOpacity(0.2),
                      ),
                    ),
                    child: TextField(
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins-regular',
                        color: myTheme.colorScheme.primary,
                      ),
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      maxLines: 1,
                      maxLength: 50,
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [
                        FilteringTextInputFormatter.singleLineFormatter
                      ],
                      controller: validatePasswordController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(14, 0, 0, 0),
                        hintText: 'Contraseña',
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins-regular',
                          fontSize: 14,
                          color: myTheme.colorScheme.primary.withOpacity(0.2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      // onChanged: searchClient,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.fromLTRB(20, 20, 0, 10),
            child: const Text(
              'Validar Contraseña',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins-regular',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              isExpanded: true,
              hint: Row(
                children: [
                  Expanded(
                    child: Text(
                      roleController ?? 'Seleccione un estado',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: myTheme.colorScheme.primary.withOpacity(0.3),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              items: items
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: myTheme.colorScheme.primary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                  .toList(),
              value: roleController,
              onChanged: (value) {
                setState(() {
                  roleController = value as String;
                });
              },
              iconStyleData: IconStyleData(
                icon: const Icon(
                  Icons.arrow_forward_ios_outlined,
                ),
                iconSize: 11,
                iconEnabledColor: myTheme.colorScheme.primary.withOpacity(0.3),
                iconDisabledColor: Colors.grey,
              ),
              buttonStyleData: ButtonStyleData(
                height: 50,
                width: 320,
                padding: const EdgeInsets.only(left: 14, right: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: myTheme.colorScheme.primary.withOpacity(0.3),
                  ),
                  color: Colors.white,
                ),
                elevation: 0,
              ),
              menuItemStyleData: MenuItemStyleData(
                height: 40,
                padding: const EdgeInsets.only(left: 14, right: 14),
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 200,
                width: 200,
                padding: null,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                elevation: 8,
                scrollbarTheme: ScrollbarThemeData(
                  radius: const Radius.circular(10),
                  thickness: MaterialStateProperty.all<double>(6),
                  thumbVisibility: MaterialStateProperty.all<bool>(true),
                ),
                offset: const Offset(-20, 0),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                child: Text(
                  'Regresar',
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 14,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 20, 20, 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: myTheme.colorScheme.primary,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'CONTINUAR',
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                      child: Icon(
                        SimpleLineIcons.arrow_right,
                        size: 14,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
