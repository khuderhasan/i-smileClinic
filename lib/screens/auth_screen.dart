import '../core/app_localizations.dart';
import '../providers/auth.dart';
import '../core/constatnts.dart';
import '../core/wave_clipper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/http_exeption.dart';
import '../widgets/alert_dialog.dart';

enum AuthMode { signup, login }

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  static const routeName = '/auht_screen';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool? _isloading;
  @override
  void initState() {
    super.initState();
    _isloading = false;
  }

  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _passwordVisible = false;

  final _passwordController = TextEditingController();

  AuthMode _authMode = AuthMode.login;

  final Map<String, String?> _authData = {
    'email': '',
    'password': '',
    'fullName': null,
  };
  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    setState(() {
      _isloading = true;
    });
    _formKey.currentState?.save();
    try {
      if (_authMode == AuthMode.login) {
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email']!, _authData['password']!);
        _isloading = false;
      } else {
        await Provider.of<Auth>(context, listen: false).signUp(
            _authData['email']!,
            _authData['password']!,
            _authData['fullName']!);
        _isloading = false;
      }
    } on HttpException catch (exception) {
      String message = exception.message.toString();
      print(message);
      _isloading = false;
      if (message.contains('wrong password')) {
        message = "WrongPassword".tr(context);
      } else if (message.contains('wrong email')) {
        message = "WrongEmail".tr(context);
      } else {
        message = "AccountNotFound".tr(context);
      }
      alertDialog(
          title: "Error".tr(context),
          color: const Color.fromARGB(255, 221, 22, 8),
          message: message,
          context: context);
    }
    setState(() {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.97),
      body: SingleChildScrollView(
        child: Column(children: [
          AppBar(
            backgroundColor: const Color(0xff0177B6),
          ),
          // sign in shape
          Stack(
            children: [
              Opacity(
                opacity: 0.3,
                child: ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    height: screenHeight * 0.20,
                    color: myBlue,
                  ),
                ),
              ),
              ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  color: myBlue,
                  height: screenHeight * 0.18,
                ),
              ),
              Positioned(
                top: screenHeight * 0.0,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    _authMode == AuthMode.login
                        ? 'LOGIN'.tr(context)
                        : 'SIGNUP'.tr(context),
                    style: TextStyle(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: screenHeight * 0.05,
          ),

          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //email Textformfiel
                if (_authMode == AuthMode.signup)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 25),
                    child: TextFormField(
                      cursorColor: myBlue,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "NameWarning".tr(context);
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['fullName'] = value!;
                      },
                      decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.person),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: myBlue,
                            width: 2,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(width: 20),
                        ),
                        labelText: 'FullName'.tr(context),
                      ),
                    ),
                  ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: TextFormField(
                    cursorColor: myBlue,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return "InvalidEmail".tr(context);
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['email'] = value!;
                    },
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.email_outlined),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: myBlue,
                          width: 2,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(width: 20),
                      ),
                      labelText: "Email".tr(context),
                    ),
                  ),
                ),
                //password textField
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: !_passwordVisible,
                    cursorColor: myBlue,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 5) {
                        return "InvalidPassword".tr(context);
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['password'] = value!;
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          }),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: myBlue,
                          width: 2,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(width: 20),
                      ),
                      labelText: "Password".tr(context),
                    ),
                  ),
                ),
                //Confirm Password textField
                if (_authMode == AuthMode.signup)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 25),
                    child: TextFormField(
                      enabled: _authMode == AuthMode.signup,
                      obscureText: !_passwordVisible,
                      cursorColor: myBlue,
                      validator: _authMode == AuthMode.signup
                          ? (value) {
                              if (value != _passwordController.text) {
                                return "PasswordValidation".tr(context);
                              }
                              return null;
                            }
                          : null,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            }),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: myBlue,
                            width: 2,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(width: 20),
                        ),
                        labelText: "ConfirmPassword".tr(context),
                      ),
                    ),
                  ),
                // Sign In Button
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 140),
                  child: _isloading!
                      ? const CircularProgressIndicator()
                      : Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(0),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            color: myBlue,
                          ),
                          child: TextButton(
                            onPressed: () {
                              _submit();
                            },
                            child: Text(
                              _authMode == AuthMode.login
                                  ? "LOGIN".tr(context)
                                  : "SIGNUP".tr(context),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                ),
                //Sign Up Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextButton(
                    onPressed: _switchAuthMode,
                    child: Text(
                      '${_authMode == AuthMode.login ? "SIGNUP".tr(context) : "LOGIN".tr(context)} ${"INSTEAD".tr(context)}',
                      style: const TextStyle(
                          color: myBlue,
                          fontWeight: FontWeight.normal,
                          fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
