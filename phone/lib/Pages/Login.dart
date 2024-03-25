import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:phone/models/users.dart';
import '../services/database_helper.dart';
import '../../models/sensor_data_model.dart';
import '../components/email_field.dart';
import '../components/password_field.dart';
import '../components/get_started_button.dart';
import 'Register.dart';
import 'sensor_data_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  double _elementsOpacity = 1;
  bool loadingBallAppear = false;
  double loadingBallSize = 1;
    final storage = FlutterSecureStorage();

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();

    super.initState();
  }

  _performRegistration() async {
  if (
      emailController.text.isEmpty ||
      passwordController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Por favor, preencha todos os campos'),
      ),
    );
    return;
  }


  try {
    final result = await DatabaseHelper.instance.loginUser(
      emailController.text, passwordController.text,
    );

    print(result);
    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login realizado com sucesso'),
          backgroundColor: Colors.teal,
      behavior: SnackBarBehavior.floating,
      width: 300,
        
        ),
      );
      await storage.write(key: 'token', value: result['token']);
      await storage.write(key: 'id', value: result['id'].toString());
      await storage.write(key: 'name', value: result['name']);

      await Future.delayed(Duration(seconds: 1));

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SensorDataPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ocorreu um erro durante o lugin do user'),
          backgroundColor: Colors.teal,
      behavior: SnackBarBehavior.floating,
      width: 300,
        
        ),
       
      );
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Erro: $e'),
        backgroundColor: Colors.teal,
      behavior: SnackBarBehavior.floating,
      width: 300,
      
      ),
    );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: loadingBallAppear
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30.0),
                                child:  SensorDataPage(),

                )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 70),
                      TweenAnimationBuilder<double>(
                        duration: Duration(milliseconds: 300),
                        tween: Tween(begin: 1, end: _elementsOpacity),
                        builder: (_, value, __) => Opacity(
                          opacity: value,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.flutter_dash,
                                  size: 60, color: Color(0xff21579C)),
                              SizedBox(height: 25),
                              Text(
                                "Welcome,",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 35),
                              ),
                              Text(
                                "Sign in to continue",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                    fontSize: 35),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            EmailField(
                                fadeEmail: _elementsOpacity == 0,
                                emailController: emailController),
                            SizedBox(height: 40),
                            PasswordField(
                                fadePassword: _elementsOpacity == 0,
                                passwordController: passwordController),
                            SizedBox(height: 60),
                            GetStartedButton(
                              elementsOpacity: _elementsOpacity,
                              onTap: () {
                                setState(() {
                                  _elementsOpacity = 0;
                                });
                              },
                              onAnimatinoEnd: () async {
                                _performRegistration();
                                await Future.delayed(
                                  
                                    Duration(milliseconds: 500));
                                setState(() {
                                  loadingBallAppear = true;
                                });
                              },
                            ),                                            // Dont have an account register
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account? ",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.7)),
                                ),
                                GestureDetector(
                              onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => RegisterPage()),
                                        );
                                      },
                                  child: Text(
                                    "Register",
                                    style: TextStyle(
                                        color: Color(0xff21579C),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ],
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


