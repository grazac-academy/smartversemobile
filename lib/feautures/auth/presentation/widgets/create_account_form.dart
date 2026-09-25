import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartversemobile/feautures/auth/presentation/cubit/register_cubit.dart';
import 'package:smartversemobile/feautures/auth/presentation/cubit/register_state.dart';
import 'package:smartversemobile/feautures/auth/presentation/widgets/auth_submit_button.dart';
import 'package:smartversemobile/feautures/auth/presentation/widgets/auth_text_field.dart';
import 'package:smartversemobile/feautures/auth/presentation/widgets/password_strength_bar.dart';
import 'package:smartversemobile/feautures/auth/presentation/screens/personal_info_screen.dart';

class CreateAccountForm extends StatefulWidget {
  const CreateAccountForm({super.key});

  @override
  State<CreateAccountForm> createState() => _CreateAccountFormState();
}

class _CreateAccountFormState extends State<CreateAccountForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleCreateAccount() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<RegisterCubit>().register(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PersonalInfoScreen(email: _emailController.text.trim()),
            ),
          );
        } else if (state is RegisterFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is RegisterLoading;
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthTextField(
                label: "Full Name",
                hintText: "Enter your full name",
                controller: _nameController,
                prefixIconPath: 'assets/icons/Icon(account).svg',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Full name is required';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              AuthTextField(
                label: "Email Address",
                hintText: "You@example.com",
                controller: _emailController,
                prefixIconData: Icons.mail_outline,
                suffixIconPath: 'assets/images/check_mark.svg',
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
                validator: (value) {
                  if (value == null || value.length < 8) return 'Minimum 8 characters';
                  return null;
                },
              ),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _passwordController,
                builder: (context, value, child) {
                  return PasswordStrengthBar(password: value.text);
                },
              ),
              const SizedBox(height: 30),
              AuthSubmitButton(
                text: isLoading ? "Creating account..." : "Create Account",
                onTap: isLoading ? () {} : _handleCreateAccount,
              ),
            ],
          ),
        );
      },
    );
  }
}