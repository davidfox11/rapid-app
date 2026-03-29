import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_data.dart';
import '../models/category.dart';

final categoriesProvider = Provider<List<Category>>((ref) {
  return MockData.categories;
});
