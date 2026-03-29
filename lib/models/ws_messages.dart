import 'package:flutter/foundation.dart';

// ── Envelope ──────────────────────────────────────────────

@immutable
class WsEnvelope {
  const WsEnvelope({required this.type, required this.payload});

  final String type;
  final Map<String, dynamic> payload;

  factory WsEnvelope.fromJson(Map<String, dynamic> json) => WsEnvelope(
        type: json['type'] as String,
        payload: json['payload'] as Map<String, dynamic>,
      );

  Map<String, dynamic> toJson() => {'type': type, 'payload': payload};
}

// ── Client → Server ──────────────────────────────────────

@immutable
class ChallengeMsg {
  static const type = 'challenge';
  const ChallengeMsg({required this.opponentId, required this.categoryId});
  final String opponentId;
  final String categoryId;

  Map<String, dynamic> toJson() => {
        'type': type,
        'payload': {'opponent_id': opponentId, 'category_id': categoryId},
      };
}

@immutable
class ChallengeResponseMsg {
  static const type = 'challenge_resp';
  const ChallengeResponseMsg({
    required this.matchId,
    required this.challengerId,
    required this.categoryId,
    required this.accepted,
  });
  final String matchId;
  final String challengerId;
  final String categoryId;
  final bool accepted;

  Map<String, dynamic> toJson() => {
        'type': type,
        'payload': {
          'match_id': matchId,
          'challenger_id': challengerId,
          'category_id': categoryId,
          'accepted': accepted,
        },
      };
}

@immutable
class AnswerMsg {
  static const type = 'answer';
  const AnswerMsg({required this.round, required this.choice});
  final int round;
  final int choice;

  Map<String, dynamic> toJson() => {
        'type': type,
        'payload': {'round': round, 'choice': choice},
      };
}

@immutable
class PongMsg {
  static const type = 'pong';
  const PongMsg({required this.serverTs});
  final int serverTs;

  Map<String, dynamic> toJson() => {
        'type': type,
        'payload': {'server_ts': serverTs},
      };
}

// ── Server → Client ──────────────────────────────────────

@immutable
class ChallengeRecvMsg {
  static const type = 'challenge_recv';
  const ChallengeRecvMsg({
    required this.matchId,
    required this.challengerId,
    required this.challengerName,
    this.challengerAvatarUrl,
    required this.challengerDefaultAvatarIndex,
    required this.categoryId,
    required this.categoryName,
  });
  final String matchId;
  final String challengerId;
  final String challengerName;
  final String? challengerAvatarUrl;
  final int challengerDefaultAvatarIndex;
  final String categoryId;
  final String categoryName;

  factory ChallengeRecvMsg.fromJson(Map<String, dynamic> json) =>
      ChallengeRecvMsg(
        matchId: json['match_id'] as String,
        challengerId: json['challenger_id'] as String,
        challengerName: json['challenger_name'] as String,
        challengerAvatarUrl: json['challenger_avatar_url'] as String?,
        challengerDefaultAvatarIndex:
            json['challenger_default_avatar_index'] as int,
        categoryId: json['category_id'] as String,
        categoryName: json['category_name'] as String,
      );
}

@immutable
class GameStartMsg {
  static const type = 'game_start';
  const GameStartMsg({
    required this.matchId,
    required this.opponentName,
    this.opponentAvatarUrl,
    required this.opponentDefaultAvatarIndex,
    required this.categoryName,
    required this.totalRounds,
  });
  final String matchId;
  final String opponentName;
  final String? opponentAvatarUrl;
  final int opponentDefaultAvatarIndex;
  final String categoryName;
  final int totalRounds;

  factory GameStartMsg.fromJson(Map<String, dynamic> json) => GameStartMsg(
        matchId: json['match_id'] as String,
        opponentName: json['opponent_name'] as String,
        opponentAvatarUrl: json['opponent_avatar_url'] as String?,
        opponentDefaultAvatarIndex:
            json['opponent_default_avatar_index'] as int,
        categoryName: json['category_name'] as String,
        totalRounds: json['total_rounds'] as int,
      );
}

