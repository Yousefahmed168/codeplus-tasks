import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/admin_service.dart';
import '../../../../core/services/cloudinary_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../features/auth/data/models/specializations.dart';
import '../../../../features/doctors/models/doctor_model.dart';

class CreateDoctorScreen extends StatefulWidget {
  const CreateDoctorScreen({super.key});

  @override
  State<CreateDoctorScreen> createState() => _CreateDoctorScreenState();
}

class _CreateDoctorScreenState extends State<CreateDoctorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  String? _selectedSpecialty;
  String? _imagePath;
  String? _uploadedImageUrl;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _bioCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() => _imagePath = pickedFile.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    try {
      // Upload image if selected
      if (_imagePath != null) {
        _uploadedImageUrl = await CloudinaryService.instance.uploadImage(
          filePath: _imagePath!,
          folder: 'doctors',
        );
      }

      final doctor = DoctorModel(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        phone1: _phoneCtrl.text.trim(),
        specialization: _selectedSpecialty,
        bio: _bioCtrl.text.trim(),
        address: _addressCtrl.text.trim(),
        imageUrl: _uploadedImageUrl,
      );

      await AdminService.instance.createDoctor(doctor);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Doctor created successfully'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create doctor: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text('Create Doctor', style: context.bold18.textPrimary),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Name
              Text('Doctor Name', style: context.semiBold14.textPrimary),
              const Gap(8),
              CustomTextFormField(
                controller: _nameCtrl,
                hintText: 'Enter doctor name',
                prefixIcon: const Icon(
                  Icons.person_outline,
                  color: AppColors.textHint,
                  size: 20,
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please enter doctor name';
                  return null;
                },
              ),
              const Gap(20),

              // Email
              Text('Email', style: context.semiBold14.textPrimary),
              const Gap(8),
              CustomTextFormField(
                controller: _emailCtrl,
                hintText: 'doctor@email.com',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: AppColors.textHint,
                  size: 20,
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please enter email';
                  if (!v.contains('@')) return 'Please enter valid email';
                  return null;
                },
              ),
              const Gap(20),

              // Phone
              Text('Phone', style: context.semiBold14.textPrimary),
              const Gap(8),
              CustomTextFormField(
                controller: _phoneCtrl,
                hintText: '+20xxxxxxxxxx',
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(
                  Icons.phone_outlined,
                  color: AppColors.textHint,
                  size: 20,
                ),
              ),
              const Gap(20),

              // Specialty
              Text('Specialty', style: context.semiBold14.textPrimary),
              const Gap(8),
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
                  underline: const SizedBox(),
                  iconEnabledColor: AppColors.primary,
                  hint: Text(
                    'Select specialty',
                    style: context.regular14.textSecondary,
                  ),
                  icon: const Icon(Icons.expand_circle_down_outlined),
                  value: _selectedSpecialty,
                  onChanged: (v) => setState(() => _selectedSpecialty = v),
                  items: specializations.map((String spec) {
                    return DropdownMenuItem(value: spec, child: Text(spec));
                  }).toList(),
                ),
              ),
              const Gap(20),

              // Bio
              Text('Bio', style: context.semiBold14.textPrimary),
              const Gap(8),
              CustomTextFormField(
                controller: _bioCtrl,
                hintText: 'Brief description about the doctor...',
                maxLines: 3,
              ),
              const Gap(20),

              // Address
              Text('Clinic Address', style: context.semiBold14.textPrimary),
              const Gap(8),
              CustomTextFormField(
                controller: _addressCtrl,
                hintText: '123 Main St, Downtown, City',
              ),
              const Gap(20),

              // Doctor Image
              Text('Doctor Image', style: context.semiBold14.textPrimary),
              const Gap(8),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border, width: 2),
                    image: _imagePath != null
                        ? DecorationImage(
                            image: FileImage(File(_imagePath!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _imagePath == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.image_outlined,
                              size: 48,
                              color: AppColors.textHint,
                            ),
                            const Gap(8),
                            Text(
                              'Upload doctor image',
                              style: context.semiBold14.textSecondary,
                            ),
                            const Gap(4),
                            Text(
                              'Tap to pick an image',
                              style: context.regular12.textHint,
                            ),
                          ],
                        )
                      : null,
                ),
              ),
              const Gap(32),
              MainButton(
                text: _isSubmitting ? 'Creating...' : 'Create Doctor',
                onPressed: _isSubmitting ? null : _submit,
              ),
              const Gap(32),
            ],
          ),
        ),
      ),
    );
  }
}
