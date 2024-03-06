import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

<<<<<<< HEAD
class LoginProvider extends ChangeNotifier {
  Future<void> signIn(
      String username, String password, BuildContext context) async {
=======
class AuthProvider extends ChangeNotifier {
  Future<void> signIn(String username, String password,
      BuildContext context) async {
>>>>>>> 0bbf3211661c97c8b616918f5124ea6f61273ce9
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
<<<<<<< HEAD
        Navigator.pushReplacementNamed(context, '/ranking');
=======
        Navigator.pushReplacementNamed(context, '/dashboard');
>>>>>>> 0bbf3211661c97c8b616918f5124ea6f61273ce9
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

<<<<<<< HEAD
=======

>>>>>>> 0bbf3211661c97c8b616918f5124ea6f61273ce9
class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
=======
      appBar: AppBar(
        title: Text('NERD BOARD - Login'),
      ),
>>>>>>> 0bbf3211661c97c8b616918f5124ea6f61273ce9
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final authProvider =
<<<<<<< HEAD
                        Provider.of<LoginProvider>(context, listen: false);
=======
                    Provider.of<AuthProvider>(context, listen: false);
>>>>>>> 0bbf3211661c97c8b616918f5124ea6f61273ce9
                    await authProvider.signIn(
                      _usernameController.text.trim(),
                      _passwordController.text.trim(),
                      context,
                    );
                  },
                  child: Text('Entrar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: Text('Cadastro'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 0bbf3211661c97c8b616918f5124ea6f61273ce9
