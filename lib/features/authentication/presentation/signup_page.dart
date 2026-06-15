import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sync_communication_app/core/core.dart';
import 'package:sync_communication_app/widgets/app_snackbar.dart';
import 'package:sync_communication_app/widgets/custom_text_field.dart';
import 'package:sync_communication_app/widgets/gradient_background.dart';
import 'package:sync_communication_app/cubit/cubit.dart';
import 'package:sync_communication_app/widgets/gradient_button.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isObsecure = true;
  bool isConfirmsObsecure = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          AppSnackBar.show(state.message);
        }
        if (state is AuthSuccess) {
          context.read<UserCubit>().saveUser(state.userModel).then((_) {
            if (!context.mounted) return;
            final user = context.read<UserCubit>().state.user;
            if (user == null) return;
            context.read<PresenceCubit>().activate(user.uid);
            if (!context.mounted) return;
            context.read<ZegoCubit>().initCall(
              userId: user.uid,
              userName: user.username,
            );
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.mainNavigation,
              (route) => false,
            );
          });
        }
      },
      child: GradientBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Logo / Icon ──
                Container(
                  width: 72,
                  height: 72,
                  margin: const EdgeInsets.only(bottom: 32, top: 70),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: context.mainLinearGradient,
                  ),
                  child: const Icon(Icons.video_call, size: 36),
                ),

                Text("Join Us 🎉", style: context.textTheme.headlineLarge),

                const SizedBox(height: 8),

                Text("Signup To Start", style: context.textTheme.headlineSmall),

                const SizedBox(height: 40),
                CustomTextField(
                  controller: usernameController,
                  hint: "Username",
                  icon: Icons.person_2_rounded,
                  keyboardType: TextInputType.text,
                  validator: (value) => Validators.name(value),
                ),

                // ── Email ──
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: CustomTextField(
                    controller: emailController,
                    hint: "Email",
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => Validators.email(value),
                  ),
                ),

                // ── Password ──
                CustomTextField(
                  controller: passwordController,
                  hint: "Password",
                  icon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isObsecure = !isObsecure;
                      });
                    },
                    icon: Icon(
                      isObsecure
                          ? Icons.visibility_off_rounded
                          : Icons.remove_red_eye_rounded,
                    ),
                  ),
                  obscure: isObsecure,
                  validator: (value) => Validators.password(value),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: CustomTextField(
                    controller: confirmPasswordController,
                    hint: "Confirm Password",
                    icon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isConfirmsObsecure = !isConfirmsObsecure;
                        });
                      },
                      icon: Icon(
                        isConfirmsObsecure
                            ? Icons.visibility_off_rounded
                            : Icons.remove_red_eye_rounded,
                      ),
                    ),
                    obscure: isConfirmsObsecure,
                    validator: (value) => Validators.confirmPassword(
                      value,
                      passwordController.text,
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                GradientButton(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<AuthCubit>().signup(
                        username: usernameController.text,
                        email: emailController.text,
                        password: passwordController.text,
                      );
                    }
                  },
                  text: 'Signup',
                ),
                const SizedBox(height: 24),

                // ── Divider ──
                Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "or continue with",
                        style: context.textTheme.labelSmall,
                      ),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),

                // ── Google Sign In button ──
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      context.read<AuthCubit>().signInWithGoogle();
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      padding: const EdgeInsets.all(12),
                      margin: EdgeInsets.symmetric(vertical: 24),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: context.scheme.surfaceContainerHighest,
                        border: Border.all(color: context.scheme.outline),
                      ),
                      child: SvgPicture.asset(
                        context.isDark
                            ? "assets/icons/white_google.svg"
                            : "assets/icons/colored_google.svg",
                        height: 25,
                        width: 25,
                      ),
                    ),
                  ),
                ),

                // ── Sign up ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?  ",
                      style: context.textTheme.labelMedium!.copyWith(
                        color: context.scheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.login,
                          (route) => false,
                        );
                      },
                      child: Text(
                        "Login",
                        style: context.textTheme.labelMedium,
                      ),
                    ),
                  ],
                ),
                BlocSelector<AuthCubit, AuthState, bool>(
                  selector: (state) => state is AuthLoading,
                  builder: (context, isLoading) {
                    if (isLoading) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Align(
                          alignment: AlignmentGeometry.center,
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: const CircularProgressIndicator(),
                          ),
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
