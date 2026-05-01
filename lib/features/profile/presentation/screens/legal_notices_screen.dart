import 'package:flutter/material.dart';

import 'package:hesteka_frontend/features/partner/presentation/widgets/partner_ui_kit.dart';

class LegalNoticesScreen extends StatelessWidget {
  const LegalNoticesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PartnerScreenScaffold(
      header: const PartnerHeroHeader(
        title: 'LEGAL NOTICES',
        imageUrl: 'assets/images/profile/LegalNotice.png',
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 20, 28, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'LEGAL NOTICES - HESTEKA',
              style: TextStyle(
                color: PartnerUiColors.brand,
                fontFamily: 'EricaOne',
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            _buildSection(
              'APPLICATION EDITOR',
              'The Hesteka application is published by: Hesteka SAS. Address: 58 rue Denise Vernay, Pélissanne, 13330. SIRET: 123 456 789 00001. Email: contact@hesteka.com. Telephone: +33 6 41 45 83 60.\n\n'
                  'The director of the publication is Emma Fauveau, as legal representative of Hesteka SAS.',
            ),
            _buildSection(
              'HOSTING OF THE APPLICATION',
              'The Hesteka application is hosted by: OVH Cloud. Address: 2 rue Kellermann, 59100 Roubaix, France. Website: www.ovh.com. Telephone: +33 9 72 10 10 07.\n\n'
                  'The host ensures secure storage of all data collected by the application.',
            ),
            _buildSection(
              'INTELLECTUAL PROPERTY',
              'All content present in the Hesteka application (texts, images, logos, icons, design, videos) are the exclusive property of Hesteka SAS, unless otherwise stated.\n\n'
                  'Any reproduction, representation, modification, distribution or use, partial or total, of the contents of the application without prior written authorization is strictly prohibited and constitutes an infringement punishable by law.',
            ),
            _buildSection(
              'PERSONAL DATA',
              'We comply with the provisions of the General Data Protection Regulation (GDPR) and guarantee that your information is processed securely and transparently. Certain data may be used by our partners only for the proper functioning of the application and to improve the services offered.',
            ),
            _buildSection(
              'RESPONSIBILITY',
              'Hesteka strives to ensure that the information available in the application is accurate and up to date. However, Hesteka cannot be held responsible for errors, omissions or results related to the use of the application or the information presented there.\n\n'
                  'The user is responsible for the use he makes of the application and its contents. Access to certain services may be subject to specific conditions specified within the application.',
            ),
            _buildSection(
              'EXTERNAL LINKS',
              'The application may contain links to third-party sites or services. Hesteka has no control over these sites and assumes no responsibility for their content or the practices of their operators.\n\n'
                  'We recommend consulting the conditions and privacy policies of these sites before any interaction.',
            ),
            _buildSection(
              'APPLICABLE LAW',
              'These legal notices are governed by French law. Any dispute relating to the use of the Hesteka application falls under the jurisdiction of the French courts.',
            ),
            _buildSection(
              'CONTACT',
              'For any questions regarding these legal notices or the application, you can contact us at:',
            ),
            const Text(
              'Email: contact@hesteka.com\nTelephone: +33 6 41 45 83 60',
              style: TextStyle(
                color: PartnerUiColors.brand,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: PartnerUiColors.brand,
              fontFamily: 'EricaOne',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              color: PartnerUiColors.brand,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
