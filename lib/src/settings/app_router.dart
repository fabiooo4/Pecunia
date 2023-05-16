import 'package:go_router/go_router.dart';
import 'package:pecunia/screens/category_expenses.dart';
import 'package:pecunia/screens/login.dart';
import 'package:pecunia/screens/sign_up.dart';

import '../../screens/home.dart';

// GoRouter configuration
final router = GoRouter(
  routes: <GoRoute>[
    GoRoute(
        path: '/home',
        builder: (context, state) {
          return const Home();
        },
        routes: <GoRoute>[
          GoRoute(
            path: 'category_expenses/:categoryId',
            builder: (context, state) => CategoryExpenses(
              categoryId: state.pathParameters['categoryId']!,
            ),
          )
        ]),
    GoRoute(path: '/', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupPage()),
  ],
);
