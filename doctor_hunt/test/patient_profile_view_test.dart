import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doctor_hunt/features/patient_profile/presentation/pages/patient_profile_view.dart';

void main() {
  Widget wrap(Widget child) => ScreenUtilInit(
    designSize: const Size(375, 812),
    builder: (_, _) => MaterialApp(home: Scaffold(body: child)),
  );

  Widget view({
    required TextEditingController nameCtrl,
    required TextEditingController phoneCtrl,
    ProfileField editingField = ProfileField.none,
    ValueChanged<ProfileField>? onEditField,
    String email = '',
    String? dob,
    int? gender,
  }) {
    return PatientProfileView(
      nameCtrl: nameCtrl,
      phoneCtrl: phoneCtrl,
      nameFocus: FocusNode(),
      phoneFocus: FocusNode(),
      editingField: editingField,
      onEditField: onEditField ?? (_) {},
      onStopEditing: () {},
      email: email,
      dob: dob,
      gender: gender,
      onPickDob: () {},
      onPickGender: () {},
    );
  }

  testWidgets('renders the personal information rows with a pencil action', (
    tester,
  ) async {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    addTearDown(nameCtrl.dispose);
    addTearDown(phoneCtrl.dispose);

    await tester.pumpWidget(
      wrap(view(nameCtrl: nameCtrl, phoneCtrl: phoneCtrl)),
    );

    expect(find.text('Personal information'), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Contact Number'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Date of Birth'), findsOneWidget);
    expect(find.text('Gender'), findsOneWidget);
    // Name, phone, email, date of birth and gender are all empty.
    expect(find.text('Not provided'), findsNWidgets(5));
    // Email is read-only, so only four rows expose the pencil action.
    expect(find.byIcon(Icons.edit_outlined), findsNWidgets(4));
  });

  testWidgets('shows the stored values once they are populated', (
    tester,
  ) async {
    final nameCtrl = TextEditingController(text: 'Abdullah Mamun');
    final phoneCtrl = TextEditingController(text: '+8801800000000');
    addTearDown(nameCtrl.dispose);
    addTearDown(phoneCtrl.dispose);

    await tester.pumpWidget(
      wrap(
        view(
          nameCtrl: nameCtrl,
          phoneCtrl: phoneCtrl,
          email: 'abdullah@mail.com',
          dob: '1995-04-12',
          gender: 0,
        ),
      ),
    );

    expect(find.text('Abdullah Mamun'), findsOneWidget);
    expect(find.text('+8801800000000'), findsOneWidget);
    expect(find.text('abdullah@mail.com'), findsOneWidget);
    expect(find.text('1995-04-12'), findsOneWidget);
    expect(find.text('Male'), findsOneWidget);
    expect(find.text('Not provided'), findsNothing);
  });

  testWidgets('tapping a row asks to edit that field', (tester) async {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    addTearDown(nameCtrl.dispose);
    addTearDown(phoneCtrl.dispose);

    final requested = <ProfileField>[];
    await tester.pumpWidget(
      wrap(
        view(
          nameCtrl: nameCtrl,
          phoneCtrl: phoneCtrl,
          onEditField: requested.add,
        ),
      ),
    );

    await tester.tap(find.text('Name'));
    await tester.pump();
    await tester.tap(find.text('Contact Number'));
    await tester.pump();

    expect(requested, [ProfileField.name, ProfileField.phone]);
  });

  testWidgets('the edited row swaps to an inline text field', (tester) async {
    final nameCtrl = TextEditingController(text: 'Abdullah Mamun');
    final phoneCtrl = TextEditingController();
    addTearDown(nameCtrl.dispose);
    addTearDown(phoneCtrl.dispose);

    await tester.pumpWidget(
      wrap(
        view(
          nameCtrl: nameCtrl,
          phoneCtrl: phoneCtrl,
          editingField: ProfileField.name,
        ),
      ),
    );

    // Phone, date of birth and gender keep their pencil while name is editable.
    expect(find.byIcon(Icons.edit_outlined), findsNWidgets(3));
    expect(find.byType(TextFormField), findsOneWidget);
    expect(
      tester.widget<TextFormField>(find.byType(TextFormField)).controller,
      nameCtrl,
    );
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
  });
}
