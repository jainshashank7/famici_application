part of 'single_user_chat_bloc.dart';

enum RecordingStatus {
  initial,
  loading,
  recording,
  done,
}

class SingleUserChatState extends Equatable {
  const SingleUserChatState({
    required this.recordingStatus,
    required this.recorder,
    required this.recordedFile,
    required this.text,
    required this.messages,
    required this.contact,
    required this.conversation,
    required this.userChatStatus,
    required this.messagesStatus,
    required this.currentChatUser,
  });

  factory SingleUserChatState.initial() {
    return SingleUserChatState(
      recordingStatus: RecordingStatus.initial,
      recorder: FlutterSoundRecorder(),
      recordedFile: '',
      text: '',
      messages: [],
      contact: User(),
      conversation: Conversation(),
      userChatStatus: UserChatStatus.initial,
      messagesStatus: Status.initial,
      currentChatUser: "",
    );
  }

  final RecordingStatus recordingStatus;
  final FlutterSoundRecorder recorder;
  final String recordedFile;
  final String text;
  final List<Message> messages;
  final User contact;
  final Conversation conversation;
  final UserChatStatus userChatStatus;
  final Status messagesStatus;
  final String currentChatUser;

  SingleUserChatState copyWith({
    RecordingStatus? recordingStatus,
    FlutterSoundRecorder? recorder,
    String? recordedFile,
    String? text,
    List<Message>? messages,
    User? contact,
    Conversation? conversation,
    UserChatStatus? userChatStatus,
    Status? messagesStatus,
    String? currentChatUser
  }) {
    return SingleUserChatState(
      recordingStatus: recordingStatus ?? this.recordingStatus,
      recorder: recorder ?? this.recorder,
      recordedFile: recordedFile ?? this.recordedFile,
      text: text ?? this.text,
      messages: messages ?? this.messages,
      contact: contact ?? this.contact,
      conversation: conversation ?? this.conversation,
      userChatStatus: userChatStatus ?? this.userChatStatus,
      messagesStatus: messagesStatus ?? this.messagesStatus,
      currentChatUser: currentChatUser ?? this.currentChatUser,
    );
  }

  bool get hasFetchedAll => messagesStatus == Status.completed;

  bool get isFetching => messagesStatus == Status.loading;

  @override
  List<Object?> get props => [
        recordingStatus.name,
        recorder.toString(),
        recordedFile,
        text,
        messages.map((e) => e.toJson()).toList(),
        contact,
        conversation,
       currentChatUser,
      ];

  bool get isRecoreded => recordingStatus == RecordingStatus.done;
  bool get isRecording => recordingStatus == RecordingStatus.recording;
  bool get isSessionFailed => userChatStatus == UserChatStatus.failed;
  bool get hasSession => userChatStatus == UserChatStatus.ongoing;
}

enum UserChatStatus {
  initial,
  loading,
  ongoing,
  failed,
}
