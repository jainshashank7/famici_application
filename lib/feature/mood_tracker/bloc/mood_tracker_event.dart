part of 'mood_tracker_bloc.dart';

abstract class MoodTrackerEvent {}

class CreateMoodTrackerRecord extends MoodTrackerEvent {

  final List<String> tags;
  final String notes;

  CreateMoodTrackerRecord({
    required this.tags,
    required this.notes,
  });
}

class UpdateEmoticon extends MoodTrackerEvent {
  final EmojiWithTitle emoticon;

  UpdateEmoticon({
    required this.emoticon,
  });

}

class ChangeEmoji extends MoodTrackerEvent {
  final AnimatedEmojiData emoji;
  final String title;

  ChangeEmoji({required this.emoji, required this.title});
}


