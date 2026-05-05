import 'package:flutter/material.dart';
import 'package:hesteka_frontend/core/localization/app_localizations.dart';
import '../../domain/faq_model.dart';

class FAQDataProvider {
  static List<FAQSection> getLocalizedFaqData(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isFr = Localizations.localeOf(context).languageCode == 'fr';

    return [
      FAQSection(
        category: 'INITIAL',
        title: '',
        image: '',
        questions: [
          FAQItem(
            question: isFr
                ? 'Puis-je modifier mon signalement ?'
                : 'Can I edit my report?',
            answer: isFr
                ? 'Oui, tu peux le modifier à tout moment depuis ton compte.'
                : 'Yes, you can edit it anytime from your account.',
          ),
          FAQItem(
            question: isFr
                ? 'Puis-je supprimer mon annonce ?'
                : 'Can I delete my listing?',
            answer: isFr
                ? 'Oui, dès que l\'animal est retrouvé ou si tu le souhaites.'
                : 'Yes, once the animal is found or whenever you want.',
          ),
          FAQItem(
            question: isFr
                ? 'Est-ce que mon signalement est visible partout ?'
                : 'Is my report visible everywhere?',
            answer: isFr
                ? 'Il est prioritairement diffusé aux utilisateurs proches de la zone indiquée.'
                : 'It is mainly shown to users near the indicated area.',
          ),
          FAQItem(
            question: isFr
                ? 'Puis-je signaler pour quelqu\'un d\'autre ?'
                : 'Can I report for someone else?',
            answer: isFr
                ? 'Oui, tant que les informations sont fiables et vérifiées.'
                : 'Yes, as long as the information is reliable and verified.',
          ),
          FAQItem(
            question: isFr
                ? 'Mon signalement est-il vérifié ?'
                : 'Is my report verified?',
            answer: isFr
                ? 'Une modération peut être effectuée pour garantir la fiabilité des informations.'
                : 'Moderation may be carried out to ensure the reliability of the information.',
          ),
          FAQItem(
            question: isFr
                ? 'Comment indiquer que l\'animal a été retrouvé ?'
                : 'How do I indicate that the animal has been found?',
            answer: isFr
                ? 'Tu peux clôturer ton signalement en un clic depuis ton annonce.'
                : 'You can close your report with one click from your listing.',
          ),
        ],
      ),
      FAQSection(
        category: 'LOCAL MISSIONS',
        title: l10n.categoryMissions,
        image: 'assets/images/faq_image_2.png',
        questions: [
          FAQItem(
            question: isFr
                ? 'Comment trouver une mission près de chez moi ?'
                : 'How can I find a mission near me?',
            answer: isFr
                ? 'L\'application te propose automatiquement des missions selon ta localisation.'
                : 'The app automatically suggests missions based on your location.',
          ),
          FAQItem(
            question: isFr
                ? 'Comment participer à une mission ?'
                : 'How can I participate in a mission?',
            answer: isFr
                ? 'Il suffit de t\'inscrire directement depuis la fiche mission.'
                : 'You just need to register directly from the mission details page.',
          ),
          FAQItem(
            question: isFr
                ? 'Les missions sont-elles gratuites ?'
                : 'Are the missions free?',
            answer: isFr
                ? 'Oui, elles reposent sur l\'entraide et le bénévolat, mais te rapporteront des points.'
                : 'Yes, they are based on mutual help and volunteering, but they will earn you points.',
          ),
          FAQItem(
            question: isFr
                ? 'Faut-il une expérience particulière ?'
                : 'Do I need any special experience?',
            answer: isFr
                ? 'Non, la plupart des missions sont accessibles à tous.'
                : 'No, most missions are accessible to everyone.',
          ),
          FAQItem(
            question: isFr
                ? 'Comment savoir si une mission est confirmée ?'
                : 'How do I know if a mission is confirmed?',
            answer: isFr
                ? 'Tu reçois une notification dès validation.'
                : 'You receive a notification once it is validated.',
          ),
          FAQItem(
            question: isFr
                ? 'Puis-je annuler ma participation ?'
                : 'Can I cancel my participation?',
            answer: isFr
                ? 'Oui, 24H avant le début de la mission. Préviens directement l\'association par téléphone.'
                : 'Yes, 24 hours before the mission starts. Notify the association directly by phone.',
          ),
        ],
      ),
      FAQSection(
        category: 'MY ACCOUNT',
        title: l10n.categoryAccount,
        image: 'assets/images/faq_image_3.png',
        questions: [
          FAQItem(
            question: isFr
                ? 'Puis-je modifier mes informations ?'
                : 'Can I edit my information?',
            answer: isFr
                ? 'Oui, à tout moment dans les paramètres.'
                : 'Yes, anytime in the settings.',
          ),
          FAQItem(
            question: isFr
                ? 'Mes données sont-elles protégées ?'
                : 'Is my data protected?',
            answer: isFr
                ? 'Oui, elles sont sécurisées et non partagées sans ton consentement.'
                : 'Yes, it is secured and not shared without your consent.',
          ),
          FAQItem(
            question: isFr
                ? 'Puis-je me connecter sur plusieurs appareils ?'
                : 'Can I log in on multiple devices?',
            answer: isFr
                ? 'Oui, sans aucun problème.'
                : 'Yes, without any problem.',
          ),
        ],
      ),
      FAQSection(
        category: 'MESSAGING',
        title: l10n.categoryMessaging,
        image: 'assets/images/faq_image_4.png',
        questions: [
          FAQItem(
            question: isFr
                ? 'Puis-je bloquer un utilisateur ?'
                : 'Can I block a user?',
            answer: isFr
                ? 'Oui, en cas de besoin. Tu peux signaler un utilisateur ou même le bloquer.'
                : 'Yes, if needed. You can report a user or even block them.',
          ),
          FAQItem(
            question: isFr
                ? 'Comment démarrer une conversation ?'
                : 'How do I start a conversation?',
            answer: isFr
                ? 'Depuis un profil ou une annonce.'
                : 'From a profile or a listing.',
          ),
        ],
      ),
      FAQSection(
        category: 'DONATIONS AND HELP',
        title: l10n.categoryDonations,
        image: 'assets/images/faq_image_5.png',
        questions: [
          FAQItem(
            question: isFr
                ? 'À qui vont les dons ?'
                : 'Who do the donations go to?',
            answer: isFr
                ? 'Une partie est pour soutenir l\'application mais aussi aux refuges/associations.'
                : 'Part of it supports the app, and also shelters/associations.',
          ),
          FAQItem(
            question: isFr
                ? 'Les dons sont-ils sécurisés ?'
                : 'Are donations secure?',
            answer: isFr
                ? 'Oui, via des systèmes de paiement sécurisés.'
                : 'Yes, through secure payment systems.',
          ),
          FAQItem(
            question: isFr
                ? 'Puis-je aider autrement ?'
                : 'Can I help in another way?',
            answer: isFr
                ? 'Oui, en participant à des missions ou en partageant via des points de collecte.'
                : 'Yes, by participating in missions or by sharing through collection points.',
          ),
        ],
      ),
      FAQSection(
        category: 'SECURITY',
        title: l10n.categorySecurity,
        image: 'assets/images/faq_image_6.png',
        questions: [
          FAQItem(
            question: isFr
                ? 'L\'application vérifie-t-elle les contenus ?'
                : 'Does the app verify content?',
            answer: isFr
                ? 'Une modération est en place.'
                : 'Moderation is in place.',
          ),
          FAQItem(
            question: isFr
                ? 'Que faire en cas de problème ?'
                : 'What should I do in case of a problem?',
            answer: isFr
                ? 'Contacte le support via l\'application.'
                : 'Contact support through the app.',
          ),
          FAQItem(
            question: isFr
                ? 'Comment éviter les arnaques ?'
                : 'How can I avoid scams?',
            answer: isFr
                ? 'Ne partage pas d\'informations sensibles et utilise la messagerie interne.'
                : 'Do not share sensitive information and use the internal messaging system.',
          ),
          FAQItem(
            question: isFr
                ? 'L\'application partage-t-elle mes données ?'
                : 'Does the app share my data?',
            answer: isFr
                ? 'Non, pas sans ton consentement.'
                : 'No, not without your consent.',
          ),
        ],
      ),
    ];
  }
}
