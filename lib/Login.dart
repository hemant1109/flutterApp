import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreenStateFull(),
    );
  }
}

SnackBar _snackBar(
    {required String text, String? actionLabel, VoidCallback? callback}) {
  return SnackBar(
    content: Text(text),
    action: (actionLabel != null && callback != null)
        ? SnackBarAction(
            label: actionLabel,
            onPressed: callback,
          )
        : null,
  );
}

class LoginScreenStateFull extends StatefulWidget {
  const LoginScreenStateFull({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreenStateFull> {
  @override
  Widget build(BuildContext context) {
    return _loginScreenState();
  }

  final _formKey = GlobalKey<FormState>();

  Widget _loginScreenState() {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Center(
                  child: SizedBox(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Image.asset('images/ic_launcher.png')),
                  ),
                ),
              ),
              Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com',
                  ),
                  validator: (value) {
                    _validateEmail(value);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password',
                  ),
                  validator: (value) {
                    _validatePassword(value);
                  },
                ),
              ),
              MaterialButton(
                onPressed: () {
                  //TODO FORGOT PASSWORD SCREEN GOES HERE
                  if (kDebugMode) {
                    print("FORGOT PASSWORD SCREEN");
                  }
                  ScaffoldMessenger.of(context)
                      .showSnackBar(_snackBar(text: "FORGOT PASSWORD SCREEN"));
                },
                child: const Text(
                  'Forgot Password',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: MaterialButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    // _snackBar(
                    //     text:
                    //         "email:${emailController.text}\n password: ${passwordController.text}");
                    // Future.delayed(const Duration(milliseconds: 1000), () {
                    //   Navigator.push(context,
                    //       MaterialPageRoute(builder: (_) => const HomePage()));
                    // });
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              const SizedBox(
                height: 130,
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      _snackBar(text: "New User? Create Account"));
                },
                child: const Text(
                  'New User? Create Account',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Enter password";
    } else {
      return null;
    }
  }

  String? _validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return "Enter email";
    } else {
      return null;
    }
  }
}
