import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../data/models/patient_model.dart';
import '../cubit/patient_profile_cubit.dart';
import '../cubit/patient_profile_state.dart';
import '../widgets/patient_profile_edit_form.dart';
import '../widgets/patient_profile_view.dart';
import '../../../../i18n/strings.g.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  bool _editing = false;

  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _ageCtrl;
  late TextEditingController _cityCtrl;
  late TextEditingController _bioCtrl;
  int? _selectedGender;
  String? _localImagePath;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    _ageCtrl = TextEditingController();
    _cityCtrl = TextEditingController();
    _bioCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _ageCtrl.dispose();
    _cityCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  void _populateControllers(PatientModel p) {
    _nameCtrl.text = p.name ?? '';
    _phoneCtrl.text = p.phone ?? '';
    _ageCtrl.text = p.age ?? '';
    _cityCtrl.text = p.city ?? '';
    _bioCtrl.text = p.bio ?? '';
    _selectedGender = p.gender;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (picked != null) setState(() => _localImagePath = picked.path);
  }

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.common.logout),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              t.common.logout,
              style: context.regular14.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      if (!context.mounted) return;
      await context.read<PatientProfileCubit>().logout();
      if (context.mounted) context.go(AppRoutes.role);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PatientProfileCubit()..loadProfile(),
      child: BlocConsumer<PatientProfileCubit, PatientProfileState>(
        listener: (context, state) {
          if (state is PatientProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          PatientModel? patient;
          final isLoading =
              state is PatientProfileLoading || state is PatientProfileInitial;
          final isSaving = state is PatientProfileSaving;

          if (state is PatientProfileLoaded) {
            patient = state.patient;
          } else if (state is PatientProfileSaving) {
            patient = state.patient;
          }

          return Scaffold(
            backgroundColor: AppColors.background,
            body: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : CustomScrollView(
                    slivers: [
                      _buildSliverAppBar(context, patient, isSaving),
                      SliverToBoxAdapter(
                        child: _editing
                            ? PatientProfileEditForm(
                                patient: patient,
                                isSaving: isSaving,
                                nameCtrl: _nameCtrl,
                                phoneCtrl: _phoneCtrl,
                                ageCtrl: _ageCtrl,
                                cityCtrl: _cityCtrl,
                                bioCtrl: _bioCtrl,
                                selectedGender: _selectedGender,
                                localImagePath: _localImagePath,
                                onGenderChanged: (v) =>
                                    setState(() => _selectedGender = v),
                                onSaved: () => setState(() {
                                  _editing = false;
                                  _localImagePath = null;
                                }),
                              )
                            : patient != null
                            ? PatientProfileView(patient: patient)
                            : const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(32),
                                  child: Text('No profile data found'),
                                ),
                              ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(
    BuildContext context,
    PatientModel? patient,
    bool isSaving,
  ) {
    final imageUrl = patient?.image;
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;

    return SliverAppBar(
      expandedHeight: 260,
      pinned: true,
      backgroundColor: AppColors.primary,
      automaticallyImplyLeading: false,
      actions: [
        if (!_editing)
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: AppColors.background),
            onPressed: () {
              setState(() => _editing = true);
              if (patient != null) _populateControllers(patient);
            },
          ),
        if (_editing)
          IconButton(
            icon: const Icon(Icons.close_rounded, color: AppColors.background),
            onPressed: () => setState(() {
              _editing = false;
              _localImagePath = null;
            }),
          ),
        IconButton(
          icon: const Icon(Icons.logout_rounded, color: AppColors.background),
          onPressed: () => _logout(context),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Gap(48),
              GestureDetector(
                onTap: _editing ? _pickImage : null,
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      child: ClipOval(
                        child: _localImagePath != null
                            ? Image.file(File(_localImagePath!), fit: BoxFit.cover)
                            : hasImage
                            ? CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (_, _) => const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                                errorWidget: (_, _, _) => const Icon(
                                  Icons.person_rounded,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.person_rounded,
                                size: 50,
                                color: Colors.white,
                              ),
                      ),
                    ),
                    if (_editing)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const Gap(12),
              Text(
                patient?.name ?? 'Patient',
                style: context.bold18.copyWith(color: AppColors.background),
              ),
              const Gap(4),
              Text(
                patient?.email ?? '',
                style: context.regular12.copyWith(
                  color: AppColors.background.withValues(alpha: 0.7),
                ),
              ),
              const Gap(16),
            ],
          ),
        ),
      ),
    );
  }
}
