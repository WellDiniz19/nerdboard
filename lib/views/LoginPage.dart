import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class AuthProvider extends ChangeNotifier {
  Future<void> signIn(
      String username, String password, BuildContext context) async {
    try {
      if (username.isEmpty || password.isEmpty) {
        _showSnackBar(context, 'Preencha todos os campos');
        return;
      }

      final ParseUser user = ParseUser(username, password, null);
      final response = await user.login();

      if (response.success) {
        // Login bem-sucedido
        print('Login bem-sucedido: ${user.objectId}');
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        // Tratar erro de login
        _showSnackBar(
            context, 'Erro ao fazer login: ${response.error!.message}');
      }
      notifyListeners();
    } catch (e) {
      print('Erro ao fazer login: $e');
      rethrow;
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
    ));
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          top: 60,
          left: 40,
          right: 40,
        ),
        color: Colors.black87,
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: 250,
              height: 250,
              child: Image.asset("assets/login.png"),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              //usuário
              keyboardType: TextInputType.emailAddress,
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                labelStyle: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              //senha
              keyboardType: TextInputType.text,
              obscureText: true,
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
            Container(
              //recuperar senha
              height: 40,
              alignment: Alignment.centerRight,
              child: TextButton(
                child: Text(
                  "SIGN UP",
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              height: 60,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  )),
              child: SizedBox.expand(
                child: TextButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "LOG IN",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  onPressed: () async {
                    final authProvider =
                        Provider.of<AuthProvider>(context, listen: false);
                    await authProvider.signIn(
                      _usernameController.text.trim(),
                      _passwordController.text.trim(),
                      context,
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 60,
              alignment: Alignment.centerLeft,
              color: Colors.black,
              child: SizedBox.expand(
                child: TextButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "SIGN UP",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                ),
              ),
            ),
          ],
          // mainAxisAlignment: MainAxisAlignment.center,
          // children: [
          //   TextField(
          //     controller: _usernameController,
          //     decoration: InputDecoration(labelText: 'Username'),
          //   ),
          //   SizedBox(height: 10),
          //   TextField(
          //     controller: _passwordController,
          //     decoration: InputDecoration(labelText: 'Password'),
          //     obscureText: true,
          //   ),
          //   SizedBox(height: 20),
          //   Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          // ElevatedButton(
          //   onPressed: () async {
          //     final authProvider =
          //         Provider.of<AuthProvider>(context, listen: false);
          //     await authProvider.signIn(
          //       _usernameController.text.trim(),
          //       _passwordController.text.trim(),
          //       context,
          //     );
          //   },
          //   child: Text('Entrar'),
          // ),
          //       ElevatedButton(
          //         onPressed: () {
          //           Navigator.pushNamed(context, '/signup');
          //         },
          //         child: Text('Cadastro'),
          //       ),
          //     ],
          //   ),
          // ],
        ),
      ),
    );
  }
}
