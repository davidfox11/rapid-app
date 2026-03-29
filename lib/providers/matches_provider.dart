import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_data.dart';
import '../models/match.dart';

final matchesProvider = Provider<List<Match>>((ref) {
  return MockData.recentMatches;
});
