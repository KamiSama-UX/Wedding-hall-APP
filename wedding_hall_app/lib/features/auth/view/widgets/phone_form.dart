import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_form_field/phone_form_field.dart';

class PhoneFieldView extends StatelessWidget {
  static const supportedLocales = [
    Locale('ar'),
    Locale('en'),
  ];

  final PhoneController controller;
  final FocusNode focusNode;
  final CountrySelectorNavigator selectorNavigator;
  final bool isCountryButtonPersistant;
  final String hintText;
  final bool mobileOnly;
  final Locale locale;

  const PhoneFieldView({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.selectorNavigator,
    required this.isCountryButtonPersistant,
    required this.mobileOnly,
    required this.locale,
    required this.hintText,
  });

  PhoneNumberInputValidator? _getValidator(BuildContext context) {
    List<PhoneNumberInputValidator> validators = [];
    validators.add(PhoneValidator.required(context));
    if (mobileOnly) {
      validators.add(PhoneValidator.validMobile(context));
    } else {
      validators.add(PhoneValidator.valid(context));
    }
    return validators.isNotEmpty ? PhoneValidator.compose(validators) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Theme(
        data: Theme.of(context).copyWith(
          inputDecorationTheme: const InputDecorationTheme(
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
        child: AutofillGroup(
          child: Localizations.override(
            context: context,
            locale: locale,
            child: Builder(
              builder: (context) {
                return PhoneFormField(
                  controller: controller,
                  focusNode: focusNode,
                  isCountryButtonPersistent: isCountryButtonPersistant,
                  autofocus: false,
                  autofillHints: const [AutofillHints.telephoneNumber],
                  countrySelectorNavigator: selectorNavigator,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                  enabled: true,
                  countryButtonStyle: const CountryButtonStyle(
                    showFlag: true,
                    showIsoCode: false,
                    showDialCode: true,
                    showDropdownIcon: true,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  autovalidateMode: AutovalidateMode.disabled,
                  validator: _getValidator(context),
                );
              },
            ),
          ),
        ),
      );
    });
  }
}
