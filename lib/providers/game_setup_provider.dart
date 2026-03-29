import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/category.dart';
import '../models/friend.dart';

final selectedOpponentProvider = StateProvider<Friend?>((ref) => null);
final selectedCategoryProvider = StateProvider<Category?>((ref) => null);
