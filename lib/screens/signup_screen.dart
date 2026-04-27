import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_design.dart';
import 'signin_screen.dart';
import 'home_screen.dart';

import '../data/service_locator.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleSignUp() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await locator.authRepository.register(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );

      debugPrint(
        "Signup Response: token=${response.token}, message=${response.message}",
      );

      if (mounted) {
        if (response.token != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Account Created! Navigating..."),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message ?? "Registration failed"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Signup Error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 🔹 Background Image (Static)
          Positioned.fill(
            child: Image.asset(
              "assets/reg_bg1.jpg",
              fit: BoxFit.cover,
            ),
          ),

          // 🔹 Gradient Overlay (Static)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.85),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // 🔹 Scrollable Content
          SingleChildScrollView(
            padding: EdgeInsets.all(AppDesign.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                /// 🔹 Logo + Branding
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        image: const DecorationImage(
                          image: AssetImage("assets/icon1.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Platera",
                      style: AppDesign.headingLarge(context).copyWith(
                        color: Colors.white,
                        fontSize: 22,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                /// 🔹 Title
                Text(
                  "Create Account",
                  style: AppDesign.headingLarge(
                    context,
                  ).copyWith(fontSize: 40, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  "Join the future of clean, organic culinary technology.",
                  style: AppDesign.bodyMedium(
                    context,
                  ).copyWith(color: Colors.white.withOpacity(0.7)),
                ),

                const SizedBox(height: 40),

                /// 🔹 Glassmorphism Card
                RepaintBoundary(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          /// Full Name
                          _GlassTextField(
                            label: "Full Name",
                            hint: "John Doe",
                            icon: Icons.person_outline,
                            controller: _nameController,
                          ),

                          const SizedBox(height: 24),

                          /// Email
                          _GlassTextField(
                            label: "Email Address",
                            hint: "hello@platera.com",
                            icon: Icons.email_outlined,
                            controller: _emailController,
                          ),

                          const SizedBox(height: 24),

                          /// Password
                          _GlassTextField(
                            label: "Password",
                            hint: "••••••••",
                            icon: Icons.lock_outline,
                            isPassword: true,
                            controller: _passwordController,
                          ),

                          const SizedBox(height: 28),

                          /// Button
                          _ActionButton(
                            text: "Create Account",
                            isLoading: _isLoading,
                            onTap: _handleSignUp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

                const SizedBox(height: 50),

                /// 🔹 Footer
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: AppDesign.bodyMedium(
                          context,
                        ).copyWith(color: Colors.white.withOpacity(0.7)),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SigninScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Sign In",
                          style: AppDesign.bodyMedium(context).copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
    );
  }
}

class _GlassTextField extends StatelessWidget {
  final String label;
  final String hint;
  final bool isPassword;
  final IconData icon;
  final TextEditingController controller;

  const _GlassTextField({
    required this.label,
    required this.hint,
    this.isPassword = false,
    required this.icon,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppDesign.bodySmall(context).copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDesign.borderRadiusMedium),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppDesign.bodyMedium(
                context,
              ).copyWith(color: Colors.white.withOpacity(0.4)),
              prefixIcon: Icon(
                icon,
                size: 20,
                color: Colors.white.withOpacity(0.6),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isLoading;

  const _ActionButton({
    required this.text,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  text,
                  style: AppDesign.bodyMedium(context).copyWith(
                    color: AppColors.textBody(context),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
        ),
      ),
    );
  }
}
