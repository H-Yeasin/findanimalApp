import 'package:flutter/material.dart';

import '../../../partner_ads/presentation/widgets/partner_ui_kit.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PartnerScreenScaffold(
      header: PartnerHeroHeader(
        title: 'PRIVACY POLICY',
        imageUrl:
            'assets/images/profile/PrivecyPolicy.png', // Cat peeking image
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 20, 28, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'We attach great importance to the protection of your personal data. When you use our application, certain information may be collected in order to enable it to function properly and improve your experience.\n\n'
              'We are committed to processing this data in a responsible, transparent and secure manner, in accordance with the laws in force, in particular the General Data Protection Regulation (GDPR) applicable in the European Union.',
              style: TextStyle(
                color: PartnerUiColors.brand,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 30),
            _buildSection(
              'DATA WE COLLECT',
              'When you use the application, we may collect certain personal information that you provide to us directly or that is necessary for the operation of the service. This may include your last name, first name, email address, telephone number, postal address, as well as information associated with your user account.\n\n'
                  'As part of donations made via the application, certain payment-related data may also be used to process the transaction securely. This information is generally processed by secure payment services.\n\n'
                  'Depending on the functionalities used, we may also collect certain location data in order to improve certain functionalities of the application, for example to display information or sections close to you.\n\n'
                  'Finally, certain technical data may be collected automatically, such as the type of device used, the version of the application or certain information related to the connection, in order to ensure the security and stability of the service.',
            ),
            _buildSection(
              'USE OF DATA',
              'The data collected is used to enable the operation of the application and to improve the services offered. This includes in particular to manage your account, process your requests and provide you with a personalized experience.',
            ),
            _buildSection(
              'SHARING DATA WITH PARTNERS',
              'Certain data may be shared with partners or technical service providers when this is necessary for the operation of the application or to improve the services offered. This may include, for example, payment services, hosting services, technical tools, logistics partners or analytics and maintenance services.\n\n'
                  'In some cases, these partners may process certain information in order to provide their services or improve the user experience. However, we ensure that we only work with partners who comply with applicable data protection regulations.\n\n'
                  'We do not sell your personal data and we ensure that their use remains regulated and secure.',
            ),
            _buildSection(
              'DATA RETENTION',
              'Personal data is kept only for the period necessary for the purposes for which it was collected. Certain information may be kept longer when required by law, particularly in the context of legal or accounting obligations related to financial transactions.',
            ),
            _buildSection(
              'DATA SECURITY',
              'We put in place technical and organizational measures to protect your personal data against unauthorized access, loss, modification or disclosure. This includes the use of secure connections and database protection systems.',
            ),
            _buildSection(
              'YOUR RIGHTS',
              'In accordance with the General Data Protection Regulation (GDPR) and applicable data protection laws, you have several rights regarding your personal information. You can in particular request access to your data, request their correction, request their deletion or object to certain processing.',
            ),
            _buildSection(
              'CONTACT',
              'For any questions regarding the management of your personal data or to exercise your rights, you can contact us at the following address:',
            ),
            const Text(
              'contact@hesteka.com',
              style: TextStyle(
                color: PartnerUiColors.brand,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
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
              fontFamily: 'Impact',
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
