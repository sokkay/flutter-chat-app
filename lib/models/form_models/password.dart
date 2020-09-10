import 'package:formz/formz.dart';

enum PasswordInputError { invalid }

class Password extends FormzInput<String, PasswordInputError> {
  const Password.pure() : super.pure('');
  const Password.dirty([String value = '']) : super.dirty(value);

  static final _passwordRegExp =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
      
  @override
  PasswordInputError validator(String value) {
    return value.length >= 6 ? null : PasswordInputError.invalid;
  }
}
