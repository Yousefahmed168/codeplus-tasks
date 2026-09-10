import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
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
  final _emailCtrl = TextEditingController();
  String? _imagePath;
  String? _uploadedImageUrl;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
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
            content: Text('${t.admin.createDoctor.failed}: $e'),
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
      if (_imagePath != null) {
        _uploadedImageUrl = await CloudinaryService.instance.uploadImage(
          filePath: _imagePath!,
          folder: 'doctors',
        );
      }

      final doctor = Doctor(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        imageUrl: _uploadedImageUrl,
      );

      await AdminService.instance.createDoctor(doctor);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.admin.createDoctor.success),
            backgroundColor: AppColors.success,
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
        title: Text(
          t.admin.createDoctor.title,
          style: context.bold18.textPrimary,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: DoctorFormWidget(
          formKey: _formKey,
          nameCtrl: _nameCtrl,
          emailCtrl: _emailCtrl,
          imagePath: _imagePath,
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
