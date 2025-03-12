class AppException implements Exception {
  final String message;
  AppException(this.message);

  @override
  String toString() {
    return '$runtimeType: $message';
  }
}

class WeakPasswordException extends AppException {
  WeakPasswordException() : super('Your password is too weak.');
}

class PasswordMismatchException extends AppException {
  PasswordMismatchException() : super('Password don\'t match.');
}

class BadEmailFormatException extends AppException {
  BadEmailFormatException() : super('Incorrect email format.');
}

class EmailAlreadyInUseException extends AppException {
  EmailAlreadyInUseException() : super('The account already exists for that email.');
}

class InvalidCredentialsException extends AppException {
  InvalidCredentialsException() : super('Invalid credentials.');
}

class UserDoesNotExistException extends AppException {
  final String id;
  UserDoesNotExistException(this.id) : super('User with id=$id does not exist.');
}

class UserNotLoggedInException extends AppException {
  UserNotLoggedInException() : super('Action is not permitted because you are not logged in.');
}

class CategoryDoesNotExistException extends AppException {
  final String cid;
  CategoryDoesNotExistException(this.cid) : super('Category with id={${cid}} does not exist.');
}
