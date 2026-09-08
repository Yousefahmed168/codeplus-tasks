import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/admin_service.dart';
import '../../../../core/services/cloudinary_service.dart';
import '../../../../features/auth/data/models/specializations.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../features/doctors/models/doctor_model.dart';

class EditDoctorScreen extends StatefulWidget {
  final DoctorModel doctor;

  const EditDoctorScreen({super.key, required this.doctor});

  @override
  State<EditDoctorScreen> createState() => _EditDoctorScreenState();
}

class _EditDoctorScreenState extends State<EditDoctorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phone1Ctrl;
  late final TextEditingController _phone2Ctrl;
  late final TextEditingController _bioCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _openHourCtrl;
  late final TextEditingController _closeHourCtrl;
  String? _selectedSpecialty;
  String? _imagePath;
  String? _uploadedImageUrl;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final d = widget.doctor;
    _nameCtrl = TextEditingController(text: d.name ?? '');
    _emailCtrl = TextEditingController(text: d.email ?? '');
    _phone1Ctrl = TextEditingController(text: d.phone1 ?? '');
    _phone2Ctrl = TextEditingController(text: d.phone2 ?? '');
    _bioCtrl = TextEditingController(text: d.bio ?? '');
    _addressCtrl = TextEditingController(text: d.address ?? '');
    _openHourCtrl = TextEditingController(text: d.openHour ?? '');
    _closeHourCtrl = TextEditingController(text: d.closeHour ?? '');
    _selectedSpecialty = d.specialization;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phone1Ctrl.dispose();
    _phone2Ctrl.dispose();
    _bioCtrl.dispose();
    _addressCtrl.dispose();
    _openHourCtrl.dispose();
    _closeHourCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() => _imagePath = pickedFile.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e'), backgroundColor: AppColors.error),
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

      final data = <String, dynamic>{
        'name': _nameCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'phone1': _phone1Ctrl.text.trim(),
        'phone2': _phone2Ctrl.text.trim(),
        'specialization': _selectedSpecialty,
        'bio': _bioCtrl.text.trim(),
        'address': _addressCtrl.text.trim(),
        'openHour': _openHourCtrl.text.trim(),
        'closeHour': _closeHourCtrl.text.trim(),
      };

      if (_uploadedImageUrl != null) {
        data['image'] = _uploadedImageUrl;
      }

      // Remove null values
      data.removeWhere((key, value) => value == null);

      if (widget.doctor.uid != null) {
        await AdminService.instance.updateDoctor(widget.doctor.uid!, data);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Doctor updated successfully'), backgroundColor: AppColors.success),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update doctor: $e'), backgroundColor: AppColors.error),
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
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Edit Doctor', style: context.bold18.textPrimary),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      Container(
                        width: 100, height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withValues(alpha: 0.1),
                          image: _imagePath != null
                              ? DecorationImage(image: FileImage(File(_imagePath!)), fit: BoxFit.cover)
                              : (widget.doctor.imageUrl != null && widget.doctor.imageUrl!.isNotEmpty
                                  ? DecorationImage(image: CachedNetworkImageProvider(widget.doctor.imageUrl!), fit: BoxFit.cover)
                                  : null),
                        ),
                        child: _imagePath == null && (widget.doctor.imageUrl == null || widget.doctor.imageUrl!.isEmpty)
                            ? Icon(Icons.person, color: AppColors.primary, size: 40)
                            : null,
                      ),
                      Positioned(
                        bottom: 0, right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(24),
              Text('Doctor Name', style: context.semiBold14.textPrimary), const Gap(8),
              CustomTextFormField(controller: _nameCtrl, hintText: 'Enter doctor name',
                prefixIcon: const Icon(Icons.person_outline, color: AppColors.textHint, size: 20),
                validator: (v) { if (v == null || v.isEmpty) return 'Please enter doctor name'; return null; }),
              const Gap(16),
              Text('Email', style: context.semiBold14.textPrimary), const Gap(8),
              CustomTextFormField(controller: _emailCtrl, hintText: 'doctor@email.com',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textHint, size: 20)),
              const Gap(16),
              Text('Phone 1', style: context.semiBold14.textPrimary), const Gap(8),
              CustomTextFormField(controller: _phone1Ctrl, hintText: '+20xxxxxxxxxx',
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.textHint, size: 20)),
              const Gap(16),
              Text('Phone 2 (Optional)', style: context.semiBold14.textPrimary), const Gap(8),
              CustomTextFormField(controller: _phone2Ctrl, hintText: '+20xxxxxxxxxx',
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.textHint, size: 20)),
              const Gap(16),
              Text('Specialty', style: context.semiBold14.textPrimary), const Gap(8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(20)),
                child: DropdownButton<String>(
                  isExpanded: true, underline: const SizedBox(),
                  iconEnabledColor: AppColors.primary,
                  hint: Text('Select specialty', style: context.regular14.textSecondary),
                  icon: const Icon(Icons.expand_circle_down_outlined),
                  value: _selectedSpecialty,
                  onChanged: (v) => setState(() => _selectedSpecialty = v),
                  items: specializations.map((String spec) => DropdownMenuItem(value: spec, child: Text(spec))).toList(),
                ),
              ),
              const Gap(16),
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Open Hour', style: context.semiBold14.textPrimary),
                  const Gap(8),
                  CustomTextFormField(controller: _openHourCtrl, hintText: '09:00'),
                ])),
                const Gap(16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Close Hour', style: context.semiBold14.textPrimary),
                  const Gap(8),
                  CustomTextFormField(controller: _closeHourCtrl, hintText: '17:00'),
                ])),
              ]),
              const Gap(16),
              Text('Bio', style: context.semiBold14.textPrimary), const Gap(8),
              CustomTextFormField(controller: _bioCtrl, hintText: 'Brief description about the doctor...', maxLines: 3),
              const Gap(16),
              Text('Clinic Address', style: context.semiBold14.textPrimary), const Gap(8),
              CustomTextFormField(controller: _addressCtrl, hintText: '123 Main St, Downtown, City'),
              const Gap(24),
              MainButton(
                text: _isSubmitting ? 'Updating...' : 'Update Doctor',
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