/// -------------------------
///  """ TASK 1 """
/// ------------------------------------------------

void main() {
  // ── Constant values
  const String schoolName = 'CodePlus Academy';
  const int currentYear = 2026;

  // ── Final variables
  final String studentName = 'Yousef Ahmed Abdelrahim';
  final int studentId = 111;
  final String major = 'Computer Science';
  final int enrollmentYear = 2023;

  // ── Regular variables
  double gpa = 3.85;
  int creditsCompleted = 90;

  // ── Nullable variables
  String? email;
  String? advisor;
  double? scholarship;

  // ── Null-aware operators
  // ?? – default value if null
  String displayEmail = email ?? 'No email on file';
  String displayAdvisor = advisor ?? 'Not assigned yet';
  double displayScholarship = scholarship ?? 0.0;

  // ??= – assign only if currently null
  email ??= 'tourkyousef@gmail.com';

  // ── Calculate years in school
  final int yearsInSchool = currentYear - enrollmentYear;

  // ── Print meaningful output
  print('═══════════════════════════════════════════════');
  print('         STUDENT INFORMATION REPORT            ');
  print('            $schoolName                        ');
  print('═══════════════════════════════════════════════');
  print('Name           : $studentName');
  print('Student ID     : $studentId');
  print('Major          : $major');
  print('Enrollment Year: $enrollmentYear  (${yearsInSchool} year(s) ago)');
  print('GPA            : $gpa');
  print('Credits Done   : $creditsCompleted');
  print('───────────────────────────────────────────────');
  print('Email          : $email');
  print('Advisor        : $displayAdvisor');
  print('Scholarship    : \$${displayScholarship.toStringAsFixed(2)}');
  print('───────────────────────────────────────────────');
  print('Before ??=  email was  : $displayEmail');
  print('═══════════════════════════════════════════════');
}
