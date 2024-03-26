import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:phone/models/users.dart';
import '../services/database_helper.dart';
import '../../models/sensor_data_model.dart';
import '../components/email_field.dart';
import '../components/password_field.dart';
import '../components/register_button.dart';
import '../components/name_field.dart';
import '../components/phone_field.dart';
import 'InitialPage.dart';
import 'Login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();

}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController nameController;
  late TextEditingController phoneController;
  double _elementsOpacity = 1;
  bool loadingBallAppear = false;
  double loadingBallSize = 1;
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
    phoneController = TextEditingController();

    super.initState();
  }

_performRegistration() async {
  // Verifique se os campos estão preenchidos corretamente
  if (nameController.text.isEmpty ||
      emailController.text.isEmpty ||
      phoneController.text.isEmpty ||
      passwordController.text.isEmpty) {
    // Se algum campo estiver vazio, exiba uma mensagem ou tome outra ação necessária
    // Por exemplo, exibindo um SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Por favor, preencha todos os campos'),
      ),
    );
    return;
  }

  final userData = UserData(
    name: nameController.text,
    email: emailController.text,
    phone: phoneController.text,
    password: passwordController.text,
  );

  // Realize o registro do usuário chamando a função de inserção de dados na base de dados
  try {
    final result = await DatabaseHelper.instance.insertUserData(
      userData
    );


    if (result != null) {
      // Se o registro for bem-sucedido, exiba uma mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Usuário registrado com sucesso'),
          backgroundColor: Colors.teal,
      behavior: SnackBarBehavior.floating,
      width: 300,
        
        ),
      );

      // Salve o token de autenticação no armazenamento seguro
      await storage.write(key: 'token', value: result['token']);
      await storage.write(key: 'id', value: result['id'].toString());
      await storage.write(key: 'name', value: result['name']);


      // Aguarde 1 segundo para que o usuário possa ver a mensagem de sucesso
      await Future.delayed(Duration(seconds: 1));
      // Navegue para a página de dados do sensor

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InitialPage()),
      );
    } else {
      // Caso contrário, exiba uma mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ocorreu um erro durante o registro do usuário'),
          backgroundColor: Colors.teal,
      behavior: SnackBarBehavior.floating,
      width: 300,
        
        ),
       
      );
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterPage()),
      );
    }
  } catch (e) {
    // Se ocorrer uma exceção durante o registro, exiba uma mensagem de erro
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
        MaterialPageRoute(builder: (context) => RegisterPage()),
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
            ? Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30.0),
                              child: CircularProgressIndicator(),
                            ),
                          )            : Padding(
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
                                "Sign up to continue",
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
                            NameField(
                                fadeName: _elementsOpacity == 0,
                                nameController: nameController),
                            SizedBox(height: 40),
                            PhoneField(
                                fadePhone: _elementsOpacity == 0,
                                phoneController: phoneController),
                            SizedBox(height: 40),
                            PasswordField(
                                fadePassword: _elementsOpacity == 0,
                                passwordController: passwordController),
                            SizedBox(height: 60),
                            register_button(
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
                                  "Already have an account? ",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.7)),
                                ),
                                GestureDetector(
                              onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => LoginPage()),
                                        );
                                      },
                                  child: Text(
                                    "Login",
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


