import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/data/model/login_model.dart';
import 'package:task_manager_app/data/model/network_response.dart';
import 'package:task_manager_app/data/network_caller/network_caller.dart';
import 'package:task_manager_app/data/utilities/urls.dart';
import 'package:task_manager_app/ui/controller/auth_controller.dart';
import 'package:task_manager_app/ui/screens/auth/email_verification_screen.dart';
import 'package:task_manager_app/ui/screens/auth/sign_up_screen.dart';
import 'package:task_manager_app/ui/screens/bottom_nav_main_screen.dart';
import 'package:task_manager_app/ui/utility/app_colors.dart';
import 'package:task_manager_app/ui/utility/app_constants.dart';
import 'package:task_manager_app/ui/widgets/background_widgets.dart';
import 'package:task_manager_app/ui/widgets/centered_progress_indicator.dart';
import 'package:task_manager_app/ui/widgets/snack_bar_message.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _showPassword = false;

  bool _signInAPIInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BackgroundWidgets(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 100),
                    Text(
                      "Get Started With",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _emailTEController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(hintText: "Email"),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "Enter your email";
                        }

                        if (AppConstants.emailRegExp.hasMatch(value!) ==
                            false) {
                          return "Enter a valid email address";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
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
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Visibility(
                      visible: _signInAPIInProgress == false,
                      replacement: const CenterdProgressIndicator(),
                      child: ElevatedButton(
                        onPressed: _signIn,
                        child: const Icon(Icons.arrow_circle_right_outlined),
                      ),
                    ),
                    const SizedBox(height: 36),
                    Center(
                      child: Column(
                        children: [
                          TextButton(
                            onPressed: _onTapForgotPasswordButton,
                            child: const Text("Forgot Password?"),
                          ),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.4),
                              text: "Don't have an account? ",
                              children: [
                                TextSpan(
                                  style: const TextStyle(
                                      color: AppColors.themeColor),
                                  text: "Sign Up",
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = _onTapSingUpButton,
                                ),
                              ],
                            ),
                          ),
                        ],
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

  Future<void> _signIn() async {
    _signInAPIInProgress = true;
    if (mounted) {
      setState(() {});
    }

    Map<String, dynamic> requestData = {
      "email": _emailTEController.text.trim(),
      "password": _passwordTEController.text,
    };

    final NetworkResponse response =
        await NetworkCaller.postRequest(Urls.logIn, body: requestData);

    _signInAPIInProgress = false;
    if (mounted) {
      setState(() {});
    }

    if (response.isSuccess) {
      LoginModel loginModel = LoginModel.fromJson(response.reponseData);
      await AuthController.saveUserAccessToken(loginModel.token!);
      await AuthController.saveUserData(loginModel.userModel!);

      if (_formKey.currentState!.validate()) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const BottomNavMainScreen(),
            ),
          );
        }
      }
    } else {
      if (mounted) {
        snackBarMessage(
          context,
          response.errorMessage ?? "Email/Password is not correct. Try again",
          true,
        );
      }
    }
  }

  void _onTapSingUpButton() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }

  void _onTapForgotPasswordButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EmailVerificationScreen(),
      ),
    );
  }

// @override
// void dispose() {
//   _emailTEController.dispose();
//   _passwordTEController.dispose();
//   super.dispose();
// }
}
