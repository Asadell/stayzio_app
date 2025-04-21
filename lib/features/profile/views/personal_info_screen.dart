import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:stayzio_app/features/auth/data/model/user.dart';
import 'package:stayzio_app/features/auth/data/provider/auth_provider.dart';

@RoutePage()
class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  bool _isEditing = false;

  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;

    _fullNameController = TextEditingController(text: user?.fullName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneNumberController =
        TextEditingController(text: user?.phoneNumber ?? '');
  }

  Widget _buildInfoField({
    required String label,
    required TextEditingController controller,
    required bool enabled,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: enabled,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Future<void> _saveChanges() async {
    final provider = context.read<AuthProvider>();
    final current = provider.currentUser;

    if (current == null) return;

    final updatedUser = User(
      id: current.id,
      email: _emailController.text,
      fullName: _fullNameController.text,
      password: current.password,
      phoneNumber: _phoneNumberController.text,
      username: current.username,
      profileImage: current.profileImage,
      createdAt: current.createdAt,
    );

    final success = await provider.updateUserInfo(updatedUser);
    if (success && mounted) {
      setState(() {
        _isEditing = false;
      });

      Fluttertoast.showToast(
        msg: "Profile updated successfully!",
        backgroundColor: Colors.green,
        textColor: Colors.white,
        gravity: ToastGravity.TOP,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Failed to update profile",
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        gravity: ToastGravity.TOP,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // App Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    onPressed: () => context.router.pop(),
                  ),

                  // Title
                  const Text(
                    "Personal Info",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Edit Button
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () {
                      setState(() {
                        _isEditing = !_isEditing;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              _buildInfoField(
                label: "Full Name",
                controller: _fullNameController,
                enabled: _isEditing,
              ),
              _buildInfoField(
                label: "Email",
                controller: _emailController,
                enabled: _isEditing,
              ),
              _buildInfoField(
                label: "Phone",
                controller: _phoneNumberController,
                enabled: _isEditing,
              ),

              const Spacer(),

              if (_isEditing)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 24),
                  child: ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.grey[600],
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Save Changes",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
