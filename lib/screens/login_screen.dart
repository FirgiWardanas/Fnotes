
import 'package:flutter/material.dart';
import '../core/app_colors.dart';

enum AuthTab { login, register }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  AuthTab _activeTab = AuthTab.login;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _rememberMe = true;
  bool _agreeTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _switchTab(AuthTab tab) {
    if (_activeTab == tab) return;
    setState(() {
      _activeTab = tab;
      _formKey.currentState?.reset();
    });
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    if (_activeTab == AuthTab.register && !_agreeTerms) {
      _showNotice('Harap setujui Ketentuan Layanan & Kebijakan Privasi');
      return;
    }

    setState(() => _isLoading = true);

    // ponytail: client-side dynamic simulation. Upgrade path: connect to real auth backend.
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      if (_activeTab == AuthTab.login) {
        _showSuccess('Berhasil masuk sebagai ${_emailController.text}');
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showSuccess('Akun berhasil dibuat! Silakan masuk.');
        setState(() {
          _activeTab = AuthTab.login;
          _passwordController.clear();
          _confirmPasswordController.clear();
        });
      }
    });
  }

  void _showNotice(String msg) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
      ),
    );
  }

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.secondaryContainer, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(msg, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
        backgroundColor: AppColors.onSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLogin = _activeTab == AuthTab.login;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 12),

              // Emblem Icon
              Center(
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(26),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryDark.withValues(alpha: 0.2),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            width: 48,
                            height: 44,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 4,
                                  width: double.infinity,
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2)),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  height: 4,
                                  width: 24,
                                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.85), borderRadius: BorderRadius.circular(2)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: -4,
                        bottom: -4,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: AppColors.secondaryContainer,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                            ],
                          ),
                          child: const Icon(Icons.check, size: 18, color: AppColors.primaryDark),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'FNotes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),

              Text(
                isLogin ? 'Selamat Datang Kembali' : 'Mulai Menulis Hari Ini',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: 290,
                child: Text(
                  isLogin
                      ? 'Ruang tenang untuk menata ide, refleksi harian, dan rencanamu.'
                      : 'Buat akun baru gratis dan mulai kumpulkan inspirasi berhargamu.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Segmented Switch (Masuk vs Daftar Akun)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _switchTab(AuthTab.login),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isLogin ? AppColors.surfaceWhite : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: isLogin
                                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)]
                                : [],
                          ),
                          child: Center(
                            child: Text(
                              'Masuk',
                              style: TextStyle(
                                fontWeight: isLogin ? FontWeight.w700 : FontWeight.w600,
                                fontSize: 14,
                                color: isLogin ? AppColors.primary : AppColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _switchTab(AuthTab.register),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: !isLogin ? AppColors.surfaceWhite : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: !isLogin
                                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)]
                                : [],
                          ),
                          child: Center(
                            child: Text(
                              'Daftar Akun',
                              style: TextStyle(
                                fontWeight: !isLogin ? FontWeight.w700 : FontWeight.w600,
                                fontSize: 14,
                                color: !isLogin ? AppColors.primary : AppColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Form Container
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.outline),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.onSurface.withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Register Only: Full Name
                      if (!isLogin) ...[
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Nama Lengkap',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.onSurfaceVariant),
                            ),
                            Flexible(
                              child: Text(
                                'Sesuai panggilanmu',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 11, color: AppColors.outlineVariant),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: _inputDecoration(
                            hint: 'Misal: Dimas Pratama',
                            prefixIcon: Icons.person_outline,
                          ),
                          validator: (value) {
                            if (!isLogin) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Nama wajib diisi';
                              }
                              if (value.trim().length < 3) {
                                return 'Nama minimal 3 karakter';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Email Field
                      const Text(
                        'Alamat Email',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDecoration(
                          hint: 'nama@email.com',
                          prefixIcon: Icons.alternate_email,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email wajib diisi';
                          }
                          if (!value.contains('@') || !value.contains('.')) {
                            return 'Format email tidak valid';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Password Field
                      const Text(
                        'Kata Sandi',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: _inputDecoration(
                          hint: 'Minimal 8 karakter',
                          prefixIcon: Icons.lock_outline,
                          suffix: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              size: 20,
                              color: AppColors.onSurfaceVariant,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kata sandi wajib diisi';
                          }
                          if (value.length < 8) {
                            return 'Minimal 8 karakter';
                          }
                          return null;
                        },
                      ),

                      // Register Only: Confirm Password
                      if (!isLogin) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Konfirmasi Kata Sandi',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.onSurfaceVariant),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          decoration: _inputDecoration(
                            hint: 'Ketik ulang kata sandi',
                            prefixIcon: Icons.lock_reset,
                            suffix: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                size: 20,
                                color: AppColors.onSurfaceVariant,
                              ),
                              onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                            ),
                          ),
                          validator: (value) {
                            if (!isLogin) {
                              if (value == null || value.isEmpty) {
                                return 'Konfirmasi kata sandi wajib diisi';
                              }
                              if (value != _passwordController.text) {
                                return 'Kata sandi tidak sama';
                              }
                            }
                            return null;
                          },
                        ),
                      ],

                      const SizedBox(height: 12),

                      // Login: Remember Me & Forgot Password
                      if (isLogin)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: Checkbox(
                                      value: _rememberMe,
                                      activeColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                      onChanged: (val) => setState(() => _rememberMe = val ?? false),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Flexible(
                                    child: Text(
                                      'Ingat saya',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _showNotice('Instruksi pemulihan telah dikirim ke email.'),
                              child: const Text(
                                'Lupa Kata Sandi?',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),

                      // Register: Terms & Privacy Agreement
                      if (!isLogin)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 22,
                              height: 22,
                              child: Checkbox(
                                value: _agreeTerms,
                                activeColor: AppColors.primary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                onChanged: (val) => setState(() => _agreeTerms = val ?? false),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Saya menyetujui Ketentuan Layanan dan Kebijakan Privasi FNotes.',
                                style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant, height: 1.35),
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 20),

                      // Primary CTA Button
                      Container(
                        width: double.infinity,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: const LinearGradient(
                            colors: [AppColors.primaryDark, AppColors.primary, AppColors.secondary],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        isLogin ? 'Masuk ke Akun' : 'Buat Akun Sekarang',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Social Auth Divider
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.outline)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      isLogin ? 'Atau masuk dengan' : 'Atau daftar dengan',
                      style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.outline)),
                ],
              ),

              const SizedBox(height: 16),

              // Social Auth Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _showNotice('Menghubungkan ke Google...'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: AppColors.outline),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: AppColors.surfaceWhite,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.g_mobiledata, size: 24, color: Colors.red),
                          SizedBox(width: 4),
                          Text('Google', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _showNotice('Menghubungkan ke Apple ID...'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: AppColors.outline),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: AppColors.surfaceWhite,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.apple, size: 20, color: AppColors.onSurface),
                          SizedBox(width: 6),
                          Text('Apple', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Terms & Privacy Note
              const Center(
                child: Text(
                  'Dengan melanjutkan, Anda menyetujui Ketentuan Layanan & Kebijakan Privasi FNotes.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, required IconData prefixIcon, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant),
      prefixIcon: Icon(prefixIcon, size: 20, color: AppColors.onSurfaceVariant),
      suffixIcon: suffix,
      filled: true,
      fillColor: AppColors.surfaceContainerLow,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }
}
