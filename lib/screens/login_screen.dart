import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../widgets/text_form_field_widget.dart';

class LoginScreen extends StatefulWidget {
  /// A screen that allows users to log in or create an account.
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

/// State class for [LoginScreen], managing form input and submission logic.
class _LoginScreenState extends State<LoginScreen> {
  /// Key used to identify the form and perform validation.
  final _form = GlobalKey<FormState>();

  /// Stores the entered email address.
  var _enteredEmail = '';

  /// Stores the entered password.
  var _enteredPassword = '';

  /// Stores the entered username.
  var _enteredUsername = '';

  /// Toggles between login and sign-up modes.
  var _isLogin = true;

  var _isAuthenticating = false;

  /// Inserts the user into Supabase
  void _insertUser() async {
    final response = await Supabase.instance.client.from('counter').insert([
      {'username': _enteredUsername, 'user_id': Supabase.instance.client.auth.currentUser!.id},
    ]);
    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.error!.message)));
    }
  }

  /// Validates the form and attempts to log in or create an account.
  void _onSubmit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();
    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        await Supabase.instance.client.auth.signInWithPassword(
          email: _enteredEmail,
          password: _enteredPassword,
          phone: '',
        );
      } else {
        await Supabase.instance.client.auth.signUp(
          email: _enteredEmail,
          password: _enteredPassword,
          data: {
            'displayName': _enteredUsername, // this gets stored in `user_metadata`
          },
        );
        _insertUser();
      }
    } on AuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message)));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
    }
    setState(() {
      _isAuthenticating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30, bottom: 20, left: 20, right: 20),
                  width: 200,
                  child: SvgPicture.asset('assets/images/powersync-logo-dark.svg', width: 200),
                ),
                Card(
                  child: SingleChildScrollView(
                    child: Padding(padding: EdgeInsets.all(16), child: buildForm(context)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the login/sign-up form UI.
  Form buildForm(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormFieldWidget(
            labelText: 'Email',
            obscureText: false,
            keyboardType: TextInputType.emailAddress,
            onSaved: (value) => _enteredEmail = value,
          ),
          TextFormFieldWidget(
            labelText: 'Username',
            obscureText: false,
            keyboardType: TextInputType.name,
            onSaved: (value) => _enteredUsername = value,
          ),
          TextFormFieldWidget(
            labelText: 'Password',
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            onSaved: (value) => _enteredPassword = value,
          ),
          const SizedBox(height: 12),
          if (_isAuthenticating) CircularProgressIndicator(),
          if (!_isAuthenticating)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: Text(_isLogin ? 'Create Account' : 'Already have an account?'),
                ),
                ElevatedButton(onPressed: _onSubmit, child: Text(_isLogin ? 'Login' : 'Sign Up')),
              ],
            ),
        ],
      ),
    );
  }
}
