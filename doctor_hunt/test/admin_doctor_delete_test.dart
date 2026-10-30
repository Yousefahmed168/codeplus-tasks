import 'package:doctor_hunt/core/di/service_locator.dart';
import 'package:doctor_hunt/core/models/doctor.dart';
import 'package:doctor_hunt/core/services/admin_service.dart';
import 'package:doctor_hunt/features/admin/presentation/pages/admin_doctor_details_screen.dart';
import 'package:doctor_hunt/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'fakes/fake_services.dart';

void main() {
  setUpAll(() => LocaleSettings.setLocaleSync(AppLocale.en));

  late FakeAdminService admin;

  setUp(() async {
    await sl.reset();
    admin = FakeAdminService();
    sl.registerSingleton<AdminService>(admin);
  });

  tearDown(() => sl.reset());

  testWidgets('deleting a doctor confirms first, then removes the profile', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const Scaffold(body: Text('doctor list')),
        ),
        GoRoute(
          path: '/doctor',
          builder: (_, _) => AdminDoctorDetailsScreen(
            doctor: Doctor(uid: 'doc-1', name: 'Ahmed Ali'),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, _) => MaterialApp.router(routerConfig: router),
      ),
    );

    router.push('/doctor');
    await tester.pumpAndSettle();

    final deleteButton = find.text(t.admin.doctors.delete);
    await tester.ensureVisible(deleteButton);
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();

    expect(
      find.text(t.admin.doctors.deleteConfirm.replaceAll('@name', 'Ahmed Ali')),
      findsOneWidget,
    );
    expect(admin.deletedUids, isEmpty);

    final confirmButton = find.widgetWithText(TextButton, t.common.delete);
    expect(confirmButton, findsOneWidget);
    await tester.tap(confirmButton);
    await tester.pumpAndSettle();

    expect(admin.deletedUids, ['doc-1']);
    expect(find.text('doctor list'), findsOneWidget);
  });
}
