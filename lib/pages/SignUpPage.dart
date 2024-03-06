import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

<<<<<<< HEAD
class SignUpProvider extends ChangeNotifier {
  Future<void> signUp(
      String username, String emailAddress, String password, String confirmPassword, BuildContext context) async {
    try {
      if (username.isEmpty || emailAddress.isEmpty || password.isEmpty) {
=======
class AuthProvider extends ChangeNotifier {
  Future<void> signUp(
      String username, String password, BuildContext context) async {
    try {
      if (username.isEmpty || password.isEmpty) {
>>>>>>> 0bbf3211661c97c8b616918f5124ea6f61273ce9
        _showSnackBar(context, 'Preencha todos os campos');
        return;
      }

<<<<<<< HEAD
      if (password != confirmPassword) {
        _showSnackBar(context, 'As senhas não coincidem');
        return;
      }

      final ParseUser user = ParseUser(username, password, emailAddress);

      user.set<String>('username', username);
      user.set<String>('email', emailAddress);
      user.set<String>('password', password);
=======
      final ParseUser user = ParseUser(username, password, null);

      // Substitua os seguintes campos com os campos reais da sua classe no Back4App
      user.set<String>('customUsernameField', username);
      user.set<String>('customPasswordField', password);
>>>>>>> 0bbf3211661c97c8b616918f5124ea6f61273ce9

      final response = await user.signUp();

      if (response.success) {
        // Cadastro bem-sucedido
        print('Cadastro bem-sucedido: ${user.objectId}');
<<<<<<< HEAD
        Navigator.pushReplacementNamed(context, '/ranking');
=======
        Navigator.pushReplacementNamed(context, '/dashboard');
>>>>>>> 0bbf3211661c97c8b616918f5124ea6f61273ce9
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
<<<<<<< HEAD
  final TextEditingController _emailAddressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
=======
  final TextEditingController _passwordController = TextEditingController();
>>>>>>> 0bbf3211661c97c8b616918f5124ea6f61273ce9

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
<<<<<<< HEAD
              controller: _emailAddressController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10),
            TextField(
=======
>>>>>>> 0bbf3211661c97c8b616918f5124ea6f61273ce9
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
<<<<<<< HEAD
            SizedBox(height: 10),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirmar Password'),
              obscureText: true,
            ),
=======
>>>>>>> 0bbf3211661c97c8b616918f5124ea6f61273ce9
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final authProvider =
<<<<<<< HEAD
                    Provider.of<SignUpProvider>(context, listen: false);
                await authProvider.signUp(
                  _usernameController.text.trim(),
                  _emailAddressController.text.trim(),
                  _passwordController.text.trim(),
                  _confirmPasswordController.text.trim(),
=======
                    Provider.of<AuthProvider>(context, listen: false);
                await authProvider.signUp(
                  _usernameController.text.trim(),
                  _passwordController.text.trim(),
>>>>>>> 0bbf3211661c97c8b616918f5124ea6f61273ce9
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
