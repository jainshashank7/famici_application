part of 'mood_tracker_bloc.dart';

class MoodTrackerState extends Equatable {
  final List<EmojiWithTitle> emojiList;
  final EmojiWithTitle emoticon;
  final List<String> tags;
  final String notes;
  final Map<String, List<String>> categoryWiseTags;

  const MoodTrackerState({
    required this.emojiList,
    required this.emoticon,
    required this.tags,
    required this.notes,
    required this.categoryWiseTags,
  });

  factory MoodTrackerState.initial() => MoodTrackerState(
        emojiList: [
          EmojiWithTitle(
              emoji: AnimatedEmojis.blush, title: "Aww", category: "pleasant"),
          EmojiWithTitle(
              emoji: AnimatedEmojis.joy, title: "Happy", category: "pleasant"),
          EmojiWithTitle(
              emoji: AnimatedEmojis.winkyTongue,
              title: "Cool",
              category: "pleasant"),
          EmojiWithTitle(
              emoji: AnimatedEmojis.anxiousWithSweat,
              title: "Stressed",
              category: "negative"),
          EmojiWithTitle(
              emoji: AnimatedEmojis.woozy,
              title: "Confused",
              category: "neutral"),
          EmojiWithTitle(
              emoji: AnimatedEmojis.starStruck,
              title: "Excited",
              category: "pleasant"),
          EmojiWithTitle(
              emoji: AnimatedEmojis.sad, title: "Sad", category: "negative"),
          EmojiWithTitle(
              emoji: AnimatedEmojis.hugFace,
              title: "Amazed",
              category: "pleasant"),
          EmojiWithTitle(
              emoji: AnimatedEmojis.slightlyHappy,
              title: "Peaceful",
              category: "pleasant"),
          EmojiWithTitle(
              emoji: AnimatedEmojis.grinSweat,
              title: "Surprised",
              category: "pleasant"),
          EmojiWithTitle(
              emoji: AnimatedEmojis.rage, title: "Angry", category: "negative"),
          EmojiWithTitle(
              emoji: AnimatedEmojis.plusSign,
              title: "More",
              category: "negative"),
          EmojiWithTitle(
              emoji: AnimatedEmojis.worried,
              title: "Worried",
              category: "negative"),
          EmojiWithTitle(
              emoji: AnimatedEmojis.distraught,
              title: "Distraught",
              category: "negative"),
          EmojiWithTitle(
              emoji: AnimatedEmojis.yawn, title: "Yawn", category: "neutral"),
          EmojiWithTitle(
              emoji: AnimatedEmojis.unamused,
              title: "Unamused",
              category: "neutral"),
          EmojiWithTitle(
              emoji: AnimatedEmojis.neutralFace,
              title: "Neutral",
              category: "neutral"),
          EmojiWithTitle(
              emoji: AnimatedEmojis.grimacing,
              title: "Grimacing",
              category: "neutral"),
          EmojiWithTitle(
              emoji: AnimatedEmojis.rollingEyes,
              title: "Rolling Eye",
              category: "neutral"),
        ],
        emoticon: EmojiWithTitle(emoji: null, title: '', category: ''),
        tags: [],
        notes: '',
        categoryWiseTags: {
          "pleasant": [
            "Work",
            "Hobbies",
            "Family",
            "Love",
            "Weather",
            "Wife",
            "Party",
            "Social Life",
            "Self Esteem",
            "Sleep",
            "Food"
          ],
          "neutral": [
            "Work",
            "Hobbies",
            "Family",
            "Friends",
            "Love",
            "Weather",
            "Wife",
            "Party",
            "Social Life",
            "Self Esteem",
            "Sleep",
            "Food"
          ],
          "negative": [
            "Work",
            "Hobbies",
            "Family",
            "Friends",
            "Relationships",
            "Marriage",
            "Finance",
            "Weather",
            "Social Life",
            "Self Esteem",
            "Sleep",
            "Food"
          ],
        },
      );

  MoodTrackerState copyWith(
          {List<EmojiWithTitle>? emojiList,
          EmojiWithTitle? emoticon,
          List<String>? tags,
          String? notes,
          Map<String, List<String>>? categoryWiseTags}) =>
      MoodTrackerState(
        emojiList: emojiList ?? this.emojiList,
        emoticon: emoticon ?? this.emoticon,
        tags: tags ?? this.tags,
        notes: notes ?? this.notes,
        categoryWiseTags: categoryWiseTags ?? this.categoryWiseTags,
      );

  @override
  List<Object> get props => [
        emojiList,
        emoticon,
        tags,
        notes,
      ];
}
