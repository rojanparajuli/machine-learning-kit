import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_smart_reply/google_mlkit_smart_reply.dart';
import 'package:ml_kit_test/bloc/smartreply/smart_reply_state.dart';

class SmartReplyCubit extends Cubit<SmartReplyState> {
  final SmartReply smartReply = SmartReply();

  SmartReplyCubit() : super(const SmartReplyState());

  void addMessage(String message) async {
    smartReply.addMessageToConversationFromRemoteUser(
      message,
      DateTime.now().millisecondsSinceEpoch,
      'remoteUserId',
    );
    final response = await smartReply.suggestReplies();
    emit(SmartReplyState(result: response.suggestions.join('\n')));
  }

  @override
  Future<void> close() {
    smartReply.close();
    return super.close();
  }
}