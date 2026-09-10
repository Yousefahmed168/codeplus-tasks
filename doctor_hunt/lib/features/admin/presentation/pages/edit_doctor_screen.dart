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

class EditDoctorScreen extends StatefulWidget {
  final Doctor doctor;

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
            content: Text('${t.admin.editDoctor.failed}: $e'),
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

      if (_uploadedImageUrl != null) data['image'] = _uploadedImageUrl;
      data.removeWhere((_, value) => value == null);

      if (widget.doctor.uid != null) {
        await AdminService.instance.updateDoctor(widget.doctor.uid!, data);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.admin.editDoctor.success),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${t.admin.editDoctor.failed}: $e'),
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
          t.admin.editDoctor.title,
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
          existingImageUrl: widget.doctor.imageUrl,
          onPickImage: _pickImage,
          isSubmitting: _isSubmitting,
          submitLabel: t.admin.editDoctor.updateBtn,
          submittingLabel: t.admin.editDoctor.updatingBtn,
          onSubmit: _submit,
          openHourCtrl: _openHourCtrl,
          closeHourCtrl: _closeHourCtrl,
        ),
      ),
    );
  }
}
