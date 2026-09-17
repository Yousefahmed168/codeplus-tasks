import 'dart:io';

import '../../../../core/routes/app_routes.dart';
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
import '../cubit/auth_state.dart';

class UpdateDoctorProfileScreen extends StatefulWidget {
  const UpdateDoctorProfileScreen({super.key});

  @override
  State<UpdateDoctorProfileScreen> createState() =>
      _UpdateDoctorProfileScreenState();
}

class _UpdateDoctorProfileScreenState extends State<UpdateDoctorProfileScreen> {
  String? _imagePath;
  String? _specialization;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _openHourController = TextEditingController();
  final TextEditingController _closeHourController = TextEditingController();
  final TextEditingController _phone1Controller = TextEditingController();
  final TextEditingController _phone2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthCubit>().loadCurrentProfile();
    });
  }

  @override
  void dispose() {
    _bioController.dispose();
    _addressController.dispose();
    _openHourController.dispose();
    _closeHourController.dispose();
    _phone1Controller.dispose();
    _phone2Controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        if (!mounted) return;
        setState(() {
          _imagePath = pickedFile.path;
          context.read<AuthCubit>().setImage(File(pickedFile.path));
        });
      }
    } catch (e) {
      if (!mounted) return;
      showMyDialog(
        context,
        'Failed to pick image. Please try again.\nError: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(t.updateProfile.title, style: context.bold20.textPrimary),
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
        ),
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthProfileLoadedState) {
              final user = state.doctorData;
              _bioController.text = user.bio ?? '';
              _addressController.text = user.address ?? '';
              _openHourController.text = user.openHour ?? '';
              _closeHourController.text = user.closeHour ?? '';
              _phone1Controller.text = user.phone1 ?? '';
              _phone2Controller.text = user.phone2 ?? '';
              setState(() {
                _specialization = user.specialization;
              });
            } else if (state is AuthErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: AppColors.error,
                ),
              );
            } else if (state is AuthSuccessState) {
              context.go(AppRoutes.doctorDashboard);
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoadingState;

            if (isLoading && _bioController.text.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          //   Profile Image
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
                                      : const AssetImage(
                                              'assets/images/doctor.png',
                                            )
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

                          //  Specialization Label
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

                          //  Specialization Dropdown
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
                              icon: const Icon(
                                Icons.expand_circle_down_outlined,
                              ),
                              value: specializations.contains(_specialization)
                                  ? _specialization
                                  : null,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _specialization = newValue;
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

                          //  Bio Label
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  t.updateProfile.bioLabel,
                                  style: context.regular14.textPrimary,
                                ),
                              ],
                            ),
                          ),

                          //  Bio Field
                          CustomTextFormField(
                            controller: _bioController,
                            maxLines: 4,
                            hintText: t.updateProfile.bioHint,
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

                          //  Clinic Address Label
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

                          //  Clinic Address Field
                          CustomTextFormField(
                            controller: _addressController,
                            hintText: t.updateProfile.clinicAddressHint,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return t.updateProfile.clinicAddressHint;
                              }
                              return null;
                            },
                          ),

                          //  Work Hours
                          _workHours(context),

                          //  Phone Numbers
                          _phoneNumbers(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        //  Submit Button
        bottomNavigationBar: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoadingState;
            return Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
              child: MainButton(
                text: isLoading
                    ? t.common.loading
                    : t.updateProfile.completeRegistration,
                onPressed: isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          await context.read<AuthCubit>().updateDoctor(
                            bio: _bioController.text,
                            address: _addressController.text,
                            openHour: _openHourController.text,
                            closeHour: _closeHourController.text,
                            phone1: _phone1Controller.text,
                            phone2: _phone2Controller.text,
                            specialization: _specialization,
                          );
                        }
                      },
              ),
            );
          },
        ),
      ),
    );
  }

  Column _workHours(BuildContext context) {
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
                child: Text(
                  t.updateProfile.to,
                  style: context.regular14.textPrimary,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            //  Start Time
            Expanded(
              child: CustomTextFormField(
                readOnly: true,
                controller: _openHourController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return t.updateProfile.required;
                  }
                  return null;
                },
                suffixIcon: IconButton(
                  onPressed: () async {
                    await _showStartTimePicker();
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

            //  End Time
            Expanded(
              child: CustomTextFormField(
                readOnly: true,
                controller: _closeHourController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return t.updateProfile.required;
                  }
                  return null;
                },
                suffixIcon: IconButton(
                  onPressed: () async {
                    await _showEndTimePicker();
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

  Column _phoneNumbers(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            t.updateProfile.phone1Label,
            style: context.regular14.textPrimary,
          ),
        ),
        CustomTextFormField(
          controller: _phone1Controller,
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
          controller: _phone2Controller,
          keyboardType: TextInputType.phone,
          hintText: '+20xxxxxxxxxx',
        ),
      ],
    );
  }

  Future<void> _showStartTimePicker() async {
    final startTimePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (startTimePicked != null) {
      if (!mounted) return;
      _openHourController.text = startTimePicked.format(context);
    }
  }

  Future<void> _showEndTimePicker() async {
    final endTimePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        DateTime.now().add(const Duration(minutes: 15)),
      ),
    );

    if (endTimePicked != null) {
      if (!mounted) return;
      _closeHourController.text = endTimePicked.format(context);
    }
  }
}
