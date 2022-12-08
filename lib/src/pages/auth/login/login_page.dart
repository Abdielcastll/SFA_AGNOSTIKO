// ignore_for_file: prefer_const_constructors

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pwa_sales2go_flutter/src/services/auth.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_login.dart';
import 'package:pwa_sales2go_flutter/src/widgets/loading/loading_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();
  final formKey = GlobalKey<FormState>();
  bool loading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingWidget(
            message: 'Verificando Credenciales',
          )
        : Scaffold(
            appBar: AppBarLogin(
              title: 'Login',
              backgroundColor: myTheme.colorScheme.primary,
            ),
            body: _loginBody(context),
            backgroundColor: Colors.white,
          );
  }

  Widget _loginBody(context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 125.0),
            Container(
              alignment: Alignment.center,
              width: 400.0,
              child: Image.asset('assets/images/logo.png'),
            ),
            const SizedBox(height: 50.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 35.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Iniciar sesión',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                  fontFamily: 'Poppins-regular',
                ),
              ),
            ),
            const SizedBox(height: 5.0),
            Form(
              key: formKey,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 35),
                    child: TextFormField(
                      maxLines: 1,
                      maxLength: 100,
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      cursorColor: myTheme.colorScheme.secondary,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(fontFamily: 'Poppins-regular'),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            left: 20.0, top: 10.0, right: 10.0),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: const BorderSide(
                            color: Color(0xFF4f42ed),
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 191, 191, 191)),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        focusColor: Theme.of(context).primaryColor,
                        labelText: 'Email',
                        suffixIcon: Icon(
                          Icons.email,
                          size: 20,
                          color: myTheme.colorScheme.secondary,
                        ),
                      ),
                      validator: (email) =>
                          email != null && !EmailValidator.validate(email)
                              ? 'Email inválido'
                              : null,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 35),
                    child: TextFormField(
                      obscureText: true,
                      maxLines: 1,
                      maxLength: 100,
                      controller: passwordController,
                      cursorColor: myTheme.colorScheme.secondary,
                      style: TextStyle(fontFamily: 'Poppins-regular'),
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            left: 20.0, top: 10.0, right: 10.0),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: const BorderSide(
                            color: Color(0xFF4f42ed),
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 231, 209, 209)),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        focusColor: Theme.of(context).primaryColor,
                        labelText: 'Contraseña',
                        suffixIcon: Icon(
                          Icons.lock,
                          size: 20,
                          color: myTheme.colorScheme.secondary,
                        ),
                      ),
                      validator: (password) =>
                          password != null && password.length < 6
                              ? 'Contraseña inválida'
                              : null,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40.0),
            SizedBox(
              width: 300.0,
              child: ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });
                    final user = await _auth.signInWithEmailAndPassword(
                      emailController.text.toString(),
                      passwordController.text.toString(),
                    );
                    if (user == null) {
                      setState(() {
                        loading = false;
                      });
                    }
                  }
                },
                style: ButtonStyle(
                  alignment: Alignment.center,
                  backgroundColor: MaterialStateProperty.all<Color>(
                    myTheme.colorScheme.primary,
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: myTheme.colorScheme.primary),
                    ),
                  ),
                ),
                child: const Text(
                  'Iniciar Sesión',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    fontFamily: 'Poppins-regular',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80.0),
          ],
        ),
      ),
    );
  }
}