@immutable
class QuestionMsg {
  static const type = 'question';
  const QuestionMsg({
    required this.round,
    required this.text,
    required this.options,
    required this.timeoutMs,
  });
  final int round;
  final String text;
  final List<String> options;
  final int timeoutMs;

  factory QuestionMsg.fromJson(Map<String, dynamic> json) => QuestionMsg(
        round: json['round'] as int,
        text: json['text'] as String,
        options: (json['options'] as List).cast<String>(),
        timeoutMs: json['timeout_ms'] as int,
      );
}

@immutable
class OpponentAnsweredMsg {
  static const type = 'opponent_answered';
  const OpponentAnsweredMsg({required this.round});
  final int round;

  factory OpponentAnsweredMsg.fromJson(Map<String, dynamic> json) =>
      OpponentAnsweredMsg(round: json['round'] as int);
}

@immutable
class RoundResultMsg {
  static const type = 'round_result';
  const RoundResultMsg({
    required this.round,
    required this.yourChoice,
    required this.yourCorrect,
    required this.yourPoints,
    required this.theirChoice,
    required this.theirCorrect,
    required this.theirPoints,
    required this.yourTotal,
    required this.theirTotal,
    required this.correctIndex,
    required this.yourTimeMs,
    required this.theirTimeMs,
  });
  final int round;
  final int yourChoice;
  final bool yourCorrect;
  final int yourPoints;
  final int theirChoice;
  final bool theirCorrect;
  final int theirPoints;
  final int yourTotal;
  final int theirTotal;
  final int correctIndex;
  final int yourTimeMs;
  final int theirTimeMs;

  factory RoundResultMsg.fromJson(Map<String, dynamic> json) => RoundResultMsg(
        round: json['round'] as int,
        yourChoice: json['your_choice'] as int,
        yourCorrect: json['your_correct'] as bool,
        yourPoints: json['your_points'] as int,
        theirChoice: json['their_choice'] as int,
        theirCorrect: json['their_correct'] as bool,
        theirPoints: json['their_points'] as int,
        yourTotal: json['your_total'] as int,
        theirTotal: json['their_total'] as int,
        correctIndex: json['correct_index'] as int,
        yourTimeMs: json['your_time_ms'] as int,
        theirTimeMs: json['their_time_ms'] as int,
      );
}

@immutable
class GameEndMsg {
  static const type = 'game_end';
  const GameEndMsg({
    required this.matchId,
    required this.result,
    required this.yourTotal,
    required this.theirTotal,
    required this.ratingChange,
  });
  final String matchId;
  final String result; // "win" | "loss" | "draw"
  final int yourTotal;
  final int theirTotal;
  final int ratingChange;

  factory GameEndMsg.fromJson(Map<String, dynamic> json) => GameEndMsg(
        matchId: json['match_id'] as String,
        result: json['result'] as String,
        yourTotal: json['your_total'] as int,
        theirTotal: json['their_total'] as int,
        ratingChange: json['rating_change'] as int,
      );
}

@immutable
class FriendPresenceMsg {
  static const type = 'friend_presence';
  const FriendPresenceMsg({required this.friendId, required this.status});
  final String friendId;
  final String status;

  factory FriendPresenceMsg.fromJson(Map<String, dynamic> json) =>
      FriendPresenceMsg(
        friendId: json['friend_id'] as String,
        status: json['status'] as String,
      );
}

@immutable
class PingMsg {
  static const type = 'ping';
  const PingMsg({required this.serverTs});
  final int serverTs;

  factory PingMsg.fromJson(Map<String, dynamic> json) =>
      PingMsg(serverTs: json['server_ts'] as int);
}

@immutable
class ErrorMsg {
  static const type = 'error';
  const ErrorMsg({required this.code, required this.message});
  final String code;
  final String message;

  factory ErrorMsg.fromJson(Map<String, dynamic> json) => ErrorMsg(
        code: json['code'] as String,
        message: json['message'] as String,
      );
}
