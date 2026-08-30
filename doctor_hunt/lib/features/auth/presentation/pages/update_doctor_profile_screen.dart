import 'dart:io';

import 'package:doctor_hunt/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../../../core/widgets/dialogs.dart';
import '../../../../core/widgets/main_button.dart';
import '../../../../i18n/strings.g.dart';
import '../../data/models/specializations.dart';
import '../cubit/auth_cubit.dart';

class UpdateDoctorProfileScreen extends StatefulWidget {
  const UpdateDoctorProfileScreen({super.key});

  @override
  State<UpdateDoctorProfileScreen> createState() =>
      _UpdateDoctorProfileScreenState();
}

class _UpdateDoctorProfileScreenState extends State<UpdateDoctorProfileScreen> {
  String? _imagePath;

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        setState(() {
          _imagePath = pickedFile.path;
          context.read<AuthCubit>().setImage(File(pickedFile.path));
        });
      }
    } catch (e) {
      if (mounted) {
        showMyDialog(
          context,
          'Failed to pick image. Please try again.\nError: $e',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<AuthCubit>();
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            t.updateProfile.title,
            style: context.bold20.textPrimary,
          ),
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Form(
                  key: cubit.formKey,
                  child: Column(
                    children: [
                      // ── Profile Image ────────────────────────────────
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.surfaceVariant,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: AppColors.surface,
                              backgroundImage: (_imagePath != null)
                                  ? FileImage(File(_imagePath!))
                                  : const AssetImage('assets/images/doctor.png')
                                        as ImageProvider,
                            ),
                          ),
                          GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: AppColors.surface,
                              child: Icon(
                                Icons.camera_alt_rounded,
                                size: 20,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // ── Specialization Label ──────────────────────────
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                        child: Row(
                          children: [
                            Text(
                              t.updateProfile.specialization,
                              style: context.regular14.textPrimary,
                            ),
                          ],
                        ),
                      ),

                      // ── Specialization Dropdown ───────────────────────
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          iconEnabledColor: AppColors.primary,
                          dropdownColor: AppColors.surface,
                          hint: Text(
                            t.updateProfile.chooseSpecialization,
                            style: context.regular14.textSecondary,
                          ),
                          icon: const Icon(Icons.expand_circle_down_outlined),
                          value: specializations.contains(cubit.specialization)
                              ? cubit.specialization
                              : null,
                          onChanged: (String? newValue) {
                            setState(() {
                              cubit.specialization = newValue;
                            });
                          },
                          items: specializations.map((String spec) {
                            return DropdownMenuItem(
                              value: spec,
                              child: Text(
                                spec,
                                style: context.regular14.textPrimary,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const Gap(10),

                      // ── Bio Label ────────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(t.updateProfile.bioLabel, style: context.regular14.textPrimary),
                          ],
                        ),
                      ),

                      // ── Bio Field ─────────────────────────────────────
                      CustomTextFormField(
                        controller: cubit.bioController,
                        maxLines: 4,
                        hintText:
                            t.updateProfile.bioHint,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return t.common.validation.enterName;
                          }
                          return null;
                        },
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: const Divider(color: AppColors.divider),
                      ),

                      // ── Clinic Address Label ─────────────────────────
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              t.updateProfile.clinicAddressLabel,
                              style: context.regular14.textPrimary,
                            ),
                          ],
                        ),
                      ),

                      // ── Clinic Address Field ─────────────────────────
                      CustomTextFormField(
                        controller: cubit.addressController,
                        hintText: t.updateProfile.clinicAddressHint,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return t.updateProfile.clinicAddressHint;
                          }
                          return null;
                        },
                      ),

                      // ── Work Hours ────────────────────────────────────
                      _workHours(cubit, context),

                      // ── Phone Numbers ─────────────────────────────────
                      _phoneNumbers(cubit, context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Submit Button ──────────────────────────────────────────────
        bottomNavigationBar: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: MainButton(
            onPressed: () async {
              if (cubit.formKey.currentState!.validate()) {
                if (cubit.imageFile != null || _imagePath != null) {
                  await cubit.updateDoctor();
                  if (context.mounted) {
                    context.go(AppRoutes.doctorDashboard);
                  }
                } else {
                  showMyDialog(context, t.updateProfile.selectImageError);
                }
              }
            },
            text: t.updateProfile.completeRegistration,
          ),
        ),
      ),
    );
  }

  Column _workHours(AuthCubit bloc, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  t.updateProfile.workHoursFrom,
                  style: context.regular14.textPrimary,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(t.updateProfile.to, style: context.regular14.textPrimary),
              ),
            ),
          ],
        ),
        Row(
          children: [
            // ── Start Time ──────────────────────────────────────────
            Expanded(
              child: CustomTextFormField(
                readOnly: true,
                controller: bloc.openHourController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return t.updateProfile.required;
                  }
                  return null;
                },
                suffixIcon: IconButton(
                  onPressed: () async {
                    await _showStartTimePicker(bloc);
                  },
                  icon: const Icon(
                    Icons.watch_later_outlined,
                    color: AppColors.primary,
                  ),
                ),
                hintText: '00:00',
              ),
            ),
            const SizedBox(width: 10),

            // ── End Time ────────────────────────────────────────────
            Expanded(
              child: CustomTextFormField(
                readOnly: true,
                controller: bloc.closeHourController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return t.updateProfile.required;
                  }
                  return null;
                },
                suffixIcon: IconButton(
                  onPressed: () async {
                    await _showEndTimePicker(bloc);
                  },
                  icon: const Icon(
                    Icons.watch_later_outlined,
                    color: AppColors.primary,
                  ),
                ),
                hintText: '00:00',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column _phoneNumbers(AuthCubit bloc, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(t.updateProfile.phone1Label, style: context.regular14.textPrimary),
        ),
        CustomTextFormField(
          controller: bloc.phone1Controller,
          keyboardType: TextInputType.phone,
          hintText: '+20xxxxxxxxxx',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return t.common.validation.enterPhone;
            }
            return null;
          },
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            t.updateProfile.phone2Label,
            style: context.regular14.textPrimary,
          ),
        ),
        CustomTextFormField(
          controller: bloc.phone2Controller,
          keyboardType: TextInputType.phone,
          hintText: '+20xxxxxxxxxx',
        ),
      ],
    );
  }

  Future<void> _showStartTimePicker(AuthCubit cubit) async {
    final startTimePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (startTimePicked != null) {
      cubit.openHourController.text = startTimePicked.format(context);
    }
  }

  Future<void> _showEndTimePicker(AuthCubit cubit) async {
    final endTimePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        DateTime.now().add(const Duration(minutes: 15)),
      ),
    );

    if (endTimePicked != null) {
      cubit.closeHourController.text = endTimePicked.format(context);
    }
  }
}
