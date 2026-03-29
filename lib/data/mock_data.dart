import '../models/category.dart';
import '../models/friend.dart';
import '../models/match.dart';
import '../models/match_round.dart';
import '../models/question.dart';
import '../models/user.dart';

class MockData {
  // ── Current user ──────────────────────────────────────

  static final currentUser = User(
    id: 'u_self',
    username: 'davoc',
    displayName: 'David',
    defaultAvatarIndex: 1,
    rating: 1458,
    createdAt: DateTime(2025, 6, 15),
  );

  // ── Friends (6, mixed statuses) ───────────────────────

  static final friends = [
    const Friend(
      id: 'u_sarah',
      username: 'sarah_oz',
      displayName: 'Sarah',
      defaultAvatarIndex: 6,
      rating: 1520,
      status: 'online',
      h2hWins: 12,
      h2hLosses: 8,
    ),
    const Friend(
      id: 'u_ciaran',
      username: 'ciaran_k',
      displayName: 'Ciarán',
      defaultAvatarIndex: 2,
      rating: 1390,
      status: 'online',
      h2hWins: 5,
      h2hLosses: 7,
    ),
    const Friend(
      id: 'u_aisha',
      username: 'aisha_m',
      displayName: 'Aisha',
      defaultAvatarIndex: 7,
      rating: 1610,
      status: 'in_match',
      h2hWins: 3,
      h2hLosses: 6,
    ),
    Friend(
      id: 'u_tom',
      username: 'tommy_b',
      displayName: 'Tom',
      defaultAvatarIndex: 3,
      rating: 1280,
      status: 'offline',
      lastSeenAt: DateTime.now().subtract(const Duration(hours: 2)),
      h2hWins: 9,
      h2hLosses: 4,
    ),
    Friend(
      id: 'u_niamh',
      username: 'niamh_d',
      displayName: 'Niamh',
      defaultAvatarIndex: 11,
      rating: 1445,
      status: 'offline',
      lastSeenAt: DateTime.now().subtract(const Duration(days: 1)),
      h2hWins: 6,
      h2hLosses: 6,
    ),
    const Friend(
      id: 'u_marcus',
      username: 'marc_nyc',
      displayName: 'Marcus',
      defaultAvatarIndex: 9,
      rating: 1550,
      status: 'online',
      h2hWins: 2,
      h2hLosses: 3,
    ),
  ];

  // ── Categories (5, matching SVG assets) ───────────────

  static const categories = [
    Category(
      id: 'cat_1',
      name: 'General Knowledge',
      description: 'The true pub classic.',
      iconPath: 'assets/icons/categories/general_knowledge.svg',
      questionCount: 15,
    ),
    Category(
      id: 'cat_2',
      name: 'Movies',
      description: 'IMDb habit pays off.',
      iconPath: 'assets/icons/categories/movies.svg',
      questionCount: 20,
    ),
    Category(
      id: 'cat_3',
      name: 'History',
      description: 'Chronicles of the past.',
      iconPath: 'assets/icons/categories/history.svg',
      questionCount: 12,
    ),
    Category(
      id: 'cat_4',
      name: 'Geography',
      description: 'Where in the world?',
      iconPath: 'assets/icons/categories/geography.svg',
      questionCount: 18,
    ),
    Category(
      id: 'cat_5',
      name: 'Ireland',
      description: 'The Emerald Isle.',
      iconPath: 'assets/icons/categories/ireland.svg',
      questionCount: 10,
    ),
  ];

  // ── Mock questions (10 for a full game) ───────────────
  // Correct answer is always options[0] in mock data.

  static const mockQuestions = [
    Question(
      round: 1,
      text: 'What is the chemical symbol for gold?',
      options: ['Au', 'Ag', 'Fe', 'Cu'],
      timeoutMs: 15000,
    ),
    Question(
      round: 2,
      text: 'In which year did the Titanic sink?',
      options: ['1912', '1905', '1918', '1923'],
      timeoutMs: 15000,
    ),
    Question(
      round: 3,
      text: 'What is the largest ocean on Earth?',
      options: ['Pacific', 'Atlantic', 'Indian', 'Arctic'],
      timeoutMs: 15000,
    ),
    Question(
      round: 4,
      text: 'Who directed "Inception"?',
      options: ['Christopher Nolan', 'Steven Spielberg', 'Denis Villeneuve', 'Ridley Scott'],
      timeoutMs: 15000,
    ),
    Question(
      round: 5,
      text: 'What is the capital of New Zealand?',
      options: ['Wellington', 'Auckland', 'Christchurch', 'Queenstown'],
      timeoutMs: 15000,
    ),
    Question(
      round: 6,
      text: 'Which element has the atomic number 1?',
      options: ['Hydrogen', 'Helium', 'Lithium', 'Carbon'],
      timeoutMs: 15000,
    ),
    Question(
      round: 7,
      text: 'What river flows through Dublin?',
      options: ['Liffey', 'Shannon', 'Lee', 'Boyne'],
      timeoutMs: 15000,
    ),
    Question(
      round: 8,
      text: 'Who painted the ceiling of the Sistine Chapel?',
      options: ['Michelangelo', 'Leonardo da Vinci', 'Raphael', 'Donatello'],
      timeoutMs: 15000,
    ),
    Question(
      round: 9,
      text: 'What is the smallest country in the world by area?',
      options: ['Vatican City', 'Monaco', 'San Marino', 'Liechtenstein'],
      timeoutMs: 15000,
    ),
    Question(
      round: 10,
      text: 'In what year was the first iPhone released?',
      options: ['2007', '2005', '2008', '2010'],
      timeoutMs: 15000,
    ),
  ];

