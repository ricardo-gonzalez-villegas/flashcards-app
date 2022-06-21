import 'package:flutter/material.dart';

TextField reusableTextField(String text, IconData icon, bool isPassword,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPassword,
    enableSuggestions: !isPassword,
    autocorrect: !isPassword,
    decoration: InputDecoration(
      prefixIcon: Icon(icon),
      labelText: text,
      filled: true,
    ),
    keyboardType:
        isPassword ? TextInputType.visiblePassword : TextInputType.emailAddress,
  );
}

Container signInSignUpButton(
    BuildContext context, bool isSignIn, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Text(isSignIn ? 'Sign In' : 'Sign Up'),
    ),
  );
}
