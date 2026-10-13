import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/services/admin_service.dart';
import '../../../../core/services/cloudinary_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../features/doctors/models/doctor.dart';
import '../../../../i18n/strings.g.dart';
import '../widgets/doctor_form_widget.dart';

class CreateDoctorScreen extends StatefulWidget {
  const CreateDoctorScreen({super.key});

  @override
  State<CreateDoctorScreen> createState() => _CreateDoctorScreenState();
}

class _CreateDoctorScreenState extends State<CreateDoctorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _feeCtrl = TextEditingController();
  String? _selectedSpecialty;
  XFile? _imageFile;
  String? _uploadedImageUrl;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _feeCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() => _imageFile = pickedFile);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${t.admin.createDoctor.failed}: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        );
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    try {
      if (_imageFile != null) {
        final bytes = await _imageFile!.readAsBytes();
        _uploadedImageUrl = await sl<CloudinaryService>().uploadImageBytes(
          bytes: bytes,
          fileName: _imageFile!.name,
          folder: 'doctors',
        );
      }

      final doctor = Doctor(
        name: _nameCtrl.text.trim(),
        imageUrl: _uploadedImageUrl,
        specialization: _selectedSpecialty,
        consultationFee: double.tryParse(_feeCtrl.text.trim()) ?? 0.0,
      );

      await sl<AdminService>().createDoctor(doctor);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.admin.createDoctor.success),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${t.admin.createDoctor.failed}: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
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
        backgroundColor: AppColors.primaryLight,
        elevation: 0,
        leadingWidth: 70.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: const CustomBackButton(),
        ),
        title: Text(
          t.admin.createDoctor.title,
          style: context.bold18.textPrimary,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: DoctorFormWidget(
          formKey: _formKey,
          nameCtrl: _nameCtrl,
          feeCtrl: _feeCtrl,
          selectedSpecialty: _selectedSpecialty,
          onSpecialtyChanged: (v) => setState(() => _selectedSpecialty = v),
          imagePath: _imageFile?.path,
          onPickImage: _pickImage,
          isSubmitting: _isSubmitting,
          submitLabel: t.admin.createDoctor.createBtn,
          submittingLabel: t.admin.createDoctor.creatingBtn,
          onSubmit: _submit,
        ),
      ),
    );
  }
}
