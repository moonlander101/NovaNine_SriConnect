import 'package:go_router/go_router.dart';
import 'views/app.dart';


final router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => App(),
    ),
  ],
);
