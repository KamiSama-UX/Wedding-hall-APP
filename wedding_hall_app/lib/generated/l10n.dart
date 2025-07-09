// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Email must not be empty`
  String get emailMustNotBeEmpty {
    return Intl.message(
      'Email must not be empty',
      name: 'emailMustNotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Password must not be empty`
  String get passwordMustNotBeEmpty {
    return Intl.message(
      'Password must not be empty',
      name: 'passwordMustNotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Password must be more than 8 characters`
  String get passwordMoreThanEightCharacters {
    return Intl.message(
      'Password must be more than 8 characters',
      name: 'passwordMoreThanEightCharacters',
      desc: '',
      args: [],
    );
  }

  /// `Password must have at least one capital letter`
  String get passwordMustHaveOneCapitalLetter {
    return Intl.message(
      'Password must have at least one capital letter',
      name: 'passwordMustHaveOneCapitalLetter',
      desc: '',
      args: [],
    );
  }

  /// `Password must have at least one capital letter`
  String get passwordMustHaveOneSmallLetter {
    return Intl.message(
      'Password must have at least one capital letter',
      name: 'passwordMustHaveOneSmallLetter',
      desc: '',
      args: [],
    );
  }

  /// `Password must have at least one number`
  String get passwordMustHaveOneNumber {
    return Intl.message(
      'Password must have at least one number',
      name: 'passwordMustHaveOneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Password must have at least one special characters`
  String get passwordMustHaveoneSpecialCharacters {
    return Intl.message(
      'Password must have at least one special characters',
      name: 'passwordMustHaveoneSpecialCharacters',
      desc: '',
      args: [],
    );
  }

  /// `Let's get started`
  String get letsGetStarted {
    return Intl.message(
      'Let\'s get started',
      name: 'letsGetStarted',
      desc: '',
      args: [],
    );
  }

  /// `Number`
  String get number {
    return Intl.message(
      'Number',
      name: 'number',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password must not be empty`
  String get confirmPasswordMustNoBeEmpty {
    return Intl.message(
      'Confirm password must not be empty',
      name: 'confirmPasswordMustNoBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Create Your Account To Start Shppoing With Asool`
  String get createYourAccountToStartShppoing {
    return Intl.message(
      'Create Your Account To Start Shppoing With Asool',
      name: 'createYourAccountToStartShppoing',
      desc: '',
      args: [],
    );
  }

  /// `Start With your Al-Asal account`
  String get startWithYourAlAsalAccount {
    return Intl.message(
      'Start With your Al-Asal account',
      name: 'startWithYourAlAsalAccount',
      desc: '',
      args: [],
    );
  }

  /// `Forget Password ? `
  String get forgetPassword {
    return Intl.message(
      'Forget Password ? ',
      name: 'forgetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password not match`
  String get passwordNotMatch {
    return Intl.message(
      'Password not match',
      name: 'passwordNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Recover it`
  String get recoverIt {
    return Intl.message(
      'Recover it',
      name: 'recoverIt',
      desc: '',
      args: [],
    );
  }

  /// `Let's Go`
  String get letsGo {
    return Intl.message(
      'Let\'s Go',
      name: 'letsGo',
      desc: '',
      args: [],
    );
  }

  /// `Or`
  String get or {
    return Intl.message(
      'Or',
      name: 'or',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Apple`
  String get signinWithApple {
    return Intl.message(
      'Sign in with Apple',
      name: 'signinWithApple',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Google`
  String get signinWithGoogle {
    return Intl.message(
      'Sign in with Google',
      name: 'signinWithGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Sign up with email`
  String get signUpWithEmail {
    return Intl.message(
      'Sign up with email',
      name: 'signUpWithEmail',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Recover Password`
  String get recoverPassword {
    return Intl.message(
      'Recover Password',
      name: 'recoverPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email address below to receive  your verification code.`
  String get enterYourEmailAddressBelowToReceiveYourVerificationCode {
    return Intl.message(
      'Enter your email address below to receive  your verification code.',
      name: 'enterYourEmailAddressBelowToReceiveYourVerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `Verify your email`
  String get verifyYourEmail {
    return Intl.message(
      'Verify your email',
      name: 'verifyYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter the verification code that you received on your email`
  String get EnterTheDigitsVerificationCode {
    return Intl.message(
      'Enter the verification code that you received on your email',
      name: 'EnterTheDigitsVerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `Field must not be empty`
  String get fieldMustNotBeNull {
    return Intl.message(
      'Field must not be empty',
      name: 'fieldMustNotBeNull',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid email`
  String get enterValidEmail {
    return Intl.message(
      'Enter a valid email',
      name: 'enterValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Verifcation code is not completed`
  String get verifcationCodeIsNotCompleted {
    return Intl.message(
      'Verifcation code is not completed',
      name: 'verifcationCodeIsNotCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Send Code`
  String get sendCode {
    return Intl.message(
      'Send Code',
      name: 'sendCode',
      desc: '',
      args: [],
    );
  }

  /// `verify email`
  String get verifyEmail {
    return Intl.message(
      'verify email',
      name: 'verifyEmail',
      desc: '',
      args: [],
    );
  }

  /// `Your Gift Shop`
  String get yourGiftShop {
    return Intl.message(
      'Your Gift Shop',
      name: 'yourGiftShop',
      desc: '',
      args: [],
    );
  }

  /// `Hot Offers`
  String get hotOffers {
    return Intl.message(
      'Hot Offers',
      name: 'hotOffers',
      desc: '',
      args: [],
    );
  }

  /// `View All`
  String get viewAll {
    return Intl.message(
      'View All',
      name: 'viewAll',
      desc: '',
      args: [],
    );
  }

  /// `Popular Categories`
  String get popularCategories {
    return Intl.message(
      'Popular Categories',
      name: 'popularCategories',
      desc: '',
      args: [],
    );
  }

  /// `Popular Shpos`
  String get popularShops {
    return Intl.message(
      'Popular Shpos',
      name: 'popularShops',
      desc: '',
      args: [],
    );
  }

  /// `Hot Gifts`
  String get hotGifts {
    return Intl.message(
      'Hot Gifts',
      name: 'hotGifts',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Shops`
  String get shops {
    return Intl.message(
      'Shops',
      name: 'shops',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categories {
    return Intl.message(
      'Categories',
      name: 'categories',
      desc: '',
      args: [],
    );
  }

  /// `products`
  String get products {
    return Intl.message(
      'products',
      name: 'products',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Points`
  String get points {
    return Intl.message(
      'Points',
      name: 'points',
      desc: '',
      args: [],
    );
  }

  /// `Change Your Password`
  String get changeYourPassword {
    return Intl.message(
      'Change Your Password',
      name: 'changeYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Order`
  String get order {
    return Intl.message(
      'Order',
      name: 'order',
      desc: '',
      args: [],
    );
  }

  /// `Order Detials`
  String get orderDetials {
    return Intl.message(
      'Order Detials',
      name: 'orderDetials',
      desc: '',
      args: [],
    );
  }

  /// `Order List`
  String get orderList {
    return Intl.message(
      'Order List',
      name: 'orderList',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message(
      'Theme',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get darkMode {
    return Intl.message(
      'Dark Mode',
      name: 'darkMode',
      desc: '',
      args: [],
    );
  }

  /// `Light Mode`
  String get lightMode {
    return Intl.message(
      'Light Mode',
      name: 'lightMode',
      desc: '',
      args: [],
    );
  }

  /// `Search For Anything`
  String get searchForAnything {
    return Intl.message(
      'Search For Anything',
      name: 'searchForAnything',
      desc: '',
      args: [],
    );
  }

  /// `Gifts`
  String get gifts {
    return Intl.message(
      'Gifts',
      name: 'gifts',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Delete Gift`
  String get deleteGift {
    return Intl.message(
      'Delete Gift',
      name: 'deleteGift',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete the gift from cart ?`
  String get doYouWantToDeleteGiftFromCart {
    return Intl.message(
      'Do you want to delete the gift from cart ?',
      name: 'doYouWantToDeleteGiftFromCart',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get success {
    return Intl.message(
      'Success',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `Error happened`
  String get errorHappened {
    return Intl.message(
      'Error happened',
      name: 'errorHappened',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Your account is ready to use`
  String get yourAccountReadyToUse {
    return Intl.message(
      'Your account is ready to use',
      name: 'yourAccountReadyToUse',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Password Changed Successfly`
  String get passwordChangedSuccessfly {
    return Intl.message(
      'Password Changed Successfly',
      name: 'passwordChangedSuccessfly',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the code and our new password and confirm it`
  String get pleaseEnterYourNewPasswordAndConfirmIt {
    return Intl.message(
      'Please enter the code and our new password and confirm it',
      name: 'pleaseEnterYourNewPasswordAndConfirmIt',
      desc: '',
      args: [],
    );
  }

  /// `Order Now`
  String get orderNow {
    return Intl.message(
      'Order Now',
      name: 'orderNow',
      desc: '',
      args: [],
    );
  }

  /// `Order ID`
  String get orderId {
    return Intl.message(
      'Order ID',
      name: 'orderId',
      desc: '',
      args: [],
    );
  }

  /// `Gift Description`
  String get giftDescription {
    return Intl.message(
      'Gift Description',
      name: 'giftDescription',
      desc: '',
      args: [],
    );
  }

  /// `Similar Gifts`
  String get similarGifts {
    return Intl.message(
      'Similar Gifts',
      name: 'similarGifts',
      desc: '',
      args: [],
    );
  }

  /// `No History Search`
  String get noSearchHistory {
    return Intl.message(
      'No History Search',
      name: 'noSearchHistory',
      desc: '',
      args: [],
    );
  }

  /// `Start Searching To Save History`
  String get startSearchingToSaveHistory {
    return Intl.message(
      'Start Searching To Save History',
      name: 'startSearchingToSaveHistory',
      desc: '',
      args: [],
    );
  }

  /// `We couldn't find any results for:`
  String get weCantFindResults {
    return Intl.message(
      'We couldn\'t find any results for:',
      name: 'weCantFindResults',
      desc: '',
      args: [],
    );
  }

  /// `We coudn't find any`
  String get weCantFindAny {
    return Intl.message(
      'We coudn\'t find any',
      name: 'weCantFindAny',
      desc: '',
      args: [],
    );
  }

  /// ` added to cart successfully`
  String get addedToCartSuccessfully {
    return Intl.message(
      ' added to cart successfully',
      name: 'addedToCartSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `My Cart`
  String get myCart {
    return Intl.message(
      'My Cart',
      name: 'myCart',
      desc: '',
      args: [],
    );
  }

  /// `Your cart is empty`
  String get yourCartIsEmpty {
    return Intl.message(
      'Your cart is empty',
      name: 'yourCartIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Please add some gifts to order somthing`
  String get pleaseAddSomeGiftsToOrderSomthing {
    return Intl.message(
      'Please add some gifts to order somthing',
      name: 'pleaseAddSomeGiftsToOrderSomthing',
      desc: '',
      args: [],
    );
  }

  /// `Gift already exist in the cart`
  String get giftAlreadyExistInTheCart {
    return Intl.message(
      'Gift already exist in the cart',
      name: 'giftAlreadyExistInTheCart',
      desc: '',
      args: [],
    );
  }

  /// `Total Price`
  String get totalPrice {
    return Intl.message(
      'Total Price',
      name: 'totalPrice',
      desc: '',
      args: [],
    );
  }

  /// `There's no similar gifts for this gift`
  String get noSimilarGifts {
    return Intl.message(
      'There\'s no similar gifts for this gift',
      name: 'noSimilarGifts',
      desc: '',
      args: [],
    );
  }

  /// `Set Receiver Location`
  String get setReceiverLocation {
    return Intl.message(
      'Set Receiver Location',
      name: 'setReceiverLocation',
      desc: '',
      args: [],
    );
  }

  /// `Deliver Date`
  String get deliverDate {
    return Intl.message(
      'Deliver Date',
      name: 'deliverDate',
      desc: '',
      args: [],
    );
  }

  /// `Receiver Name`
  String get receiverName {
    return Intl.message(
      'Receiver Name',
      name: 'receiverName',
      desc: '',
      args: [],
    );
  }

  /// `Receiver Phone`
  String get receiverPhone {
    return Intl.message(
      'Receiver Phone',
      name: 'receiverPhone',
      desc: '',
      args: [],
    );
  }

  /// `You Should Mark Receiver Location`
  String get youShouldMarkReceiverLocation {
    return Intl.message(
      'You Should Mark Receiver Location',
      name: 'youShouldMarkReceiverLocation',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Order Information`
  String get orderInformation {
    return Intl.message(
      'Order Information',
      name: 'orderInformation',
      desc: '',
      args: [],
    );
  }

  /// `No gifts in category called`
  String get noGiftsInCategoryCalled {
    return Intl.message(
      'No gifts in category called',
      name: 'noGiftsInCategoryCalled',
      desc: '',
      args: [],
    );
  }

  /// `No categories in shop called`
  String get noCategoriesInShopCalled {
    return Intl.message(
      'No categories in shop called',
      name: 'noCategoriesInShopCalled',
      desc: '',
      args: [],
    );
  }

  /// `Please Try Again ..`
  String get pleaseTryAgain {
    return Intl.message(
      'Please Try Again ..',
      name: 'pleaseTryAgain',
      desc: '',
      args: [],
    );
  }

  /// `There is no hot offer right now`
  String get thereIsNoHotOfferRightNow {
    return Intl.message(
      'There is no hot offer right now',
      name: 'thereIsNoHotOfferRightNow',
      desc: '',
      args: [],
    );
  }

  /// `Payment Success`
  String get paymentSuccess {
    return Intl.message(
      'Payment Success',
      name: 'paymentSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Payment Failed`
  String get paymentFailed {
    return Intl.message(
      'Payment Failed',
      name: 'paymentFailed',
      desc: '',
      args: [],
    );
  }

  /// `You Didn't make any order until now`
  String get youDidntMakeAnyOrder {
    return Intl.message(
      'You Didn\'t make any order until now',
      name: 'youDidntMakeAnyOrder',
      desc: '',
      args: [],
    );
  }

  /// `Contact with as`
  String get contactWithAs {
    return Intl.message(
      'Contact with as',
      name: 'contactWithAs',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Order can't be done`
  String get orderCantBeDone {
    return Intl.message(
      'Order can\'t be done',
      name: 'orderCantBeDone',
      desc: '',
      args: [],
    );
  }

  /// `No Shops Found`
  String get noShopsFound {
    return Intl.message(
      'No Shops Found',
      name: 'noShopsFound',
      desc: '',
      args: [],
    );
  }

  /// `No Category Found`
  String get noCategoryFound {
    return Intl.message(
      'No Category Found',
      name: 'noCategoryFound',
      desc: '',
      args: [],
    );
  }

  /// `No hot gifts Found`
  String get noHotGiftsFound {
    return Intl.message(
      'No hot gifts Found',
      name: 'noHotGiftsFound',
      desc: '',
      args: [],
    );
  }

  /// `Ordered Gifts`
  String get orderedGifts {
    return Intl.message(
      'Ordered Gifts',
      name: 'orderedGifts',
      desc: '',
      args: [],
    );
  }

  /// `Reciver Info`
  String get reciverInfo {
    return Intl.message(
      'Reciver Info',
      name: 'reciverInfo',
      desc: '',
      args: [],
    );
  }

  /// `Order ID :`
  String get orderIdDoublePoints {
    return Intl.message(
      'Order ID :',
      name: 'orderIdDoublePoints',
      desc: '',
      args: [],
    );
  }

  /// `Alert`
  String get alert {
    return Intl.message(
      'Alert',
      name: 'alert',
      desc: '',
      args: [],
    );
  }

  /// `Your account isn't verified`
  String get yourAccountIsNotVerified {
    return Intl.message(
      'Your account isn\'t verified',
      name: 'yourAccountIsNotVerified',
      desc: '',
      args: [],
    );
  }

  /// `Try Again`
  String get tryAgain {
    return Intl.message(
      'Try Again',
      name: 'tryAgain',
      desc: '',
      args: [],
    );
  }

  /// `Premium Service`
  String get premiumService {
    return Intl.message(
      'Premium Service',
      name: 'premiumService',
      desc: '',
      args: [],
    );
  }

  /// `Premium Percentage`
  String get premiumPercentage {
    return Intl.message(
      'Premium Percentage',
      name: 'premiumPercentage',
      desc: '',
      args: [],
    );
  }

  /// `Fee automatically calculated from order total`
  String get premiumFeeNote {
    return Intl.message(
      'Fee automatically calculated from order total',
      name: 'premiumFeeNote',
      desc: '',
      args: [],
    );
  }

  /// `Select delivery date (1-2 days)`
  String get premiumDateHint {
    return Intl.message(
      'Select delivery date (1-2 days)',
      name: 'premiumDateHint',
      desc: '',
      args: [],
    );
  }

  /// `Select delivery date (3+ days)`
  String get regularDateHint {
    return Intl.message(
      'Select delivery date (3+ days)',
      name: 'regularDateHint',
      desc: '',
      args: [],
    );
  }

  /// `Get delivery in 1 day (instead of 3) with:\n• Priority processing\n• Guaranteed faster delivery\n• Extra %{{premiumPercentage}} fee`
  String premiumServiceDesc(Object premiumPercentage) {
    return Intl.message(
      'Get delivery in 1 day (instead of 3) with:\n• Priority processing\n• Guaranteed faster delivery\n• Extra %{$premiumPercentage} fee',
      name: 'premiumServiceDesc',
      desc: '',
      args: [premiumPercentage],
    );
  }

  /// `Origin Price`
  String get originPrice {
    return Intl.message(
      'Origin Price',
      name: 'originPrice',
      desc: '',
      args: [],
    );
  }

  /// `Final Price`
  String get finalPrice {
    return Intl.message(
      'Final Price',
      name: 'finalPrice',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Select Language`
  String get selectLanguage {
    return Intl.message(
      'Select Language',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get arabic {
    return Intl.message(
      'Arabic',
      name: 'arabic',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Note`
  String get note {
    return Intl.message(
      'Note',
      name: 'note',
      desc: '',
      args: [],
    );
  }

  /// `Write any thing in your note`
  String get writeAnyThingInYourNote {
    return Intl.message(
      'Write any thing in your note',
      name: 'writeAnyThingInYourNote',
      desc: '',
      args: [],
    );
  }

  /// `See more`
  String get seeMore {
    return Intl.message(
      'See more',
      name: 'seeMore',
      desc: '',
      args: [],
    );
  }

  /// `See less`
  String get seeLess {
    return Intl.message(
      'See less',
      name: 'seeLess',
      desc: '',
      args: [],
    );
  }

  /// `Pricing`
  String get pricing {
    return Intl.message(
      'Pricing',
      name: 'pricing',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
