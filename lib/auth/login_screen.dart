import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  String? _emailError;
  String? _passwordError;
  bool _isLoading = false;
  bool _hidePassword = true;

  @override
  void initState() {
    super.initState();
    _emailCtrl.addListener(_onFieldsChanged);
    _passCtrl.addListener(_onFieldsChanged);
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _emailCtrl.text.isNotEmpty && _passCtrl.text.isNotEmpty && !_isLoading;

  void _onFieldsChanged() {
    if (_emailError != null || _passwordError != null) {
      setState(() {
        _emailError = null;
        _passwordError = null;
      });
    } else {
      setState(() {});
    }
  }

  Future<void> _submit() async {
    if (!_canSubmit) return;

    setState(() {
      _isLoading = true;
      _emailError = null;
      _passwordError = null;
    });

    await Future.delayed(const Duration(seconds: 2));

    const correctEmail = 'yourmail@gmail.com';
    const correctPass = '12345678';

    String? emailErr;
    String? passErr;

    if (_emailCtrl.text != correctEmail) {
      emailErr = 'Invalid email, try again';
    } else if (_passCtrl.text != correctPass) {
      passErr = 'Wrong password, try again';
    }

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _emailError = emailErr;
      _passwordError = passErr;
    });

    if (emailErr == null && passErr == null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Logged in'),
          content: const Text('Welcome back!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 100),

              const Center(
                child: Text(
                  'Masari',
                  style: TextStyle(
                    fontFamily: 'GreatVibes',
                    fontSize: 50,
                    color: Color(0xFF00A0E3),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Center(
                child: Text('Welcome Back!', style: TextStyle(fontSize: 30)),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Please enter your credentials to continue.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ),

              const SizedBox(height: 40),

              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'yourmail@gmail.com',
                  errorText: _emailError,
                  suffixIcon: const Icon(Icons.email_outlined, size: 18),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _passCtrl,
                obscureText: _hidePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: '********',
                  errorText: _passwordError,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _hidePassword
                          ? Icons.visibility_off_rounded
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

              const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(fontSize: 12, color: primary),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: _canSubmit ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isLoading
                        ? const Color(0xFF005A8D)
                        : (_canSubmit ? primary : const Color(0xFFE0E0E0)),
                    disabledBackgroundColor: const Color(0xFFE0E0E0),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Log in',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don’t have an account? ',
                    style: TextStyle(fontSize: 12),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Register now',
                      style: TextStyle(fontSize: 12, color: primary),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
