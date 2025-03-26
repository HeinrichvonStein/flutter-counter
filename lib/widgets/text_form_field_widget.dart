import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  /// The label text shown inside the input field.
  final String labelText;

  /// The keyboard type to use for the input.
  final TextInputType keyboardType;

  /// Whether the input should obscure the text (useful for passwords).
  final bool obscureText;

  /// Callback that receives the saved value when the form is submitted.
  final void Function(String) onSaved;

  /// A custom `TextFormField` widget that displays a text form field
  /// with built-in validation logic and consistent styling.
  ///
  /// This widget includes validation for common input types like
  /// email, username, and password, based on the provided [labelText].
  ///
  /// The [onSaved] callback is triggered only if the value is non-null.
  ///
  ///
  /// All parameters are required and must not be null.
  const TextFormFieldWidget({
    super.key,
    required this.labelText,
    required this.keyboardType,
    required this.obscureText,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
      keyboardType: keyboardType,
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
      decoration: InputDecoration(labelText: labelText),
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$labelText cannot be empty.';
        }

        final lowerLabel = labelText.toLowerCase();

        if (lowerLabel.contains('email') && !value.contains('@') || value.trim().length < 3) {
          return 'Please enter a valid email address.';
        }

        if (lowerLabel.contains('username') && value.trim().length < 3) {
          return 'Username must be at least 3 characters long.';
        }

        if (lowerLabel.contains('password') && value.trim().length < 6) {
          return 'Password must be at least 6 characters long.';
        }
        return null;
      },
      onSaved: (value) {
        if (value != null) {
          onSaved(value);
        }
      },
    );
  }
}
