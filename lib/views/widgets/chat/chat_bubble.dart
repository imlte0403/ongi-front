import 'package:flutter/material.dart';
import 'package:ongi_front/core/app_colors.dart';
import 'package:ongi_front/core/app_spacing.dart';
import 'package:ongi_front/core/app_text_styles.dart';
import 'package:ongi_front/models/entities/chat_message_model.dart';
import 'package:ongi_front/utils/app_logger.dart';
import 'package:intl/intl.dart';

/// 채팅 버블 위젯
class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({
    super.key,
    required this.message,
  });

  /// 시간 포맷 (로케일 에러 방지)
  String _formatTime(DateTime dateTime) {
    try {
      final timeFormat = DateFormat('a h:mm', 'ko_KR');
      return timeFormat.format(dateTime);
    } catch (e) {
      AppLogger.error('[ChatBubble] 시간 포맷 에러: $e');
      final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
      final amPm = dateTime.hour >= 12 ? '오후' : '오전';
      return '$amPm $hour:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (message.isMe) {
      return _buildMyMessage();
    } else {
      return _buildOtherMessage();
    }
  }

  /// 내 메시지 (오른쪽, 초록색)
  Widget _buildMyMessage() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 시간
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.xs),
            child: Text(
              _formatTime(message.sentAt),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textDisabled,
                fontSize: 11,
              ),
            ),
          ),
          // 메시지 버블
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 260),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomRight: const Radius.circular(4),
                ),
              ),
              child: Text(
                message.content,
                style: AppTextStyles.body.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 상대방 메시지 (왼쪽)
  Widget _buildOtherMessage() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 프로필 이미지
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.surface,
            backgroundImage: message.senderProfileUrl != null
                ? NetworkImage(message.senderProfileUrl!)
                : null,
            child: message.senderProfileUrl == null
                ? Icon(Icons.person, size: 20, color: AppColors.textTertiary)
                : null,
          ),
          const SizedBox(width: AppSpacing.xs),
          // 메시지 영역
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 닉네임
                Text(
                  message.senderName,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                // 메시지 + 시간
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 220),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16).copyWith(
                            topLeft: const Radius.circular(4),
                          ),
                        ),
                        child: Text(
                          message.content,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      _formatTime(message.sentAt),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textDisabled,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
