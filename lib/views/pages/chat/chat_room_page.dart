import 'package:flutter/material.dart';
import 'package:ongi_front/core/app_colors.dart';
import 'package:ongi_front/core/app_spacing.dart';
import 'package:ongi_front/core/app_text_styles.dart';
import 'package:ongi_front/models/entities/chat_message_model.dart';
import 'package:ongi_front/models/mock/mock_chat_messages.dart';
import 'package:ongi_front/views/widgets/chat/chat_bubble.dart';
import 'package:ongi_front/views/widgets/chat/chat_welcome_card.dart';
import 'package:ongi_front/views/widgets/chat/schedule_proposal_card.dart';
import 'package:ongi_front/views/widgets/chat/date_divider.dart';
import 'package:ongi_front/views/widgets/chat/system_message.dart';
import 'package:ongi_front/utils/app_logger.dart';
import 'package:intl/intl.dart';

/// 채팅방 페이지
class ChatRoomPage extends StatefulWidget {
  final int clubId;
  final String clubName;

  const ChatRoomPage({
    super.key,
    required this.clubId,
    required this.clubName,
  });

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late List<ChatMessage> _messages;

  @override
  void initState() {
    super.initState();
    _messages = MockChatMessages.weekendRunningCrewChat;
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        id: _messages.length + 1,
        senderId: MockChatMessages.currentUserId,
        senderName: '달리는 사자',
        content: text,
        sentAt: DateTime.now(),
        isMe: true,
        type: MessageType.text,
      ));
    });

    _messageController.clear();

    // 스크롤 최하단으로
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  /// 앱바
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        widget.clubName,
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.menu, color: AppColors.textPrimary),
          onPressed: () {
            // TODO: 메뉴 표시
          },
        ),
      ],
    );
  }

  /// 메시지 리스트
  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      itemCount: _messages.length + 1, // +1 for date divider
      itemBuilder: (context, index) {
        if (index == 0) {
          // 날짜 구분선 (로케일 에러 방지용 try-catch)
          String formattedDate;
          try {
            final dateFormat = DateFormat('yyyy년 M월 d일', 'ko_KR');
            formattedDate = dateFormat.format(_messages.first.sentAt);
            AppLogger.debug('[ChatRoomPage] 날짜 포맷 성공: $formattedDate');
          } catch (e) {
            AppLogger.error('[ChatRoomPage] 날짜 포맷 에러: $e');
            final dt = _messages.first.sentAt;
            formattedDate = '${dt.year}년 ${dt.month}월 ${dt.day}일';
          }
          return DateDivider(date: formattedDate);
        }

        final message = _messages[index - 1];
        return _buildMessageItem(message);
      },
    );
  }

  /// 메시지 아이템 빌더
  Widget _buildMessageItem(ChatMessage message) {
    switch (message.type) {
      case MessageType.system:
        return SystemMessage(message: message.content);

      case MessageType.welcome:
        return ChatWelcomeCard(
          title: widget.clubName,
          subtitle: '가입을 환영합니다!',
          description: '모임을 시작하기 전,\n첫 가이드를 꼭 읽어보세요 :)',
          onGuidePressed: () {
            // TODO: 가이드 표시
          },
        );

      case MessageType.schedule:
        if (message.scheduleData == null) {
          return const SizedBox.shrink();
        }
        return ScheduleProposalCard(
          schedule: message.scheduleData!,
          senderName: message.senderName,
          sentAt: message.sentAt,
          onAttendPressed: () {
            // TODO: 참석 처리
          },
          onAbsentPressed: () {
            // TODO: 불참 처리
          },
        );

      case MessageType.text:
        return ChatBubble(
          message: message,
        );
    }
  }

  /// 입력 영역
  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.sm,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 추가 버튼
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.textTertiary),
            onPressed: () {
              // TODO: 첨부파일/이미지 추가
            },
          ),

          // 입력 필드
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: '메시지를 입력하세요',
                  hintStyle: AppTextStyles.body.copyWith(
                    color: AppColors.textDisabled,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.sm,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),

          const SizedBox(width: AppSpacing.xs),

          // 전송 버튼
          IconButton(
            icon: const Icon(Icons.send, color: AppColors.primary),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
