import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_data.dart';
import '../models/friend.dart';

final friendsProvider = Provider<List<Friend>>((ref) {
  return MockData.friends;
});
