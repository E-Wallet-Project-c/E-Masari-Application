import 'package:flutter/material.dart';

class createprofileScreen extends StatefulWidget {
  const createprofileScreen({super.key});

  @override
  State<createprofileScreen> createState() => _createprofileScreenState();
}

class _createprofileScreenState extends State<createprofileScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _dobCtrl = TextEditingController(); // read-only text for date

  DateTime? _selectedDate;
  String _selectedCountry = 'Jordan';
  bool _isLoading = false;

  final List<String> _countries = [
    'Jordan',
    'Qatar',
    'Saudi Arabia',
    'United Arab Emirates',
    'Kuwait',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _dobCtrl.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _nameCtrl.text.isNotEmpty &&
      _phoneCtrl.text.isNotEmpty &&
      _dobCtrl.text.isNotEmpty &&
      !_isLoading;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = DateTime(now.year - 20, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1950),
      lastDate: now,
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dobCtrl.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  Future<void> _submit() async {
    if (!_canSubmit) return;

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile created successfully')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    final inputBorder = Theme.of(context).inputDecorationTheme.border;
    final BorderRadius globalRadius = inputBorder is OutlineInputBorder
        ? inputBorder.borderRadius
        : BorderRadius.circular(15);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Back + title
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_rounded, size: 22),
                  padding: EdgeInsets.zero,
                ),
                const SizedBox(height: 200),

                const Text(
                  'Create profile',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            const Text(
              'Please enter your personal information to complete your account.',
              style: TextStyle(fontSize: 13, color: Colors.black),
            ),
            const SizedBox(height: 60),

            // Full name
            TextField(
              controller: _nameCtrl,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                hintText: 'Full name',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            const SizedBox(height: 5),

            // Phone: "Phone  +962 | 0 0000 0000"
            TextField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: '0 0000 0000',
                floatingLabelBehavior: FloatingLabelBehavior.never,
                prefixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 12),
                    const Text(
                      'Phone',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '+962',
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 1,
                      height: 32,
                      color: const Color(0xFFD0D0D0),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 0,
                  minHeight: 0,
                ),
              ),
            ),

            const SizedBox(height: 5),

            // Date of birth
            TextField(
              controller: _dobCtrl,
              readOnly: true,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: 'Date of Birth',
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.calendar_month,
                    size: 30,
                    color: Colors.grey,
                  ),
                  onPressed: _pickDate,
                ),
              ),
              onTap: _pickDate,
            ),

            const SizedBox(height: 5),

            // Country dropdown: "Country | 🇯🇴 Jordan"
            DropdownButtonFormField<String>(
              initialValue: _selectedCountry,
              decoration: InputDecoration(
                prefixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 12),
                    const Text(
                      'Country',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 1,
                      height: 32,
                      color: const Color(0xFFD0D0D0),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 0,
                  minHeight: 0,
                ),
              ),
              items: _countries
                  .map(
                    (c) => DropdownMenuItem<String>(
                      
                      value: c,
                      child: Row(
                        children: [
                          Text(
                            c == 'Jordan'
                                ? '🇯🇴'
                                : c == 'Qatar'
                                ? '🇶🇦'
                                : c == 'Saudi Arabia'
                                ? '🇸🇦'
                                : c == 'United Arab Emirates'
                                ? '🇦🇪'
                                : '🇰🇼',
                          ),
                          const SizedBox(width: 6),
                          Text(c),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _selectedCountry = value;
                });
              },
            ),

            const SizedBox(height: 32),

            // Create profile button
            SizedBox(
              height: 44,
              child: ElevatedButton(
                onPressed: _canSubmit ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isLoading
                      ? const Color(0xFF005A8D)
                      : (_canSubmit ? primary : const Color(0xFFE0E0E0)),
                  disabledBackgroundColor: const Color(0xFFE0E0E0),
                  shape: RoundedRectangleBorder(borderRadius: globalRadius),
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
                        'Create profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
