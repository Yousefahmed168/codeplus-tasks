import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/custom_back_button.dart';
import '../../../../core/widgets/main_button.dart';
import '../../../../i18n/strings.g.dart';
import '../../../auth/data/models/patient_model.dart';
import '../../../auth/presentation/cubit/patient_profile_cubit.dart';
import '../../../auth/presentation/cubit/patient_profile_state.dart';
import '../widgets/patient_profile_shimmer.dart';
import 'patient_profile_view.dart';

/// Patient profile screen, opened from the drawer, the home header avatar or
/// the settings quick information card.
class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();

  ProfileField _editingField = ProfileField.none;
  String? _localImagePath;
  bool _isPopulated = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  void _populate(PatientModel patient) {
    _nameCtrl.text = patient.name ?? '';
    _phoneCtrl.text = patient.phone ?? '';
  }

  void _startEditing(ProfileField field) {
    setState(() => _editingField = field);
    // The focus node is only attached once the inline field is mounted.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final focusNode = field == ProfileField.name ? _nameFocus : _phoneFocus;
      focusNode.requestFocus();
    });
  }

  void _stopEditing() {
    FocusScope.of(context).unfocus();
    setState(() => _editingField = ProfileField.none);
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (picked == null || !mounted) return;
    setState(() => _localImagePath = picked.path);
  }

  /// Saves the edited profile.
  ///
  /// [cubit] is passed in rather than resolved here: the state's own context
  /// sits *above* the [BlocProvider] created in [build], so it cannot look the
  /// cubit up. The caller reads it from the builder context instead.
  Future<void> _save(PatientProfileCubit cubit, PatientModel patient) async {
    FocusScope.of(context).unfocus();

    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      _showMessage(t.common.validation.enterName, isError: true);
      return;
    }

    final phone = _phoneCtrl.text.trim();
    if (phone.isNotEmpty && !AppConstants.phoneRegex.hasMatch(phone)) {
      _showMessage(t.common.validation.validPhone, isError: true);
      return;
    }

    final succeeded = await cubit.updateProfile(
      currentPatient: patient,
      name: name,
      phone: phone,
      localImagePath: _localImagePath,
    );
    if (!mounted) return;

    setState(() {
      _localImagePath = null;
      _editingField = ProfileField.none;
    });

    // Failures are surfaced by the cubit through the screen's listener.
    if (!succeeded) return;

    _showMessage(t.patientProfile.profileUpdated);
    context.pop();
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PatientProfileCubit()..loadProfile(),
      child: BlocConsumer<PatientProfileCubit, PatientProfileState>(
        listener: (context, state) {
          if (state is PatientProfileError) {
            _showMessage(state.message, isError: true);
          }
        },
        builder: (context, state) {
          final isLoading =
              state is PatientProfileInitial || state is PatientProfileLoading;
          final isSaving = state is PatientProfileSaving;

          PatientModel? patient;
          if (state is PatientProfileLoaded) {
            patient = state.patient;
          } else if (state is PatientProfileSaving) {
            patient = state.patient;
          }

          if (patient != null && !_isPopulated) {
            _populate(patient);
            _isPopulated = true;
          }

          return Scaffold(
            backgroundColor: AppColors.background,
            body: isLoading
                ? const PatientProfileShimmer()
                : Column(
                    children: [
                      _ProfileHeader(
                        patient: patient,
                        localImagePath: _localImagePath,
                        onAvatarTap: _pickImage,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          child: patient == null
                              ? Padding(
                                  padding: EdgeInsets.all(32.r),
                                  child: Text(
                                    t.patientProfile.noProfileData,
                                    style: context.regular14.textSecondary,
                                  ),
                                )
                              : PatientProfileView(
                                  nameCtrl: _nameCtrl,
                                  phoneCtrl: _phoneCtrl,
                                  nameFocus: _nameFocus,
                                  phoneFocus: _phoneFocus,
                                  editingField: _editingField,
                                  onEditField: _startEditing,
                                  onStopEditing: _stopEditing,
                                ),
                        ),
                      ),
                      if (patient != null)
                        _ProfileBottomBar(
                          isSaving: isSaving,
                          onSave: isSaving
                              ? null
                              : () => _save(
                                  context.read<PatientProfileCubit>(),
                                  patient!,
                                ),
                        ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.patient,
    required this.localImagePath,
    required this.onAvatarTap,
  });

  final PatientModel? patient;
  final String? localImagePath;
  final VoidCallback onAvatarTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 52.h,
        left: 20.w,
        right: 20.w,
        bottom: 26.h,
      ),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: const CustomBackButton(),
              ),
              Text(
                t.patientProfile.title,
                style: context.bold18.copyWith(color: AppColors.textOnPrimary),
              ),
            ],
          ),
          22.verticalSpace,
          _ProfileAvatar(
            imageUrl: patient?.image ?? '',
            localImagePath: localImagePath,
            onTap: onAvatarTap,
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({
    required this.imageUrl,
    required this.localImagePath,
    required this.onTap,
  });

  final String imageUrl;
  final String? localImagePath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 104.r,
            height: 104.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
              border: Border.all(color: AppColors.surface, width: 3.w),
              boxShadow: [
                BoxShadow(
                  color: AppColors.textPrimary.withValues(alpha: 0.12),
                  blurRadius: 10.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: ClipOval(child: _buildImage()),
          ),
          Positioned(
            bottom: 2.r,
            right: 2.r,
            child: Container(
              padding: EdgeInsets.all(6.r),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.camera_alt_rounded,
                size: 16.r,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (localImagePath != null) {
      return Image.file(File(localImagePath!), fit: BoxFit.cover);
    }
    if (imageUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (_, _) => _fallbackIcon(),
        errorWidget: (_, _, _) => _fallbackIcon(),
      );
    }
    return _fallbackIcon();
  }

  Widget _fallbackIcon() =>
      Icon(Icons.person_rounded, size: 50.r, color: AppColors.primary);
}

/// Full width action pinned below the scrollable form.
class _ProfileBottomBar extends StatelessWidget {
  const _ProfileBottomBar({required this.isSaving, required this.onSave});

  final bool isSaving;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            AppColors.primary.withValues(alpha: 0.14),
            AppColors.surface,
          ],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
              child: MainButton(
                text: isSaving ? t.common.loading : t.common.continueBtn,
                onPressed: onSave,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
