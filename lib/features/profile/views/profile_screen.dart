import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:provider/provider.dart';
import 'package:stayzio_app/features/auth/data/provider/auth_provider.dart';
import 'package:stayzio_app/routes/app_route.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
              // Profile Title
              const Text(
                "Profile",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Profile Info Card
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Profile Picture
                    CircleAvatar(
                      radius: 24,
                      backgroundImage:
                          const AssetImage('assets/images/john.png'),
                      onBackgroundImageError: (exception, stackTrace) {},
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    // Name and Username
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context
                                    .watch<AuthProvider>()
                                    .currentUser
                                    ?.fullName ??
                                "Guest",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            context.watch<AuthProvider>().currentUser?.email ??
                                "Guest",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Edit Icon
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      onPressed: () {
                        context.router.push(const PersonalInfoRoute());
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              const Text(
                "Setting",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),

              // Menu Items
              _buildMenuItem(
                icon: IconsaxPlusBold.card,
                title: "Your Card",
                onTap: () => context.router.push(const YourCardRoute()),
              ),
              _buildMenuItem(
                icon: IconsaxPlusBold.security_safe,
                title: "Security",
                onTap: () {},
              ),
              _buildMenuItem(
                icon: IconsaxPlusBold.notification,
                title: "Notification",
                onTap: () {},
              ),
              _buildMenuItem(
                icon: IconsaxPlusBold.global,
                title: "Languages",
                onTap: () {},
              ),
              _buildMenuItem(
                icon: IconsaxPlusBold.info_circle,
                title: "Help and Support",
                onTap: () {},
              ),

              const Spacer(),

              // Logout Button
              Center(
                child: TextButton(
                  onPressed: () {
                    context.read<AuthProvider>().logout();

                    Fluttertoast.showToast(
                      msg: "You have been logged out.",
                      backgroundColor: Colors.orangeAccent,
                      textColor: Colors.white,
                      gravity: ToastGravity.TOP,
                    );

                    context.router.replaceAll([const SigninRoute()]);
                  },
                  child: const Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Bottom Navigation Bar
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.black),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected ? const Color(0xFF2B5FE0) : Colors.grey,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF2B5FE0) : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
