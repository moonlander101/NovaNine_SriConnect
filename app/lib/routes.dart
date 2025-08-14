import 'package:go_router/go_router.dart';
import 'models/address.dart';
import 'views/app.dart';
import 'views/profile/screens/account_settings.dart';
import 'views/profile/screens/add_address_screen.dart';
import 'views/profile/screens/addresses_screen.dart';
import 'views/profile/screens/change_password_screen.dart';
import 'views/profile/screens/edit_profile_screen.dart';
import 'views/profile/screens/language_preference_screen.dart';

final router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => App(),
    ),
    GoRoute(
      path: '/account-settings',
      builder: (context, state) => const AccountSettingsScreen(),
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/change-password',
      builder: (context, state) => const ChangePasswordScreen(),
    ),
    GoRoute(
      path: '/language-preferences',
      builder: (context, state) => const LanguagePreferenceScreen(),
    ),
    GoRoute(
        path: '/add-address',
        builder: (context, state) {
          return AddAddressScreen();
        }),
    GoRoute(
      path: '/edit-address',
      builder: (context, state) {
        final address = state.extra as Address?;

        return AddAddressScreen(address: address); // <-- this allows edit
      },
    ),
    GoRoute(
      path: '/addresses/:userId',
      builder: (context, state) {
        final userId = state.pathParameters['userId'] ?? '';
        return AddressesScreen(userId: userId);
      },
    ),
  ],
);
