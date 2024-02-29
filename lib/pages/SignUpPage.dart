import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class SignUpProvider extends ChangeNotifier {
  Future<void> signUp(
      String username, String emailAddress, String password, String confirmPassword, BuildContext context) async {
    try {
      if (username.isEmpty || emailAddress.isEmpty || password.isEmpty) {
        _showSnackBar(context, 'Preencha todos os campos');
        return;
      }

      if (password != confirmPassword) {
        _showSnackBar(context, 'As senhas não coincidem');
        return;
      }

      final ParseUser user = ParseUser(username, password, emailAddress);

      user.set<String>('username', username);
      user.set<String>('email', emailAddress);
      user.set<String>('password', password);

      final response = await user.signUp();

      if (response.success) {
        // Cadastro bem-sucedido
        print('Cadastro bem-sucedido: ${user.objectId}');
        Navigator.pushReplacementNamed(context, '/ranking');
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
  final TextEditingController _emailAddressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

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
              controller: _emailAddressController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirmar Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final authProvider =
                    Provider.of<SignUpProvider>(context, listen: false);
                await authProvider.signUp(
                  _usernameController.text.trim(),
                  _emailAddressController.text.trim(),
                  _passwordController.text.trim(),
                  _confirmPasswordController.text.trim(),
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
