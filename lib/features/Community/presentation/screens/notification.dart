import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hesteka_frontend/core/theme/app_text_styles.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../data/models/notification_model.dart';
import '../providers/notification_providers.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const brandPrimary = Color(0xFFBA4A22);
    const bgColor = Color(0xFFFBF4E9);
    final notificationsAsync = ref.watch(notificationsProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          const SizedBox(height: 60),
          AppTopBar(title: l10n.notifications),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () =>
                  ref.read(notificationsProvider.notifier).fetchNotifications(),
              color: brandPrimary,
              child: notificationsAsync.when(
                data: (notifications) {
                  if (notifications.isEmpty) {
                    return _buildEmptyState(brandPrimary, l10n);
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return _buildNotificationItem(
                        context,
                        ref,
                        notifications[index],
                        brandPrimary,
                        l10n,
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: brandPrimary),
                ),
                error: (err, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: brandPrimary,
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.failedToLoadNotifications,
                        style: AppTextStyles.body.copyWith(
                          color: brandPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () => ref.refresh(notificationsProvider),
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(Color brandPrimary, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            color: brandPrimary.withValues(alpha: 0.3),
            size: 80,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noNotificationsYet,
            style: AppTextStyles.body.copyWith(
              color: Colors.grey,
              fontSize: 18,
              // fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    WidgetRef ref,
    NotificationModel notification,
    Color brandPrimary,
    AppLocalizations l10n,
  ) {
    final time = _formatTimeAgo(notification.createdAt, l10n);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        ref
            .read(notificationActionProvider.notifier)
            .deleteNotification(notification.id);
      },
      child: GestureDetector(
        onTap: () {
          if (!notification.isRead) {
            ref
                .read(notificationActionProvider.notifier)
                .markAsRead(notification.id);
          }
          // Optional: handle deep links from notification.data
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: notification.isRead ? Colors.white : Colors.orange.shade50,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: notification.isRead
                ? null
                : Border.all(
                    color: brandPrimary.withValues(alpha: 0.2),
                    width: 1,
                  ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _getNotificationColor(
                    notification.type,
                  ).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getNotificationIcon(notification.type),
                  color: _getNotificationColor(notification.type),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: AppTextStyles.body.copyWith(
                              fontWeight: notification.isRead
                                  ? FontWeight.w600
                                  : FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Text(
                          time,
                          style: AppTextStyles.body.copyWith(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _getNotificationBody(notification),
                      style: AppTextStyles.body.copyWith(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              if (!notification.isRead)
                Container(
                  margin: const EdgeInsets.only(left: 8, top: 4),
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Returns a proper French body text for each notification type.
  /// Falls back to the server-provided description if it is not empty.
  String _getNotificationBody(NotificationModel notification) {
    // If the server already sent a meaningful description, use it.
    if (notification.description.isNotEmpty) {
      return notification.description;
    }

    // Fallback French body per type
    switch (notification.type) {
      case 'new_report':
        return 'Un nouveau signalement d\'animal a été créé près de chez vous. Consultez-le pour aider !';
      case 'new_mission':
        return 'Une nouvelle mission locale est disponible à proximité. Inscrivez-vous pour participer !';
      case 'points_earned':
        return 'Félicitations ! Vous avez gagné des points sur votre compte Hesteka.';
      case 'mission_cancelled':
        return 'Une mission locale à laquelle vous étiez inscrit(e) a été annulée.';
      case 'chat_reply':
        return 'Vous avez reçu une nouvelle réponse dans la communauté.';
      case 'reward_update':
        return 'Le statut de votre échange de récompense a été mis à jour.';
      case 'new_payment':
        return 'Un nouveau paiement a été enregistré. Merci pour votre soutien !';
      case 'new_donation':
        return 'Votre preuve de soutien a été soumise avec succès.';
      case 'new_partner':
        return 'Un nouveau partenaire a rejoint la communauté Hesteka.';
      case 'account_update':
        return 'Votre compte a été mis à jour avec succès.';
      case 'system':
        return 'Vous avez une nouvelle notification du système Hesteka.';
      // Legacy types from old frontend
      case 'comment':
        return 'Quelqu\'un a commenté votre publication.';
      case 'like':
        return 'Quelqu\'un a aimé votre publication.';
      case 'story':
        return 'Une nouvelle story a été partagée dans la communauté.';
      default:
        return 'Vous avez une nouvelle notification.';
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'new_report':
        return Icons.pets_outlined;
      case 'new_mission':
        return Icons.assignment_outlined;
      case 'points_earned':
        return Icons.stars_outlined;
      case 'mission_cancelled':
        return Icons.event_busy_outlined;
      case 'chat_reply':
      case 'comment':
        return Icons.chat_bubble_outline;
      case 'reward_update':
        return Icons.card_giftcard_outlined;
      case 'new_payment':
        return Icons.payment_outlined;
      case 'new_donation':
        return Icons.volunteer_activism_outlined;
      case 'new_partner':
        return Icons.handshake_outlined;
      case 'account_update':
        return Icons.person_outline;
      case 'like':
        return Icons.favorite_border;
      case 'story':
        return Icons.auto_stories_outlined;
      case 'system':
        return Icons.info_outline;
      default:
        return Icons.notifications_none;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'new_report':
        return const Color(0xFFE65100); // deep orange
      case 'new_mission':
        return const Color(0xFF1565C0); // blue
      case 'points_earned':
        return const Color(0xFFF9A825); // amber
      case 'mission_cancelled':
        return const Color(0xFFC62828); // red
      case 'chat_reply':
      case 'comment':
        return const Color(0xFF1976D2); // blue
      case 'reward_update':
        return const Color(0xFF7B1FA2); // purple
      case 'new_payment':
        return const Color(0xFF00838F); // teal
      case 'new_donation':
        return const Color(0xFF2E7D32); // green
      case 'new_partner':
        return const Color(0xFF4527A0); // deep purple
      case 'account_update':
        return const Color(0xFF455A64); // blue-grey
      case 'like':
        return const Color(0xFFD81B60); // pink
      case 'story':
        return const Color(0xFFFF6F00); // amber dark
      case 'system':
        return const Color(0xFF546E7A); // blue-grey
      default:
        return const Color(0xFFBA4A22); // brand primary
    }
  }

  String _formatTimeAgo(DateTime dateTime, AppLocalizations l10n) {
    final duration = DateTime.now().difference(dateTime);
    if (duration.inDays > 0) {
      return l10n.text('daysAgo', params: {'days': '${duration.inDays}'});
    }
    if (duration.inHours > 0) {
      return l10n.text('hoursAgo', params: {'hours': '${duration.inHours}'});
    }
    if (duration.inMinutes > 0) {
      return l10n.text(
        'minutesAgo',
        params: {'minutes': '${duration.inMinutes}'},
      );
    }
    return l10n.justNow;
  }
}
