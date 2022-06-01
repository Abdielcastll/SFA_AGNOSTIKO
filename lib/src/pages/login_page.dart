// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pwa_sales2go_flutter/src/auth/auth.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/pages/home_page.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_home.dart';
import 'package:pwa_sales2go_flutter/src/widgets/custom_text_field.dart';
import 'package:pwa_sales2go_flutter/src/widgets/loading_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  validateForm() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      // Allow user to login
      loginNow();
    } else {
      Fluttertoast.showToast(msg: 'Por favor ingrese su correo y contraseña');
    }
  }

  loginNow() async {
    showDialog(
      context: context,
      builder: (c) {
        return LoadingDialogWidget(
          message: 'Revisando credenciales',
        );
      },
    );

    User? currentUser;
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user;
    }).catchError((errorMessage) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Hubo un error inesperado: \n $errorMessage');
    });
    if (currentUser != null) {
      checkIfUserRecordExists(currentUser!);
    }
  }

  checkIfUserRecordExists(User currentUser) async {
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(currentUser.uid)
        .get()
        .then(
      ((record) async {
        // Comprobar si User record existe
        if (record.exists) {
          // En caso de que exista
          if (record.data()!['activo'] == 'activo') {
            // Enviar usuario a la home screen
            // Guardar información localmente
            await sharedPreferences!.setString('email', currentUser.email!);
            await sharedPreferences!.setString('uid', currentUser.uid);
            await sharedPreferences!
                .setString('nombre', record.data()!['nombre']);
            await sharedPreferences!
                .setString('nro_cedula', record.data()!['nro_cedula']);
            // Obtener lista del indice
            List<String> indice = record.data()!['indice'].cast<String>();
            await sharedPreferences!.setStringList('indice', indice);
            // Revisar si es gerente
            if (record.data()!['esGerente'] == false) {
              // En caso de no ser gerente, revisar si es vendedor
              if (record.data()!['esVendedor'] == false) {
                // En caso de no ser vendedor, se le asigna cobrador
                await sharedPreferences!.setString('cargo', 'cobrador');
              } else {
                // En caso de ser vendedor, se le asigna vendedor
                await sharedPreferences!.setString('cargo', 'vendedor');
              }
            } else {
              // Si se verifica que es gerente, asignar rol a gerente
              await sharedPreferences!.setString('cargo', 'gerente');
            }
            // Enviar usuario a la home screen
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (c) => HomePage(),
              ),
            );
          }
        } else {
          // En caso de que no exista
          Fluttertoast.showToast(
              msg: 'Este usuario no existe o no esta activo');
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use of Appbaroffline Widget
      appBar: AppBarHome(
        title: 'Login',
        // backgroundColor: Color(0xFF4f42ed),
      ),
      // Body of the Login
      body: _loginBody(context),
    );
  }

  Widget _loginBody(context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'Bienvenido a Sales2Go!',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Image.asset('assets/images/logo.png'),
            SizedBox(height: 20),
            Text(
              'Ingresa tus datos para iniciar sesión:',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 30),
            // Inputs form Fields
            Form(
              key: formKey,
              child: Column(
                children: [
                  // Para el email
                  CustomTextField(
                    textEditingController: emailController,
                    iconData: Icons.email_rounded,
                    hintText: 'Email',
                    isObsecure: false,
                    enabled: true,
                  ),

                  // Para la contraseña
                  CustomTextField(
                    textEditingController: passwordController,
                    iconData: Icons.lock_rounded,
                    hintText: 'Contraseña',
                    isObsecure: true,
                    enabled: true,
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Login
                validateForm();
              },
              icon: Icon(Icons.login_rounded),
              label: Text(
                'Iniciar Sesión',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF009B77),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
