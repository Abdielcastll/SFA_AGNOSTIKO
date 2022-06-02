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
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_login.dart';
import 'package:pwa_sales2go_flutter/src/widgets/custom_text_field.dart';
import 'package:pwa_sales2go_flutter/src/widgets/loading_dialog.dart';
import 'package:pwa_sales2go_flutter/src/widgets/splashscreen_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      // barrierDismissible: false,
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
      // print(auth.user);
    }).catchError((errorMessage) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Usuario o Contraseñas invalidos');
    });
    if (currentUser != null) {
      checkIfUserRecordExists(currentUser!);
    }
  }

  checkIfUserRecordExists(User currentUser) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(currentUser.uid)
        .get()
        .then((record) async {
      // Comprobar si se obtiene informacion de la coleccion
      if (record.exists) {
        // En caso de que el registro exista
        try {
          print(
              'Usuario activo y conexión establecida, intento de almacenar datos extraidos de la base de datos en una variable global');
          // Verificar si el usuario esta activo
          if (record.data()!['activo'] == true) {
            print('El usuario esta activo');
            // Proceder a cuadra la información en variable global
            await sharedPreferences.setString('uid', currentUser.uid);
            print("Se ha almacenado: ${sharedPreferences.getString('uid')}");
            await sharedPreferences.setString('email', currentUser.email!);
            print("Se ha almacenado: ${sharedPreferences.getString('email')}");
            await sharedPreferences.setString(
                'nombre', record.data()!['nombre']);
            print("Se ha almacenado: ${sharedPreferences.getString('nombre')}");
            await sharedPreferences.setInt(
                'nro_cedula', record.data()!['nro_cedula']);
            print(
                "Se ha almacenado: ${sharedPreferences.getInt('nro_cedula')}");
            // Obtener lista del indice
            List<String> indice = record.data()!['indice'].cast<String>();
            await sharedPreferences.setStringList('indice', indice);
            print(
                "Se ha almacenado: ${sharedPreferences.getStringList('indice')}");
            // Revisar si es gerente
            if (record.data()!['esGerente'] == false) {
              // Si no es gerente, verificar si es vendedor
              if (record.data()!['esVendedor'] == false) {
                // Si no es vendedor, entonces se le asigna cargo = cobrador
                await sharedPreferences.setString('cargo', 'cobrador');
              } else {
                // Si es vendedor, asignar cargo = vendedor
                await sharedPreferences.setString('cargo', 'vendedor');
              }
            } else {
              // Si es gerente, almacenar que cargo = gerente
              await sharedPreferences.setString('cargo', 'gerente');
            }
            print('Se ha almacenado: ${sharedPreferences.getString('cargo')}');
            print('login exitoso, datos extraidos');
            // Enviar el usuario a la homePage
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (c) => SplashScreenWidget(),
              ),
            );
          } else {
            print('El usuario no esta activo');
            Navigator.pop(context);
            Fluttertoast.showToast(msg: 'Usuario no activo o bloqueado');
          }
        } catch (e) {
          print(e);
        }
      } else {
        // En caso de que el registro no exista
        FirebaseAuth.instance.signOut();
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: 'Este usuario no existe dentro de la base de datos');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use of Appbaroffline Widget
      appBar: AppBarLogin(
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
