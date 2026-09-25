import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartversemobile/app/app_route.dart';
import 'package:smartversemobile/app/theme/app_colors.dart';
import 'package:smartversemobile/feautures/auth/presentation/cubit/login_cubit.dart';
import 'package:smartversemobile/feautures/auth/presentation/cubit/login_state.dart';
import 'package:smartversemobile/feautures/auth/presentation/widgets/auth_submit_button.dart';
import 'package:smartversemobile/feautures/auth/presentation/widgets/auth_text_field.dart';
import 'package:smartversemobile/feautures/auth/presentation/widgets/forgot_password_sheet.dart';
import 'package:smartversemobile/feautures/auth/presentation/widgets/incorrect_password_sheet.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _rememberMe = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<LoginCubit>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.of(context, rootNavigator: true)
              .pushNamedAndRemoveUntil(AppRoute.dashboardScreen, (route) => false);
        } else if (state is LoginFailure) {
          if (state.statusCode == 401) {
            IncorrectPasswordSheet.show(context, email: _emailController.text.trim());
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        }
      },
      builder: (context, state) {
        final isLoading = state is LoginLoading;
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthTextField(
                label: "Email Address",
                hintText: "You@example.com",
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Email is required';
                  if (!value.contains('@')) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              AuthTextField(
                label: "Password",
                hintText: "Min.8 character",
                controller: _passwordController,
                isPassword: true,
                prefixIconData: Icons.lock_outline,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _rememberMe,
                          activeColor: AppColors.primary,
                          shape: const CircleBorder(),
                          side: const BorderSide(color: AppColors.grey),
                          onChanged: (val) {
                            setState(() {
                              _rememberMe = val ?? false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text("Remember Me", style: TextStyle(fontSize: 13, color: AppColors.black2)),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => ForgotPasswordSheet.show(context),
                    child: const Text("Forgot Password?", style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              AuthSubmitButton(
                text: isLoading ? "Logging in..." : "Login",
                onTap: isLoading ? () {} : _handleLogin,
              ),
            ],
          ),
        );
      },
    );
  }
}