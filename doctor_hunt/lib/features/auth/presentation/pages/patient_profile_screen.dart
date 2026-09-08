import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/cloudinary_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../data/models/patient_model.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  PatientModel? _patient;
  bool _loading = true;
  bool _editing = false;
  bool _saving = false;

  // Edit controllers
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
    _loadProfile();
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

  Future<void> _loadProfile() async {
    final uid = AuthService.instance.currentUser?.uid;
    if (uid == null) return;
    try {
      final doc = await FirebaseFirestore.instance
          .collection('patients')
          .doc(uid)
          .get();
      if (doc.exists && mounted) {
        final patient = PatientModel.fromJson(doc.data()!);
        setState(() {
          _patient = patient;
          _loading = false;
          _populateControllers(patient);
        });
      } else {
        setState(() => _loading = false);
      }
    } catch (e) {
      setState(() => _loading = false);
    }
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
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 75);
    if (picked != null) setState(() => _localImagePath = picked.path);
  }

  Future<void> _save() async {
    final uid = AuthService.instance.currentUser?.uid;
    if (uid == null) return;
    setState(() => _saving = true);
    try {
      String? imageUrl = _patient?.image;

      // Upload new image to Cloudinary if the user picked one
      if (_localImagePath != null) {
        imageUrl = await CloudinaryService.instance.uploadImage(
          filePath: _localImagePath!,
          folder: 'patients',
        );
      }

      final updated = PatientModel(
        uid: uid,
        name: _nameCtrl.text.trim().isEmpty ? null : _nameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
        age: _ageCtrl.text.trim().isEmpty ? null : _ageCtrl.text.trim(),
        city: _cityCtrl.text.trim().isEmpty ? null : _cityCtrl.text.trim(),
        bio: _bioCtrl.text.trim().isEmpty ? null : _bioCtrl.text.trim(),
        gender: _selectedGender,
        image: imageUrl,
        email: _patient?.email,
      );

      await FirebaseFirestore.instance
          .collection('patients')
          .doc(uid)
          .update(updated.toUpdateData());

      if (mounted) {
        setState(() {
          _patient = updated;
          _editing = false;
          _saving = false;
          _localImagePath = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Log Out', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await AuthService.instance.logout();
      if (mounted) context.go(AppRoutes.role);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : CustomScrollView(
              slivers: [
                _buildSliverAppBar(),
                SliverToBoxAdapter(
                  child: _editing ? _buildEditForm() : _buildViewProfile(),
                ),
              ],
            ),
    );
  }

  Widget _buildSliverAppBar() {
    final imageUrl = _patient?.image;
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;

    return SliverAppBar(
      expandedHeight: 260,
      pinned: true,
      backgroundColor: AppColors.primary,
      automaticallyImplyLeading: false,
      actions: [
        if (!_editing)
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: Colors.white),
            onPressed: () => setState(() => _editing = true),
          ),
        if (_editing)
          IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.white),
            onPressed: () {
              setState(() {
                _editing = false;
                _localImagePath = null;
                if (_patient != null) _populateControllers(_patient!);
              });
            },
          ),
        IconButton(
          icon: const Icon(Icons.logout_rounded, color: Colors.white),
          onPressed: _logout,
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
                _patient?.name ?? 'Patient',
                style: context.bold18.copyWith(color: Colors.white),
              ),
              const Gap(4),
              Text(
                _patient?.email ?? '',
                style: context.regular12.copyWith(color: Colors.white70),
              ),
              const Gap(16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViewProfile() {
    final p = _patient;
    if (p == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('No profile data found'),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(8),
          _sectionTitle('Personal Information'),
          const Gap(12),
          _infoCard([
            _infoRow(Icons.phone_rounded, 'Phone', p.phone),
            _divider,
            _infoRow(Icons.cake_rounded, 'Age', p.age != null ? '${p.age} years' : null),
            _divider,
            _infoRow(
              Icons.person_outline_rounded,
              'Gender',
              p.gender == 0 ? 'Male' : p.gender == 1 ? 'Female' : null,
            ),
            _divider,
            _infoRow(Icons.location_city_rounded, 'City', p.city),
          ]),
          const Gap(20),
          if (p.bio != null && p.bio!.isNotEmpty) ...[
            _sectionTitle('About'),
            const Gap(12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(p.bio!, style: context.regular14.textBody),
            ),
            const Gap(20),
          ],
          _sectionTitle('Account'),
          const Gap(12),
          _infoCard([
            _infoRow(Icons.email_rounded, 'Email', p.email),
          ]),
          const Gap(32),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(8),
          _sectionTitle('Edit Profile'),
          const Gap(16),
          _field('Full Name', _nameCtrl, Icons.person_rounded),
          const Gap(12),
          _field('Phone', _phoneCtrl, Icons.phone_rounded, keyboardType: TextInputType.phone),
          const Gap(12),
          _field('Age', _ageCtrl, Icons.cake_rounded, keyboardType: TextInputType.number),
          const Gap(12),
          _field('City', _cityCtrl, Icons.location_city_rounded),
          const Gap(12),
          _field('Bio', _bioCtrl, Icons.info_outline_rounded, maxLines: 3),
          const Gap(16),
          // Gender selector
          Text('Gender', style: context.semiBold14.textSecondary),
          const Gap(8),
          Row(
            children: [
              _genderChip(0, 'Male', Icons.male_rounded),
              const Gap(12),
              _genderChip(1, 'Female', Icons.female_rounded),
            ],
          ),
          const Gap(24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _saving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text('Save Changes', style: context.semiBold16.copyWith(color: Colors.white)),
            ),
          ),
          const Gap(32),
        ],
      ),
    );
  }

  Widget _genderChip(int value, String label, IconData icon) {
    final selected = _selectedGender == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedGender = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: selected ? Colors.white : AppColors.textSecondary, size: 20),
              const Gap(6),
              Text(
                label,
                style: context.semiBold14.copyWith(
                  color: selected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) =>
      Text(title, style: context.semiBold16.textPrimary);

  Widget get _divider => Divider(height: 1, indent: 56, color: AppColors.divider);

  Widget _infoCard(List<Widget> children) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(children: children),
      );

  Widget _infoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const Gap(12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: context.regular12.textSecondary),
              const Gap(2),
              Text(
                value ?? '—',
                style: context.semiBold14.textPrimary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
