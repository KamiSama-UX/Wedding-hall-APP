import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:wedding_hall_app/config/helpers/extensions.dart';

import '../../../../config/routes/routes_path.dart';
import '../../../../config/theme/custom_text_style.dart';
import '../../../../config/validation/text_form_validation.dart';
import '../../../../generated/l10n.dart';
import '../../../core/domain/base_classes/base_state.dart';
import '../../../core/view/widgets/custom_text_field.dart';
import '../../../core/view/widgets/reusable_bloc_listner.dart';
import '../../../core/view/widgets/scrollable_column_expanded.dart';
import '../cubit/email_for_pass_cubit.dart';

class EnterEmail extends StatefulWidget {
  const EnterEmail({super.key});

  @override
  State<EnterEmail> createState() => _EnterEmailState();
}

class _EnterEmailState extends State<EnterEmail> {
  late TextEditingController emailController;

  GlobalKey<FormState> form = GlobalKey<FormState>();
  @override
  void initState() {
    emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    emailController.text = "waseemalqahwaji123@gmail.com";
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Form(
        key: form,
        child: ScrollColumnExpandable(
          padding: EdgeInsets.symmetric(horizontal: 20.0.h),
          children: [
            ReusableBlocListener<EmailForPassCubit>(
              cubit: context.read<EmailForPassCubit>(),
              onStateChange: (context, currentState) {
                if (currentState is SuccessState) {
                  context.pop();
                  context.pushNamed(
                    RoutesPath.resetPassword,
                    arguments: emailController.text,
                  );
                }
              },
            ),
            Gap(48.h),
            SvgPicture.asset("assets/svg/logo.svg"),
            Text(
              S.of(context).letsGetStarted,
              style: CustomTextStyle.font20BlackSemiBold,
            ),
            Gap(40.0.h),
            Text(
              S
                  .of(context)
                  .enterYourEmailAddressBelowToReceiveYourVerificationCode,
              style: CustomTextStyle.font14BlackRegular,
            ),
            Gap(16.h),
            KTextForm(
              controller: emailController,
              hintText: S.of(context).email,
              validator: (value) {
                return TextFormValidation.emailValidator(context, value: value);
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // if (form.currentState!.validate()) {
                  //   context.read<EmailForPassCubit>().emitEmailForPass(EmailOtpResetPassword(emailController.text));
                  // }
                  context.pushNamed(
                    RoutesPath.enterVerificationCode,
                    arguments: (emailController.text, false),
                  );
                },
                child: Text(S.of(context).sendCode),
              ),
            ),
            Gap(10.0.h),
          ],
        ),
      ),
    );
  }
}
