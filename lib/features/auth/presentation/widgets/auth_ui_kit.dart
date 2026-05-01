import 'package:flutter/material.dart';

class AuthUiColors {
  const AuthUiColors._();

  static const Color brand = Color(0xFFB84C24);
  static const Color brandSoft = Color(0xFFCC5D34);
  static const Color cream = Color(0xFFEFE8D5);
  static const Color hint = Color(0xFFF8DFCB);
}

class AuthMainTitle extends StatelessWidget {
  const AuthMainTitle(this.text, {this.center = true, super.key});

  final String text;
  final bool center;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: center ? TextAlign.center : TextAlign.start,
      style: const TextStyle(
        color: AuthUiColors.brand,
        fontFamily: 'EricaOne',
        fontSize: 28,
        height: 1.03,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class AuthFieldLabel extends StatelessWidget {
  const AuthFieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AuthUiColors.brand,
        fontSize: 17,
        fontFamily: 'EricaOne',
      ),
    );
  }
}

class AuthPillTextField extends StatelessWidget {
  const AuthPillTextField({
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.suffix,
    super.key,
    required bool readOnly,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    final textField = TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      validator: validator,
      decoration:
          const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            errorStyle: TextStyle(height: 0),
          ).copyWith(
            hintText: hintText,
            hintStyle: const TextStyle(color: AuthUiColors.hint, fontSize: 14),
          ),
    );

    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: AuthUiColors.brand,
        borderRadius: BorderRadius.circular(22),
      ),
      child: suffix == null
          ? textField
          : Row(
              children: [
                Expanded(child: textField),
                suffix!,
              ],
            ),
    );
  }
}

class AuthPasswordVisibilityToggle extends StatelessWidget {
  const AuthPasswordVisibilityToggle({
    required this.obscureText,
    required this.onPressed,
    super.key,
  });

  final bool obscureText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 1, height: 26, color: Colors.white),
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: Colors.white,
            size: 19,
          ),
        ),
      ],
    );
  }
}

class AuthOutlinePillButton extends StatelessWidget {
  const AuthOutlinePillButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.width = 220,
    this.height = 40,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: AuthUiColors.cream,
          foregroundColor: AuthUiColors.brandSoft,
          side: const BorderSide(color: AuthUiColors.brandSoft, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          textStyle: const TextStyle(fontFamily: 'EricaOne', fontSize: 17),
        ),
        onPressed: onPressed,
        child: isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(label),
      ),
    );
  }
}

class AuthFilledPillButton extends StatelessWidget {
  const AuthFilledPillButton({
    required this.label,
    required this.onPressed,
    this.width = 238,
    this.height = 40,
    super.key,
    required bool isLoading,
  });

  final String label;
  final VoidCallback? onPressed;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AuthUiColors.brand,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          textStyle: const TextStyle(fontFamily: 'EricaOne', fontSize: 15),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}

class AuthSocialPillButton extends StatelessWidget {
  const AuthSocialPillButton({
    required this.label,
    required this.leading,
    required this.onPressed,
    super.key,
  });

  final String label;
  final Widget leading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AuthUiColors.brand,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leading,
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(fontFamily: 'EricaOne', fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthGoogleGlyph extends StatelessWidget {
  const AuthGoogleGlyph({super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: [
            Color(0xFF4285F4),
            Color(0xFFEA4335),
            Color(0xFFFBBC05),
            Color(0xFF34A853),
          ],
        ).createShader(bounds);
      },
      child: const Text(
        'G',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }
}

class AuthOrDivider extends StatelessWidget {
  const AuthOrDivider({this.label = 'Or', super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFCC744F), thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            label,
            style: const TextStyle(
              color: AuthUiColors.brand,
              fontFamily: 'EricaOne',
              fontSize: 18,
            ),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFCC744F), thickness: 1)),
      ],
    );
  }
}
