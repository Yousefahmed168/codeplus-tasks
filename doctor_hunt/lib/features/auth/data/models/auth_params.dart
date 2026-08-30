/// Parameters passed to login and registration methods in [AuthRepo].
class AuthParams {
  final String name;
  final String email;
  final String password;
  final String phone;

  const AuthParams({
    this.name = '',
    required this.email,
    required this.password,
    this.phone = '',
  });
}