import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../injection.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'login_success_page.dart';

class OtpVerificationPage extends StatelessWidget {
  final String phoneNumber;
  const OtpVerificationPage({
    super.key,
    this.phoneNumber = '+62 812 3456 7890',
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Injection.provideAuthBloc(),
      child: _OtpVerificationView(phoneNumber: phoneNumber),
    );
  }
}

class _OtpVerificationView extends StatefulWidget {
  final String phoneNumber;
  const _OtpVerificationView({required this.phoneNumber});

  @override
  State<_OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<_OtpVerificationView> {
  int _counter = 30;
  Timer? _timer;

  late TapGestureRecognizer _editRecognizer;
  late TapGestureRecognizer _resendRecognizer;

  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _startTimer();

    _editRecognizer = TapGestureRecognizer()
      ..onTap = () => Navigator.of(context).pop();

    _resendRecognizer = TapGestureRecognizer()
      ..onTap = () {
        if (_counter == 0) {
          setState(() {
            _counter = 30;
          });
          _startTimer();
        }
      };

    _otpController.addListener(() {
      setState(() {});
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() {
          _counter--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _editRecognizer.dispose();
    _resendRecognizer.dispose();
    _otpController.dispose();
    _otpFocus.dispose();
    super.dispose();
  }

  void _verifyOtp() {
    context.read<AuthBloc>().add(VerifyOtpRequested(widget.phoneNumber, _otpController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: AppColors.ink),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthOtpSuccess) {
            Navigator.of(context).pushAndRemoveUntil(
              PageRouteBuilder(
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
                pageBuilder: (context, animation, secondaryAnimation) => const LoginSuccessPage(),
              ),
              (route) => false,
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 48),
                  const Hero(
                    tag: 'app_logo',
                    child: SizedBox.shrink(),
                  ),
                  const Text(
                    'Enter Verification Code',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.ink.withValues(alpha: 0.5),
                      ),
                      children: [
                        TextSpan(text: 'We sent a code to ${widget.phoneNumber} '),
                        TextSpan(
                          text: '(Edit)',
                          style: const TextStyle(
                            color: AppColors.brand,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: _editRecognizer,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  GestureDetector(
                    onTap: () => _otpFocus.requestFocus(),
                    child: Stack(
                      children: [
                        Opacity(
                          opacity: 0,
                          child: TextField(
                            controller: _otpController,
                            focusNode: _otpFocus,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            autofocus: true,
                            decoration: const InputDecoration(counterText: ''),
                          ),
                        ),
                        Row(
                          children: [
                            for (int i = 0; i < 6; i++)
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: i == 0 ? 0 : 4.0,
                                    right: i == 5 ? 0 : 4.0,
                                  ),
                                  child: Container(
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: _otpController.text.length > i
                                            ? AppColors.brand
                                            : (_otpController.text.length == i && _otpFocus.hasFocus)
                                                ? AppColors.brand.withValues(alpha: 0.5)
                                                : AppColors.line,
                                        width: 1.5,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      _otpController.text.length > i ? _otpController.text[i] : '',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.ink,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brand,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: AppColors.brand.withValues(alpha: 0.5),
                        disabledForegroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 0,
                      ),
                      onPressed: (_otpController.text.length == 6 && state is! AuthLoading) ? _verifyOtp : null,
                      child: state is AuthLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text(
                              'Verify',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.ink.withValues(alpha: 0.5),
                        ),
                        children: _counter > 0
                            ? [
                                const TextSpan(text: 'Resend code in '),
                                TextSpan(
                                  text: '${_counter}s',
                                  style: const TextStyle(
                                    color: AppColors.brand,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ]
                            : [
                                const TextSpan(text: "Didn't receive the code? "),
                                TextSpan(
                                  text: 'Resend Code',
                                  style: const TextStyle(
                                    color: AppColors.brand,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer: _resendRecognizer,
                                ),
                              ],
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
