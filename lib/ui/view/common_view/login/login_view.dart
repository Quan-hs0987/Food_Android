import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_order_food/core/service/get_navigation.dart';
import 'package:project_order_food/locator.dart';
import 'package:project_order_food/ui/config/app_style.dart';
import 'package:project_order_food/ui/router.dart';
import 'package:project_order_food/ui/shared/app_color.dart';
import 'package:project_order_food/ui/shared/ui_helpers.dart';
import 'package:project_order_food/ui/view/common_view/login/controllers/login_controller.dart';
import 'package:project_order_food/ui/view/common_view/register/register_view.dart';
import 'package:project_order_food/ui/widget/a_button.dart';
import 'package:project_order_food/ui/widget/form/a_text_form_field.dart';
import 'package:project_order_food/core/extension/validation.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final LoginController controller = LoginController();

  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => locator<GetNavigation>()
            .replaceTo(RoutePaths.loadingView, arguments: RoutePaths.uHomeView),
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Form(
              key: _key,
              child: Column(
                children: [
                  AText.body('ShopeeFood'),
                  UIHelper.verticalSpaceLarge(),
                  ATextFormField(
                    hintText: 'Mời Bạn Nhập Email',
                    label: 'Email',
                    validator: (v) => v!.isEmpty || !v.isValidEmail
                        ? 'Email không hợp lệ'
                        : null,
                    onSaved: (v) => controller.userName = v,
                  ),
                  UIHelper.verticalSpaceMedium(),
                  ATextFormField(
                    hintText: 'Nhập Mật Khẩu',
                    label: 'Password',
                    obscureText: true,
                    onSaved: (v) => controller.password = v,
                  ),
                  UIHelper.verticalSpaceMedium(),
                  AButton.text(
                    'Đăng nhập',
                    isExpanded: false,
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        _key.currentState!.save();
                        controller.signIn(
                          context,
                        );
                      }
                    },
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 50),
                  ),
                ],
              ),
            ),
            const Spacer()
          ],
        ),
      ),
      bottomSheet: Padding(
        padding:
            const EdgeInsets.only(bottom: 6, top: 6, left: 112, right: 112),
        child: AButton.text(
          'Đăng ký',
          isExpanded: true,
          color: AColor.textGreen,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => RegisterView()));
          },
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 50),
        ),
      ),
    );
  }
}
