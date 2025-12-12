import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/utils/validators.dart';
import '../../core/widgets/modern_text_field.dart';
import '../../core/widgets/modern_button.dart';
import '../../core/widgets/modern_card.dart';
import '../../core/widgets/animated_background.dart';
import '../../core/theme/emoticare_design_system.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final isLoading = auth.isLoading;

    return Scaffold(
      body: AnimatedBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(EmotiCareDesignSystem.spacingLG),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: ModernCard(
                glowColor: EmotiCareDesignSystem.primaryPurple,
                padding: EdgeInsets.all(EmotiCareDesignSystem.spacingXXL),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Premium logo with gradient
                      Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: EmotiCareDesignSystem.primaryGradient,
                            shape: BoxShape.circle,
                            boxShadow: EmotiCareDesignSystem.shadowGlow,
                          ),
                          child: const Icon(
                            Icons.favorite_rounded,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      )
                          .animate()
                          .scale(delay: 200.ms, duration: 600.ms, curve: Curves.elasticOut)
                          .fadeIn(delay: 200.ms, duration: 500.ms),
                      SizedBox(height: EmotiCareDesignSystem.spacingXL),
                      // Welcome text with gradient
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            EmotiCareDesignSystem.primaryGradient.createShader(bounds),
                        child: Text(
                          'Welcome Back',
                          style: EmotiCareDesignSystem.textTheme.headlineLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 400.ms, duration: 600.ms)
                          .slideY(begin: 0.2, end: 0, delay: 400.ms, duration: 600.ms),
                      SizedBox(height: EmotiCareDesignSystem.spacingSM),
                      Text(
                        'Sign in to continue your wellness journey',
                        style: EmotiCareDesignSystem.textTheme.bodyMedium?.copyWith(
                          color: EmotiCareDesignSystem.neutralGray600,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      )
                          .animate()
                          .fadeIn(delay: 600.ms, duration: 500.ms),
                      SizedBox(height: EmotiCareDesignSystem.spacingXXL),
                      ModernTextField(
                        controller: _emailController,
                        label: 'Email',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.email,
                      )
                          .animate()
                          .fadeIn(delay: 800.ms, duration: 400.ms)
                          .slideX(begin: -0.2, end: 0, delay: 800.ms, duration: 400.ms),
                      SizedBox(height: EmotiCareDesignSystem.spacingLG),
                      ModernTextField(
                        controller: _passwordController,
                        label: 'Password',
                        icon: Icons.lock_outlined,
                        obscure: true,
                        validator: (v) => Validators.minLength(v, min: 6),
                      )
                          .animate()
                          .fadeIn(delay: 900.ms, duration: 400.ms)
                          .slideX(begin: -0.2, end: 0, delay: 900.ms, duration: 400.ms),
                      SizedBox(height: EmotiCareDesignSystem.spacingXXL),
                      ModernButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                                if (!_formKey.currentState!.validate()) return;
                                await ref.read(authProvider.notifier).login(
                                      _emailController.text.trim(),
                                      _passwordController.text,
                                    );
                                if (ref.read(authProvider).isAuthenticated && mounted) {
                                  context.go('/');
                                }
                              },
                        label: isLoading ? 'Signing in...' : 'Sign in',
                        icon: isLoading ? null : Icons.login_rounded,
                        isLoading: isLoading,
                        fullWidth: true,
                      )
                          .animate()
                          .fadeIn(delay: 1000.ms, duration: 400.ms)
                          .slideY(begin: 0.2, end: 0, delay: 1000.ms, duration: 400.ms),
                      if (auth.error != null) ...[
                        SizedBox(height: EmotiCareDesignSystem.spacingMD),
                        Container(
                          padding: EdgeInsets.all(EmotiCareDesignSystem.spacingMD),
                          decoration: BoxDecoration(
                            color: EmotiCareDesignSystem.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                              EmotiCareDesignSystem.radiusLG,
                            ),
                            border: Border.all(
                              color: EmotiCareDesignSystem.error.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                color: EmotiCareDesignSystem.error,
                                size: 20,
                              ),
                              SizedBox(width: EmotiCareDesignSystem.spacingSM),
                              Expanded(
                                child: Text(
                                  auth.error!,
                                  style: EmotiCareDesignSystem.textTheme.bodyMedium?.copyWith(
                                    color: EmotiCareDesignSystem.error,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 1100.ms, duration: 400.ms)
                            .shake(delay: 1100.ms, duration: 400.ms),
                      ],
                      SizedBox(height: EmotiCareDesignSystem.spacingLG),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: EmotiCareDesignSystem.textTheme.bodyMedium?.copyWith(
                              color: EmotiCareDesignSystem.neutralGray600,
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.go('/register'),
                            child: Text(
                              'Create account',
                              style: EmotiCareDesignSystem.textTheme.bodyMedium?.copyWith(
                                color: EmotiCareDesignSystem.primaryPurple,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      )
                          .animate()
                          .fadeIn(delay: 1200.ms, duration: 400.ms),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
