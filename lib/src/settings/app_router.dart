import 'package:go_router/go_router.dart';
import 'package:pecunia/screens/category_expenses.dart';

import '../../screens/home.dart';

// GoRouter configuration
final router = GoRouter(
  routes: <GoRoute>[
    GoRoute(
        path: '/',
        builder: (context, state) {
          return Home();
        },
        routes: <GoRoute>[
          GoRoute(
            path: 'category_expenses/:categoryId',
            builder: (context, state) => CategoryExpenses(
              categoryId: state.pathParameters['categoryId']!,
            ),
          )
        ]),
  ],
);
