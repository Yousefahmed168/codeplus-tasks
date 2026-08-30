/// Legacy user-type enum used by [AuthRepo].
/// New code should use [UserRole] from `features/auth/models/user_model.dart`.
enum UserTypeEnum {
  doctor('doctor'),
  patient('patient');

  const UserTypeEnum(this.value);
  final String value;

  static UserTypeEnum fromString(String value) {
    return UserTypeEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => UserTypeEnum.patient,
    );
  }
}