import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rep_visit/base/constants/app_colors.dart';
import 'package:rep_visit/base/constants/dimensions.dart';
import 'package:rep_visit/base/ui/widgets/text_widget.dart';
import 'package:rep_visit/screens/profile_screen/ui/widgets/web_view_screen.dart';

/// Legal & support links required for store compliance
/// (Privacy Policy, Terms & Conditions, and a contact/data-deletion path).
/// Pages open in an in-app WebView.
class LegalLinksWidget extends StatelessWidget {
  const LegalLinksWidget({super.key});

  static const String _privacyPolicyUrl =
      "https://www.repvisit.com/privacy.html";
  static const String _termsUrl = "https://www.repvisit.com/terms.html";
  static const String _contactUrl = "https://www.repvisit.com/contact.html";

  void _openPage(BuildContext context, String title, String url) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WebViewScreen(title: title, url: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.fullWidth(context),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.grey300),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Icon(
                      Icons.shield_outlined,
                      color: AppColors.grey500,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                TextWidget(
                  "Legal & Support".tr(),
                  textSize: 16,
                  fontWeight: FontWeight.w700,
                  textColor: AppColors.fontColor,
                )
              ],
            ),
            const SizedBox(height: 12),
            _LinkRow(
              icon: Icons.privacy_tip_outlined,
              label: "Privacy Policy".tr(),
              onTap: () => _openPage(
                context,
                "Privacy Policy".tr(),
                _privacyPolicyUrl,
              ),
            ),
            Divider(color: AppColors.grey200),
            _LinkRow(
              icon: Icons.description_outlined,
              label: "Terms & Conditions".tr(),
              onTap: () => _openPage(
                context,
                "Terms & Conditions".tr(),
                _termsUrl,
              ),
            ),
            Divider(color: AppColors.grey200),
            _LinkRow(
              icon: Icons.delete_outline,
              label: "Request Data Deletion".tr(),
              onTap: () => _openPage(
                context,
                "Request Data Deletion".tr(),
                _contactUrl,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _LinkRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, color: AppColors.grey500, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: TextWidget(
                label,
                textSize: 14,
                fontWeight: FontWeight.w500,
                textColor: AppColors.typography500,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.grey500,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
