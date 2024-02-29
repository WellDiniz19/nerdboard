import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class AuthProvider extends ChangeNotifier {
  Future<void> signUp(
      String username, String password, BuildContext context) async {
    try {
      if (username.isEmpty || password.isEmpty) {
        _showSnackBar(context, 'Preencha todos os campos');
        return;
      }

      final ParseUser user = ParseUser(username, password, null);

      // Substitua os seguintes campos com os campos reais da sua classe no Back4App
      user.set<String>('customUsernameField', username);
      user.set<String>('customPasswordField', password);

      final response = await user.signUp();

      if (response.success) {
        // Cadastro bem-sucedido
        print('Cadastro bem-sucedido: ${user.objectId}');
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        // Tratar erro de cadastro
        _showSnackBar(
            context, 'Erro ao cadastrar usuário: ${response.error!.message}');
      }
      notifyListeners();
    } catch (e) {
      print('Erro ao cadastrar usuário: $e');
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

class SignUpPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NERD BOARD - Cadastro'),
      ),
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
            ElevatedButton(
              onPressed: () async {
                final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);
                await authProvider.signUp(
                  _usernameController.text.trim(),
                  _passwordController.text.trim(),
                  context,
                );
              },
              child: Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
