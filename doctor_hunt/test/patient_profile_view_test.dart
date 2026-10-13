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
  }) {
    return PatientProfileView(
      nameCtrl: nameCtrl,
      phoneCtrl: phoneCtrl,
      nameFocus: FocusNode(),
      phoneFocus: FocusNode(),
      editingField: editingField,
      onEditField: onEditField ?? (_) {},
      onStopEditing: () {},
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
    expect(find.text('Not provided'), findsNWidgets(2));
    expect(find.byIcon(Icons.edit_outlined), findsNWidgets(2));
  });

  testWidgets('shows the stored values once they are populated', (
    tester,
  ) async {
    final nameCtrl = TextEditingController(text: 'Abdullah Mamun');
    final phoneCtrl = TextEditingController(text: '+8801800000000');
    addTearDown(nameCtrl.dispose);
    addTearDown(phoneCtrl.dispose);

    await tester.pumpWidget(
      wrap(view(nameCtrl: nameCtrl, phoneCtrl: phoneCtrl)),
    );

    expect(find.text('Abdullah Mamun'), findsOneWidget);
    expect(find.text('+8801800000000'), findsOneWidget);
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

    // Only the phone row keeps its pencil while the name row is editable.
    expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
    expect(
      tester.widget<TextFormField>(find.byType(TextFormField)).controller,
      nameCtrl,
    );
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
  });
}
