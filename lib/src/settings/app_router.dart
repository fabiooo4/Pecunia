import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pecunia/screens/dashboard/category_expenses.dart';
import 'package:pecunia/screens/dashboard/transaction.dart';
import 'package:pecunia/screens/auth/login.dart';
import 'package:pecunia/screens/auth/sign_up.dart';
import 'package:pecunia/screens/home_layout.dart';
import 'package:pecunia/screens/auth/validation.dart';

import '../../screens/other/accounts.dart';
import '../../screens/other/categories.dart';
import '../../screens/other/settings.dart';

// Custom transition between pages
CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

// GoRouter configuration
final router = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginPage(),
      pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
        context: context,
        state: state,
        child: const LoginPage(),
      ),
    ),
    GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupPage(),
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: const SignupPage(),
            )),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeLayout(),
      pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
        context: context,
        state: state,
        child: const HomeLayout(),
      ),
      routes: <GoRoute>[
        GoRoute(
          path: 'dashboard/category_expenses/:categoryId',
          builder: (context, state) {
            final params = state.extra as CategoryTransactionsParams;

            return CategoryTransactions(params: params);
          },
          pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: CategoryTransactions(
              params: state.extra as CategoryTransactionsParams,
            ),
          ),
        ),
        GoRoute(
          path: 'dashboard/transaction/:transactionId',
          builder: (context, state) {
            final params = state.extra as TransactionPageParams;

            return TransactionPage(params: params);
          },
        ),
        GoRoute(
          path: 'other/settings',
          builder: (context, state) => const Settings(),
          pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const Settings(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(3.0, 0.0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      )),
        ),
        GoRoute(
          path: 'other/categories',
          builder: (context, state) => const Categories(),
          pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const Categories(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(3.0, 0.0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      )),
        ),
        GoRoute(
          path: 'other/accounts',
          builder: (context, state) => const Accounts(),
          pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const Accounts(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(3.0, 0.0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      )),
        ),
      ],
    ),
    GoRoute(
        path: '/validation',
        builder: (context, state) {
          final params = state.extra as VerificationPageParams;

          return Validation(params: params);
        },
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: Validation(params: state.extra as VerificationPageParams),
            )),
  ],
);
