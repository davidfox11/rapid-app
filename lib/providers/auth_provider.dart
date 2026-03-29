import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_data.dart';
import '../models/user.dart';

final currentUserProvider = Provider<User>((ref) {
  return MockData.currentUser;
});
