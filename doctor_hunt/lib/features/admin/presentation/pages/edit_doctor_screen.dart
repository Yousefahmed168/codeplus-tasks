import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/services/admin_service.dart';
import '../../../../core/services/cloudinary_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/widgets/custom_back_button.dart';
import '../../../../core/models/doctor.dart';
import '../../../../i18n/strings.g.dart';
import '../widgets/doctor_form_widget.dart';
import '../../../../core/utils/snack_bar_helper.dart';

class EditDoctorScreen extends StatefulWidget {
  final Doctor doctor;

  const EditDoctorScreen({super.key, required this.doctor});

  @override
  State<EditDoctorScreen> createState() => _EditDoctorScreenState();
}

class _EditDoctorScreenState extends State<EditDoctorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _feeCtrl;
  String? _selectedSpecialty;
  String? _imagePath;
  String? _uploadedImageUrl;
  bool _isSubmitting = false;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.doctor.name ?? '');
    _feeCtrl = TextEditingController(text: widget.doctor.consultationFee.toStringAsFixed(2));
    _selectedSpecialty = widget.doctor.specialization;
    _isActive = widget.doctor.isActive;
  }

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
        setState(() => _imagePath = pickedFile.path);
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, '${t.admin.editDoctor.failed}: $e');
      }
    }
  }

  Future<void> _deleteDoctor() async {
    if (widget.doctor.uid == null) return;
    try {
      await sl<AdminService>().deleteDoctor(widget.doctor.uid!);
      if (mounted) {
        SnackBarHelper.showError(context, t.admin.editDoctor.deletedSuccess);
        // Pop back to list
        context.pop();
        context.pop(); 
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, '${t.admin.editDoctor.failed}: $e');
      }
    }
  }

  void _showDeleteConfirm() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text(t.admin.doctors.deleteTitle),
        content: Text(
          t.admin.doctors.deleteConfirm.replaceAll('@name', widget.doctor.name ?? ''),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t.common.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteDoctor();
            },
            child: Text(
              t.common.delete,
              style: context.semiBold14.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);
    try {
      if (_imagePath != null) {
        _uploadedImageUrl = await sl<CloudinaryService>().uploadImage(
          filePath: _imagePath!,
          folder: 'doctors',
        );
      }

      final data = <String, dynamic>{
        'name': _nameCtrl.text.trim(),
        'specialization': _selectedSpecialty,
        'consultationFee': double.tryParse(_feeCtrl.text.trim()) ?? 0.0,
        'isActive': _isActive,
      };

      if (_uploadedImageUrl != null) data['image'] = _uploadedImageUrl;
      data.removeWhere((_, value) => value == null);

      if (widget.doctor.uid != null) {
        await sl<AdminService>().updateDoctor(widget.doctor.uid!, data);
      }

      if (mounted) {
        SnackBarHelper.showSuccess(context, t.admin.editDoctor.success);
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, '${t.admin.editDoctor.failed}: $e');
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
        leadingWidth: 70.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: const CustomBackButton(),
        ),
        title: Text(
          t.admin.editDoctor.title,
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
          imagePath: _imagePath,
          existingImageUrl: widget.doctor.imageUrl,
          onPickImage: _pickImage,
          isActive: _isActive,
          onStatusChanged: (v) => setState(() => _isActive = v),
          isSubmitting: _isSubmitting,
          submitLabel: t.admin.editDoctor.updateBtn,
          submittingLabel: t.admin.editDoctor.updatingBtn,
          onSubmit: _submit,
          onDelete: _showDeleteConfirm,
        ),
      ),
    );
  }
}
