import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/data/model/network_response.dart';
import 'package:task_manager_app/data/network_caller/network_caller.dart';
import 'package:task_manager_app/data/utilities/urls.dart';
import 'package:task_manager_app/ui/controller/auth_controller.dart';
import 'package:task_manager_app/ui/screens/auth/sign_in_screen.dart';
import 'package:task_manager_app/ui/utility/app_colors.dart';
import 'package:task_manager_app/ui/widgets/background_widgets.dart';
import 'package:task_manager_app/ui/widgets/centered_progress_indicator.dart';
import 'package:task_manager_app/ui/widgets/snack_bar_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _resetPasswordInProgress = false;
  String matchPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BackgroundWidgets(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 100),
                    Text(
                      "Set Password",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      "Minimum length of password should be mora than 6 letters and combination of numbers and letters.",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _passwordTEController,
                      obscureText: _showPassword == false,
                      decoration: InputDecoration(
                        hintText: "Password",
                        suffixIcon: IconButton(
                          onPressed: () {
                            _showPassword = !_showPassword;
                            if (mounted) {
                              setState(() {});
                            }
                          },
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "Enter your password";
                        } else if (value!.length < 8) {
                          return "Password must be at least 8 characters long";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _confirmPasswordTEController,
                      obscureText: _showConfirmPassword == false,
                      decoration: InputDecoration(
                        hintText: "Confirm password",
                        suffixIcon: IconButton(
                          onPressed: () {
                            _showConfirmPassword = !_showConfirmPassword;
                            if (mounted) {
                              setState(() {});
                            }
                          },
                          icon: Icon(
                            _showConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "Enter your password";
                        } else if (value!.length < 8) {
                          return "Password must be at least 8 characters long";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Visibility(
                      visible: _resetPasswordInProgress == false,
                      replacement: const CenterdProgressIndicator(),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (_confirmPasswordTEController.text ==
                                _passwordTEController.text) {
                              _resetPassword();
                            } else {
                              snackBarMessage(
                                context,
                                "Password did't match. Try again!",
                                true,
                              );
                            }
                          }
                        },
                        child: const Text("Confirm"),
                      ),
                    ),
                    const SizedBox(height: 36),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.8),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.4),
                          text: "Have an account? ",
                          children: [
                            TextSpan(
                              style:
                                  const TextStyle(color: AppColors.themeColor),
                              text: "Sign In",
                              recognizer: TapGestureRecognizer()
                                ..onTap = _onTapSingInButton,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _resetPassword() async {
    _resetPasswordInProgress = true;
    if (mounted) {
      setState(() {});
    }

    String? email = await AuthController.getVerificationEmail();
    String? otp = await AuthController.getVerificationOTP();

    if (email == null || otp == null) {
      if (mounted) {
        snackBarMessage(
          context,
          "Verification data not found. Please try again.",
          true,
        );
      }
      _resetPasswordInProgress = false;
      if (mounted) {
        setState(() {});
      }
      return;
    }

    Map<String, dynamic> requestInput = {
      "email": email,
      "OTP": otp,
      "password": _passwordTEController.text,
    };

    final NetworkResponse response = await NetworkCaller.postRequest(
      Urls.recoverResetPass,
      body: requestInput,
    );

    if (response.isSuccess) {
      if (mounted) {
        snackBarMessage(
          context,
          "Password successfully reset & updated",
        );
      }
      _onTapConfirmButton();
    } else {
      if (mounted) {
        snackBarMessage(
          context,
          response.errorMessage ?? 'Password reset failed. Try again!',
          true,
        );
      }
    }

    _resetPasswordInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  void _onTapSingInButton() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const SignInScreen(),
      ),
      (route) => false,
    );
  }

  void _onTapConfirmButton() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const SignInScreen(),
      ),
      (route) => false,
    );
  }

// @override
// void dispose() {
//   _passwordTEController.dispose();
//   _confirmPasswordTEController.dispose();
//   super.dispose();
// }
}
