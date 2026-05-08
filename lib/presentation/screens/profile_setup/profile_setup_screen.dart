import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/constants/app_colors.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _neighborhoodController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  double _alertRadius = 1000;
  bool _isLoading = false;
  final List<String> _emergencyContacts = [];

  Future<void> _saveProfile() async {
    if (_neighborhoodController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your neighborhood')),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'neighborhood': _neighborhoodController.text.trim(),
        'alertRadius': _alertRadius,
        'emergencyContacts': _emergencyContacts,
      });
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save profile')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _addEmergencyContact() {
    if (_emergencyContactController.text.isNotEmpty) {
      setState(() {
        _emergencyContacts.add(_emergencyContactController.text.trim());
        _emergencyContactController.clear();
      });
    }
  }

  @override
  void dispose() {
    _neighborhoodController.dispose();
    _emergencyContactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Icon(Icons.shield, size: 60, color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Setup Your Profile',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Center(
                child: Text(
                  'Help us keep you safe',
                  style: TextStyle(color: AppColors.grey),
                ),
              ),
              const SizedBox(height: 40),
              const Text('Your Neighborhood',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _neighborhoodController,
                decoration: InputDecoration(
                  hintText: 'e.g. Sector 1, Bucharest',
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: AppColors.primary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Alert Radius',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('500m'),
                  Expanded(
                    child: Slider(
                      value: _alertRadius,
                      min: 500,
                      max: 5000,
                      divisions: 2,
                      activeColor: AppColors.primary,
                      label: _alertRadius == 500
                          ? '500m'
                          : _alertRadius == 1000
                              ? '1km'
                              : '5km',
                      onChanged: (value) =>
                          setState(() => _alertRadius = value),
                    ),
                  ),
                  const Text('5km'),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Emergency Contacts',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _emergencyContactController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Phone number',
                        prefixIcon: const Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _addEmergencyContact,
                    icon: const Icon(Icons.add_circle,
                        color: AppColors.primary, size: 36),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ..._emergencyContacts.map((contact) => ListTile(
                    leading: const Icon(Icons.person,
                        color: AppColors.primary),
                    title: Text(contact),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => setState(
                          () => _emergencyContacts.remove(contact)),
                    ),
                  )),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white)
                      : const Text(
                          'Save & Continue',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}