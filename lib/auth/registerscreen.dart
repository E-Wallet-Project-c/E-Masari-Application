import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  bool _isSubmitting = false;

  bool _hasMinLength = false;
  bool _hasUpper = false;
  bool _hasLower = false;
  bool _hasNumber = false;
  bool _hasSpecial = false;

  String? _passwordError;
  String? _confirmError;

  // spacing constants tuned to match the Figma-like screen
  static const double _spaceAfterBack = 24;
  static const double _spaceAfterLogo = 20;
  static const double _spaceBetweenTitleAndSubtitle = 4;
  static const double _spaceAfterSubtitle = 28;
  static const double _spaceBetweenFields = 14;
  static const double _spaceAfterConfirm = 10;
  static const double _spaceAfterBars = 16;
  static const double _spaceAfterRequirements = 24;
  static const double _spaceAfterButton = 12;

  @override
  void initState() {
    super.initState();
    _passCtrl.addListener(_validatePassword);
    _confirmCtrl.addListener(_validateConfirm);
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  bool get _isPasswordValid =>
      _hasMinLength && _hasUpper && _hasLower && _hasNumber && _hasSpecial;

  bool get _canSubmit =>
      _emailCtrl.text.isNotEmpty &&
      _passCtrl.text.isNotEmpty &&
      _confirmCtrl.text.isNotEmpty &&
      _isPasswordValid &&
      _passCtrl.text == _confirmCtrl.text &&
      !_isSubmitting;

  void _validatePassword() {
    final text = _passCtrl.text;

    setState(() {
      _hasMinLength = text.length >= 8;
      _hasUpper = text.contains(RegExp(r'[A-Z]'));
      _hasLower = text.contains(RegExp(r'[a-z]'));
      _hasNumber = text.contains(RegExp(r'[0-9]'));
      _hasSpecial = text.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));
      _passwordError = null;
    });

    _validateConfirm();
  }

  void _validateConfirm() {
    setState(() {
      _confirmError = null;
    });
  }

  Future<void> _submit() async {
    if (!_canSubmit) return;

    if (!_isPasswordValid) {
      setState(() {
        _passwordError = 'Password does not meet all requirements.';
      });
      return;
    }

    if (_passCtrl.text != _confirmCtrl.text) {
      setState(() {
        _confirmError = 'Passwords do not match.';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _passwordError = null;
      _confirmError = null;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() {
      _isSubmitting = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Account created (mock).')));
  }

  // bullet row (icon + text) for each rule
  Widget _buildRequirementRow(String text, bool ok) {
    return Row(
      children: [
        Icon(
          ok ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 14,
          color: ok ? const Color(0xFF00B341) : Colors.black54,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: ok ? const Color(0xFF00B341) : Colors.black54,
              fontWeight: ok ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  // 5 green/grey bars under confirm password
  Widget _buildStrengthBars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _bar(_hasMinLength),
        _bar(_hasUpper),
        _bar(_hasLower),
        _bar(_hasNumber),
        _bar(_hasSpecial),
      ],
    );
  }

  Widget _bar(bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 4,
      width: 60,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF00B341) : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: _spaceAfterBack),

              // logo centered
              Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_rounded, size: 22),

                      constraints: const BoxConstraints(),
                    ),
                  ),
                  SizedBox(width: 25),
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 200,
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: _spaceAfterLogo),

              // title + subtitle centered (like the mockup)
              const Center(
                child: Text(
                  "Let’s get started",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(height: _spaceBetweenTitleAndSubtitle),
              const Center(
                child: Text(
                  'Enter your details to get started',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
              ),

              const SizedBox(height: _spaceAfterSubtitle),

              // fields (same width as button)
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'youremail@gmail.com',
                ),
              ),

              const SizedBox(height: _spaceBetweenFields),

              TextField(
                controller: _passCtrl,
                obscureText: _hidePassword,
                decoration: InputDecoration(
                  labelText: 'Create password',
                  hintText: '********',
                  errorText: _passwordError,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _hidePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18,
                    ),
                    onPressed: () {
                      setState(() {
                        _hidePassword = !_hidePassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: _spaceBetweenFields),

              TextField(
                controller: _confirmCtrl,
                obscureText: _hideConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Confirm password',
                  hintText: '********',
                  errorText: _confirmError,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _hideConfirmPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18,
                    ),
                    onPressed: () {
                      setState(() {
                        _hideConfirmPassword = !_hideConfirmPassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: _spaceAfterConfirm),

              _buildStrengthBars(),

              const SizedBox(height: _spaceAfterBars),

              const Text(
                'Password must contain:',
                style: TextStyle(fontSize: 11, color: Colors.black87),
              ),
              const SizedBox(height: 4),

              _buildRequirementRow('8 or more characters', _hasMinLength),
              _buildRequirementRow('At least 1 uppercase letter', _hasUpper),
              _buildRequirementRow('At least 1 lowercase letter', _hasLower),
              _buildRequirementRow('At least 1 Number', _hasNumber),
              _buildRequirementRow(
                'At least 1 special characters',
                _hasSpecial,
              ),

              const SizedBox(height: _spaceAfterRequirements),

              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _canSubmit ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isSubmitting
                        ? const Color(0xFFB0B0B0)
                        : (_canSubmit ? primary : const Color(0xFFB0B0B0)),
                    disabledBackgroundColor: const Color(0xFFB0B0B0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Create account',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: _spaceAfterButton),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(fontSize: 12),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 12, color: primary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
