// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:carousel_slider/carousel_slider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/pages/auth/login/email_page.dart';
import 'package:pwa_sales2go_flutter/src/services/auth.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/loading/loading_widget.dart';
import 'package:restart_app/restart_app.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // final AuthService _auth = AuthService();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      emailController.text = sharedPreferences!.getString("tenantEmail")!;
    });
    if (emailController.text == '') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => EmailPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return loading
        ? LoadingWidget(
            message: 'Verificando Credenciales',
          )
        : Scaffold(
            body: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: themeProvider.myTheme.colorScheme.primary,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 80,
                    ),
                    Header(),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFBFF),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                      child: InputWrapper(
                        emailController: emailController,
                        passwordController: passwordController,
                        formKey: formKey,
                        loading: loading,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

class InputWrapper extends StatefulWidget {
  const InputWrapper({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    required this.loading,
  });
  final TextEditingController? emailController;
  final TextEditingController? passwordController;
  final GlobalKey<FormState> formKey;
  final bool loading;

  @override
  State<InputWrapper> createState() => _InputWrapperState();
}

class _InputWrapperState extends State<InputWrapper> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFFFFBFF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: InputField(
                emailController: widget.emailController,
                passwordController: widget.passwordController,
                formKey: widget.formKey,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Text(
                "Recuperar contraseña",
                style: TextStyle(
                  color: Color(0xFF7D5070),
                  fontFamily: 'Poppins-Regular',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Button(
              emailController: widget.emailController,
              formKey: widget.formKey,
              loading: widget.loading,
              passwordController: widget.passwordController,
            ),
            SizedBox(
              height: 40,
            ),
            Button2(
              loading: widget.loading,
            ),
            SizedBox(
              height: 40,
            ),
            Image.asset(
              'assets/images/powered.png',
            ),
          ],
        ),
      ),
    );
  }
}

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  int activeIndex = 0;
  final assetsImages = [
    "assets/images/logo_prosa_blanco.png",
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CarouselSlider.builder(
                    itemCount: assetsImages.length,
                    options: CarouselOptions(
                      height: 200,
                      autoPlay: false,
                      // autoPlayInterval: Duration(seconds: 5),
                      viewportFraction: 1,
                      enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      onPageChanged: (index, reason) {
                        setState(() => activeIndex = index);
                      },
                    ),
                    itemBuilder: (context, index, realIndex) {
                      final assetsImage = assetsImages[index];
                      return Container(
                        color: Colors.transparent,
                        child: Image.asset(
                          assetsImage,
                          fit: BoxFit.contain,
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 80,
                  ),
                  AnimatedSmoothIndicator(
                    activeIndex: activeIndex,
                    count: assetsImages.length,
                    effect: ExpandingDotsEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      dotColor: Colors.white,
                      activeDotColor: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Button2 extends StatefulWidget {
  Button2({
    super.key,
    required this.loading,
  });

  final bool loading;

  @override
  State<Button2> createState() => _ButtonState2();
}

class _ButtonState2 extends State<Button2> {
  final AuthService _auth = AuthService();
  late bool loading;
  @override
  initState() {
    super.initState();
    loading = widget.loading;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return loading
        ? Center(
            child: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text(
                'Verificando credenciales...',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins-regular',
                  color: themeProvider.myTheme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ))
        : Container(
            width: 328,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ElevatedButton(
              onPressed: () async {
                await sharedPreferences!.setString('tenantEmail', '');
                print("restartApp");
                // ignore: use_build_context_synchronously
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Cambio de Tennant'),
                      content: Text(
                        'Se va a reiniciar la app para poder cambiar de tennant correctamente',
                      ),
                    );
                  },
                );
                await Future.delayed(Duration(seconds: 8));
                Restart.restartApp();
              },
              style: ButtonStyle(
                alignment: Alignment.center,
                backgroundColor: MaterialStateProperty.all<Color>(
                  themeProvider.myTheme.colorScheme.secondary,
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                        color: themeProvider.myTheme.colorScheme.primary),
                  ),
                ),
              ),
              child: Text(
                'Cambiar Tennant',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
  }
}

class Button extends StatefulWidget {
  Button({
    super.key,
    required this.formKey,
    required this.loading,
    required this.emailController,
    required this.passwordController,
  });

  final formKey;
  final bool loading;
  final emailController;
  final passwordController;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  final AuthService _auth = AuthService();
  late bool loading;
  @override
  initState() {
    super.initState();
    loading = widget.loading;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return loading
        ? Center(
            child: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text(
                'Verificando credenciales...',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins-regular',
                  color: themeProvider.myTheme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ))
        : Container(
            width: 328,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ElevatedButton(
              onPressed: () async {
                if (widget.formKey.currentState!.validate()) {
                  setState(() {
                    loading = true;
                  });
                  bool userLogged = await _auth.signInWithEmailAndPassword(
                    widget.emailController.text.toString(),
                    widget.passwordController.text.toString(),
                    context,
                  );
                  sharedPreferences!.setString(
                    "tenantEmail",
                    widget.emailController.text.toString(),
                  );
                  if (userLogged) {
                    print("restartApp");
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Configuración inicial'),
                          content: Text(
                              'Se va a reiniciar la app para terminar de configurar tu usuario.'),
                        );
                      },
                    );
                    await Future.delayed(Duration(seconds: 5));
                    Restart.restartApp();
                  } else {
                    print("error logging");

                    setState(() {
                      loading = false;
                    });
                  }
                }
              },
              style: ButtonStyle(
                alignment: Alignment.center,
                backgroundColor: MaterialStateProperty.all<Color>(
                  themeProvider.myTheme.colorScheme.primary,
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                        color: themeProvider.myTheme.colorScheme.primary),
                  ),
                ),
              ),
              child: Text(
                'Ingresar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
  }
}

class InputField extends StatefulWidget {
  const InputField({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
  });
  final TextEditingController? emailController;
  final TextEditingController? passwordController;
  final GlobalKey<FormState> formKey;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            child: Text(
              "¡Hola de nuevo!",
              style: TextStyle(
                fontFamily: 'Poppins-Regular',
                fontSize: 28,
                fontWeight: FontWeight.w400,
                color: themeProvider.myTheme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            height: 56,
            width: 328,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextFormField(
              controller: widget.emailController,
              onChanged: (value) {
                print("emailController: ${widget.emailController?.text}");
              },
              maxLines: 1,
              keyboardType: TextInputType.emailAddress,
              cursorColor: themeProvider.myTheme.colorScheme.primary,
              textInputAction: TextInputAction.next,
              style: TextStyle(
                fontFamily: 'Poppins-regular',
                color: themeProvider.myTheme.colorScheme.primary,
              ),
              validator: (email) =>
                  email != null && !EmailValidator.validate(email)
                      ? 'Email inválido'
                      : null,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(
                  // RegExp(r'[0-9]+[.]{0,1}[0-9]*'),
                  RegExp(r"^[a-zA-Z0-9@.!#$%&'*+-/=?^_`{|}~\u00f1]*"),
                ),
              ],
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                focusColor: Theme.of(context).primaryColor,
                hintText: "Correo",
                hintStyle: TextStyle(
                  color: Color(0xFF5A5D77),
                  fontFamily: 'Poppins-Regular',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.25,
                ),
                filled: true,
                fillColor: Colors.white,
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            height: 56,
            width: 328,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextFormField(
              controller: widget.passwordController,
              onChanged: (value) {
                print("passwordController: ${widget.passwordController?.text}");
              },
              maxLines: 1,
              keyboardType: TextInputType.emailAddress,
              cursorColor: themeProvider.myTheme.colorScheme.primary,
              textInputAction: TextInputAction.next,
              obscureText: true,
              style: TextStyle(
                fontFamily: 'Poppins-regular',
                color: themeProvider.myTheme.colorScheme.primary,
              ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(
                  // RegExp(r'[0-9]+[.]{0,1}[0-9]*'),
                  RegExp(r"^[a-zA-Z0-9@.!#$%&'*+-/=?^_`{|}~\u00f1]*"),
                ),
              ],
              validator: (password) => password != null && password.length < 6
                  ? 'Contraseña inválida'
                  : null,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                focusColor: Theme.of(context).primaryColor,
                hintText: "Contraseña",
                hintStyle: TextStyle(
                  color: Color(0xFF5A5D77),
                  fontFamily: 'Poppins-Regular',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.25,
                ),
                filled: true,
                fillColor: Colors.white,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
