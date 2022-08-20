import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_loging.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String message = '';
  bool isLogin = true;
  final TextEditingController email = TextEditingController();

  final TextEditingController password = TextEditingController();
  FirebaseAuthentication auth = FirebaseAuthentication();
  @override
  void initState() {
    Firebase.initializeApp().whenComplete(() {
      auth = FirebaseAuthentication();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          isLogin ? 'Login here' : 'Sign Up',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Spacer(
                flex: 3,
              ),
              Center(
                child: TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter your email address',
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.grey, fontSize: 16),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          const BorderSide(width: 1.2, color: Colors.redAccent),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          const BorderSide(width: 0.4, color: Colors.red),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          const BorderSide(width: 0.4, color: Colors.red),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          const BorderSide(width: 1.2, color: Colors.redAccent),
                    ),
                  ),
                  validator: ((val) {
                    if (val!.isEmpty) {
                      return 'Email is required';
                    }
                    return null;
                  }),
                ),
              ),
              const Spacer(
                flex: 1,
              ),
              TextFormField(
                controller: password,
                obscureText: true,
                obscuringCharacter: '#',
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.grey, fontSize: 16),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(width: 0.4, color: Colors.red),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(width: 0.4, color: Colors.red),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(width: 1.2, color: Colors.redAccent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(width: 1.2, color: Colors.redAccent),
                  ),
                ),
                validator: ((val) {
                  if (val!.isEmpty) {
                    return 'Password is required';
                  }
                  return null;
                }),
              ),
              const Spacer(
                flex: 3,
              ),
              InkWell(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    String userId = '';
                    if (isLogin) {
                      auth.loginUser(email.text, password.text).then((value) {
                        if (value == null) {
                          setState(() {
                            message = 'Login Error';
                          });
                        } else {
                          userId = value;
                          setState(() {
                            message = 'User $userId successfully logged in';
                          });
                          Navigator.pushNamed(context, 'HOME',
                              arguments: userId);
                        }
                      });
                    } else {
                      auth.createUser(email.text, password.text).then((value) {
                        if (value == null) {
                          setState(() {
                            message = 'Registration Error';
                          });
                        } else {
                          userId = value;
                          setState(() {
                            message = 'User $userId successfully signed in';
                          });
                        }
                      });
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );
                  }
                },
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Text(
                      isLogin ? 'LOGIN' : 'SIGN UP',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const Spacer(
                flex: 1,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
                child: Center(
                  child: Text(
                    isLogin ? 'Register' : 'Login',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.redAccent),
                  ),
                ),
              ),
              const Spacer(
                flex: 3,
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
