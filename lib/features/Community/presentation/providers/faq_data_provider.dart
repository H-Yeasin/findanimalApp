import 'package:flutter/material.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';

import '../../domain/faq_model.dart';

class FAQDataProvider {
  static List<FAQSection> getLocalizedFaqData(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return [
      FAQSection(
        category: 'INITIAL',
        title: '',
        image: '',
        questions: [
          FAQItem(
            question: l10n.text('faqReportEditQuestion'),
            answer: l10n.text('faqReportEditAnswer'),
          ),
          FAQItem(
            question: l10n.text('faqReportDeleteQuestion'),
            answer: l10n.text('faqReportDeleteAnswer'),
          ),
          FAQItem(
            question: l10n.text('faqReportVisibilityQuestion'),
            answer: l10n.text('faqReportVisibilityAnswer'),
          ),
          FAQItem(
            question: l10n.text('faqReportForSomeoneQuestion'),
            answer: l10n.text('faqReportForSomeoneAnswer'),
          ),
          FAQItem(
            question: l10n.text('faqReportVerifiedQuestion'),
            answer: l10n.text('faqReportVerifiedAnswer'),
          ),
          FAQItem(
            question: l10n.text('faqReportFoundQuestion'),
            answer: l10n.text('faqReportFoundAnswer'),
          ),
        ],
      ),
      FAQSection(
        category: 'LOCAL MISSIONS',
        title: l10n.categoryMissions,
        image: 'assets/images/faq_image_2.png',
        questions: [
          FAQItem(
            question: l10n.text('faqMissionFindQuestion'),
            answer: l10n.text('faqMissionFindAnswer'),
          ),
          FAQItem(
            question: l10n.text('faqMissionParticipateQuestion'),
            answer: l10n.text('faqMissionParticipateAnswer'),
          ),
          FAQItem(
            question: l10n.text('faqMissionFreeQuestion'),
            answer: l10n.text('faqMissionFreeAnswer'),
          ),
          FAQItem(
            question: l10n.text('faqMissionExperienceQuestion'),
            answer: l10n.text('faqMissionExperienceAnswer'),
          ),
          FAQItem(
            question: l10n.text('faqMissionConfirmedQuestion'),
            answer: l10n.text('faqMissionConfirmedAnswer'),
          ),
          FAQItem(
            question: l10n.text('faqMissionCancelQuestion'),
            answer: l10n.text('faqMissionCancelAnswer'),
          ),
        ],
      ),
      FAQSection(
        category: 'MY ACCOUNT',
        title: l10n.categoryAccount,
        image: 'assets/images/faq_image_3.png',
        questions: [
          FAQItem(
            question: l10n.text('faqAccountEditQuestion'),
            answer: l10n.text('faqAccountEditAnswer'),
          ),
          FAQItem(
            question: l10n.text('faqAccountDataQuestion'),
            answer: l10n.text('faqAccountDataAnswer'),
          ),
          FAQItem(
            question: l10n.text('faqAccountDevicesQuestion'),
            answer: l10n.text('faqAccountDevicesAnswer'),
          ),
        ],
      ),
      FAQSection(
        category: 'MESSAGING',
        title: l10n.categoryMessaging,
        image: 'assets/images/faq_image_4.png',
        questions: [
          FAQItem(
            question: l10n.text('faqMessagingBlockQuestion'),
            answer: l10n.text('faqMessagingBlockAnswer'),
          ),
          FAQItem(
            question: l10n.text('faqMessagingStartQuestion'),
            answer: l10n.text('faqMessagingStartAnswer'),
          ),
        ],
      ),
      FAQSection(
        category: 'DONATIONS AND HELP',
        title: l10n.categoryDonations,
        image: 'assets/images/faq_image_5.png',
        questions: [
          FAQItem(
            question: l10n.text('faqDonationsDestinationQuestion'),
            answer: l10n.text('faqDonationsDestinationAnswer'),
          ),
          FAQItem(
            question: l10n.text('faqDonationsSecureQuestion'),
            answer: l10n.text('faqDonationsSecureAnswer'),
          ),
          FAQItem(
            question: l10n.text('faqDonationsOtherHelpQuestion'),
            answer: l10n.text('faqDonationsOtherHelpAnswer'),
          ),
        ],
      ),
      FAQSection(
        category: 'SECURITY',
        title: l10n.categorySecurity,
        image: 'assets/images/faq_image_6.png',
        questions: [
          FAQItem(
            question: l10n.text('faqSecurityContentQuestion'),
            answer: l10n.text('faqSecurityContentAnswer'),
          ),
          FAQItem(
            question: l10n.text('faqSecurityProblemQuestion'),
            answer: l10n.text('faqSecurityProblemAnswer'),
          ),
          FAQItem(
            question: l10n.text('faqSecurityScamsQuestion'),
            answer: l10n.text('faqSecurityScamsAnswer'),
          ),
          FAQItem(
            question: l10n.text('faqSecurityDataQuestion'),
            answer: l10n.text('faqSecurityDataAnswer'),
          ),
        ],
      ),
    ];
  }
}