  // ── Recent matches (3 for Hub display) ────────────────

  static final recentMatches = [
    Match(
      id: 'm_1',
      opponentName: 'Sarah',
      opponentDefaultAvatarIndex: 6,
      categoryName: 'General Knowledge',
      yourScore: 6800,
      theirScore: 5200,
      result: 'win',
      ratingChange: 18,
      playedAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    Match(
      id: 'm_2',
      opponentName: 'Ciarán',
      opponentDefaultAvatarIndex: 2,
      categoryName: 'Ireland',
      yourScore: 4100,
      theirScore: 5900,
      result: 'loss',
      ratingChange: -12,
      playedAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    Match(
      id: 'm_3',
      opponentName: 'Marcus',
      opponentDefaultAvatarIndex: 9,
      categoryName: 'Movies',
      yourScore: 7200,
      theirScore: 6400,
      result: 'win',
      ratingChange: 15,
      playedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  // ── Mock round results (10 rounds from match m_1) ─────

  static const mockMatchRounds = [
    MatchRound(round: 1, questionText: 'What is the chemical symbol for gold?', correctAnswer: 'Au', yourChoice: 0, yourCorrect: true, yourTimeMs: 1200, theirChoice: 2, theirCorrect: false, theirTimeMs: 3400, yourPoints: 920, theirPoints: 0),
    MatchRound(round: 2, questionText: 'In which year did the Titanic sink?', correctAnswer: '1912', yourChoice: 0, yourCorrect: true, yourTimeMs: 2100, theirChoice: 0, theirCorrect: true, theirTimeMs: 4200, yourPoints: 860, theirPoints: 720),
    MatchRound(round: 3, questionText: 'What is the largest ocean on Earth?', correctAnswer: 'Pacific', yourChoice: 1, yourCorrect: false, yourTimeMs: 5100, theirChoice: 0, theirCorrect: true, theirTimeMs: 2000, yourPoints: 0, theirPoints: 870),
    MatchRound(round: 4, questionText: 'Who directed "Inception"?', correctAnswer: 'Christopher Nolan', yourChoice: 0, yourCorrect: true, yourTimeMs: 800, theirChoice: 0, theirCorrect: true, theirTimeMs: 1500, yourPoints: 950, theirPoints: 900),
    MatchRound(round: 5, questionText: 'What is the capital of New Zealand?', correctAnswer: 'Wellington', yourChoice: 0, yourCorrect: true, yourTimeMs: 3200, theirChoice: 1, theirCorrect: false, theirTimeMs: 6000, yourPoints: 790, theirPoints: 0),
    MatchRound(round: 6, questionText: 'Which element has the atomic number 1?', correctAnswer: 'Hydrogen', yourChoice: 0, yourCorrect: true, yourTimeMs: 1500, theirChoice: 0, theirCorrect: true, theirTimeMs: 2800, yourPoints: 900, theirPoints: 810),
    MatchRound(round: 7, questionText: 'What river flows through Dublin?', correctAnswer: 'Liffey', yourChoice: 0, yourCorrect: true, yourTimeMs: 900, theirChoice: 3, theirCorrect: false, theirTimeMs: 8200, yourPoints: 940, theirPoints: 0),
    MatchRound(round: 8, questionText: 'Who painted the Sistine Chapel ceiling?', correctAnswer: 'Michelangelo', yourChoice: 2, yourCorrect: false, yourTimeMs: 7500, theirChoice: 0, theirCorrect: true, theirTimeMs: 3100, yourPoints: 0, theirPoints: 800),
    MatchRound(round: 9, questionText: 'Smallest country by area?', correctAnswer: 'Vatican City', yourChoice: 0, yourCorrect: true, yourTimeMs: 2400, theirChoice: 1, theirCorrect: false, theirTimeMs: 4500, yourPoints: 840, theirPoints: 0),
    MatchRound(round: 10, questionText: 'Year of the first iPhone?', correctAnswer: '2007', yourChoice: 0, yourCorrect: true, yourTimeMs: 1100, theirChoice: 0, theirCorrect: true, theirTimeMs: 1900, yourPoints: 930, theirPoints: 870),
  ];
}
