import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_si.dart';
import 'app_localizations_ta.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('si'),
    Locale('ta')
  ];

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get emailHint;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @loginToSocialPass.
  ///
  /// In en, this message translates to:
  /// **'Login to SocialPass'**
  String get loginToSocialPass;

  /// No description provided for @forgotpassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password ?'**
  String get forgotpassword;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get or;

  /// No description provided for @orloginwith.
  ///
  /// In en, this message translates to:
  /// **'Or Login with'**
  String get orloginwith;

  /// No description provided for @continuewithgoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continuewithgoogle;

  /// No description provided for @continuewithfacebook.
  ///
  /// In en, this message translates to:
  /// **'Continue with Facebook'**
  String get continuewithfacebook;

  /// No description provided for @continuewithapple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get continuewithapple;

  /// No description provided for @donthaveanaccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get donthaveanaccount;

  /// No description provided for @resetpassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetpassword;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @deleteaccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteaccount;

  /// No description provided for @emailisrequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required.'**
  String get emailisrequired;

  /// No description provided for @invalidemailaddress.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address.'**
  String get invalidemailaddress;

  /// No description provided for @password8.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters long.'**
  String get password8;

  /// No description provided for @passworduppercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one uppercase letter.'**
  String get passworduppercase;

  /// No description provided for @passwordlowercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one lowercase letter.'**
  String get passwordlowercase;

  /// No description provided for @passwordnumber.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one number.'**
  String get passwordnumber;

  /// No description provided for @weakpassword.
  ///
  /// In en, this message translates to:
  /// **'The password provided is too weak.'**
  String get weakpassword;

  /// No description provided for @passwordisrequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required.'**
  String get passwordisrequired;

  /// No description provided for @confirmpasswordisrequired.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password is required.'**
  String get confirmpasswordisrequired;

  /// No description provided for @passwordsdonotmatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordsdonotmatch;

  /// No description provided for @wrongpasswordpleasetryagain.
  ///
  /// In en, this message translates to:
  /// **'Wrong Password, Please try again'**
  String get wrongpasswordpleasetryagain;

  /// No description provided for @userIsNotLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'User is not logged in.'**
  String get userIsNotLoggedIn;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @passwordResetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Email sent'**
  String get passwordResetEmailSent;

  /// No description provided for @pleasecheckyouremailtoresetpassword.
  ///
  /// In en, this message translates to:
  /// **'Please check your email to reset your password'**
  String get pleasecheckyouremailtoresetpassword;

  /// No description provided for @okincaps.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okincaps;

  /// No description provided for @enteryouremailtoresetpassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to reset your password'**
  String get enteryouremailtoresetpassword;

  /// No description provided for @unexpectederror.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get unexpectederror;

  /// No description provided for @nouserfound.
  ///
  /// In en, this message translates to:
  /// **'No user found'**
  String get nouserfound;

  /// No description provided for @wrongpasswordprovided.
  ///
  /// In en, this message translates to:
  /// **'Wrong password provided. Please try again.'**
  String get wrongpasswordprovided;

  /// No description provided for @loginfailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please try again.'**
  String get loginfailed;

  /// No description provided for @trydifferentemail.
  ///
  /// In en, this message translates to:
  /// **'Try a different email address.'**
  String get trydifferentemail;

  /// No description provided for @signupfailed.
  ///
  /// In en, this message translates to:
  /// **'Signup failed. Please try again.'**
  String get signupfailed;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'The email address is invalid.'**
  String get errorInvalidEmail;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get confirmPasswordHint;

  /// No description provided for @addressRequired.
  ///
  /// In en, this message translates to:
  /// **'Address is required.'**
  String get addressRequired;

  /// No description provided for @locationRequired.
  ///
  /// In en, this message translates to:
  /// **'Location is required.'**
  String get locationRequired;

  /// No description provided for @districtRequired.
  ///
  /// In en, this message translates to:
  /// **'District is required.'**
  String get districtRequired;

  /// No description provided for @phoneNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required.'**
  String get phoneNumberRequired;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'User name is required'**
  String get nameRequired;

  /// No description provided for @continu.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continu;

  /// No description provided for @namewithInitial.
  ///
  /// In en, this message translates to:
  /// **'Name with initial'**
  String get namewithInitial;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name with initial'**
  String get nameHint;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @locationHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your location'**
  String get locationHint;

  /// No description provided for @addressHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your address'**
  String get addressHint;

  /// No description provided for @phoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get phoneNumberHint;

  /// No description provided for @errorloadinguserdata.
  ///
  /// In en, this message translates to:
  /// **'Error loading user data'**
  String get errorloadinguserdata;

  /// No description provided for @nouserdataavailable.
  ///
  /// In en, this message translates to:
  /// **'No user data available.'**
  String get nouserdataavailable;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @editprofile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editprofile;

  /// No description provided for @changepassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changepassword;

  /// No description provided for @customize.
  ///
  /// In en, this message translates to:
  /// **'Customize'**
  String get customize;

  /// No description provided for @languagepreferences.
  ///
  /// In en, this message translates to:
  /// **'Language Preferences'**
  String get languagepreferences;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @contactus.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contactus;

  /// No description provided for @legal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// No description provided for @privacypolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacypolicy;

  /// No description provided for @termsofuse.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get termsofuse;

  /// No description provided for @dangerzone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get dangerzone;

  /// No description provided for @areyousureyouwanttologout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get areyousureyouwanttologout;

  /// No description provided for @yesimsure.
  ///
  /// In en, this message translates to:
  /// **'Yes, I\'m sure'**
  String get yesimsure;

  /// No description provided for @areyousureyouwanttodelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete?'**
  String get areyousureyouwanttodelete;

  /// No description provided for @displaynamecannotbeempty.
  ///
  /// In en, this message translates to:
  /// **'Display name cannot be empty'**
  String get displaynamecannotbeempty;

  /// No description provided for @phonenumbercannotbeempty.
  ///
  /// In en, this message translates to:
  /// **'Phone number cannot be empty'**
  String get phonenumbercannotbeempty;

  /// No description provided for @invalidphonenumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalidphonenumber;

  /// No description provided for @profileupdatedsuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileupdatedsuccessfully;

  /// No description provided for @nameasteisk.
  ///
  /// In en, this message translates to:
  /// **'Name*'**
  String get nameasteisk;

  /// No description provided for @phonenumberasterisk.
  ///
  /// In en, this message translates to:
  /// **'Phone Number*'**
  String get phonenumberasterisk;

  /// No description provided for @savechanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get savechanges;

  /// No description provided for @currentpasswordcannotbeempty.
  ///
  /// In en, this message translates to:
  /// **'Current password cannot be empty'**
  String get currentpasswordcannotbeempty;

  /// No description provided for @newpasswordcannotbeempty.
  ///
  /// In en, this message translates to:
  /// **'New password cannot be empty'**
  String get newpasswordcannotbeempty;

  /// No description provided for @confirmpasswordcannotbeempty.
  ///
  /// In en, this message translates to:
  /// **'Confirm password cannot be empty'**
  String get confirmpasswordcannotbeempty;

  /// No description provided for @currentpasswordasterisk.
  ///
  /// In en, this message translates to:
  /// **'Current Password*'**
  String get currentpasswordasterisk;

  /// No description provided for @newpasswordastersisk.
  ///
  /// In en, this message translates to:
  /// **'New Password*'**
  String get newpasswordastersisk;

  /// No description provided for @confirmnewpasswordasterisk.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password*'**
  String get confirmnewpasswordasterisk;

  /// No description provided for @languagePreferences.
  ///
  /// In en, this message translates to:
  /// **'Language preferences'**
  String get languagePreferences;

  /// No description provided for @selectYourPreferredLanguageSemicolon.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language :'**
  String get selectYourPreferredLanguageSemicolon;

  /// No description provided for @locationpreferences.
  ///
  /// In en, this message translates to:
  /// **'Location preferences'**
  String get locationpreferences;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'si', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'si': return AppLocalizationsSi();
    case 'ta': return AppLocalizationsTa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
