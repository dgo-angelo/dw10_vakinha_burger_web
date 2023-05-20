import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:validatorless/validatorless.dart';

import '../../core/ui/helpers/loader.dart';
import '../../core/ui/helpers/messages.dart';
import '../../core/ui/helpers/size_extensions.dart';
import '../../core/ui/styles/app_colors.dart';
import '../../core/ui/styles/app_text_styles.dart';
import 'login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with Loader, Messages {
  final _emailEC =
      TextEditingController(text: 'rodrigorahman@academiadoflutter.com.br');
  final _passwordEC = TextEditingController(text: '123123');
  final _formKey = GlobalKey<FormState>();
  final controller = Modular.get<LoginController>();
  late final ReactionDisposer statusReactionDisposer;

  @override
  void initState() {
    statusReactionDisposer = reaction((_) => controller.loginStatus, (status) {
      switch (status) {
        case LoginStateStatus.initial:
          break;
        case LoginStateStatus.loading:
          showLoader();
          break;
        case LoginStateStatus.success:
          hideLoader();
          Modular.to.navigate('/');
          break;
        case LoginStateStatus.error:
          hideLoader();
          showError(controller.errorMessage ?? 'Falha ao efetuar login');
          break;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailEC.dispose();
    _passwordEC.dispose();
    statusReactionDisposer();
    super.dispose();
  }

  void _formSubmit() {
    final formValid = _formKey.currentState?.validate() ?? false;

    if (formValid) {
      controller.login(
        _emailEC.text,
        _passwordEC.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenShortestSide = context.screenShortestSide;
    final screenWidth = context.screenWidth;
    return Scaffold(
      backgroundColor: context.colors.black,
      body: Form(
        key: _formKey,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: screenShortestSide * .5,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/lanche.png'),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: context.percentHeight(.1),
              ),
              width: screenShortestSide * .5,
              child: Image.asset('assets/images/logo.png'),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: context.percentWidth(
                    screenWidth < 1300 ? .7 : .3,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FractionallySizedBox(
                          widthFactor: .3,
                          child: Image.asset('assets/images/logo.png'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Login',
                            style: context.textStyles.textTitle,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _emailEC,
                          onFieldSubmitted: (_) => _formSubmit(),
                          decoration: const InputDecoration(
                            label: Text('E-mail'),
                          ),
                          validator: Validatorless.multiple(
                            [
                              Validatorless.email('E-mail inválido'),
                              Validatorless.required('E-mail obrigatório'),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          obscureText: true,
                          controller: _passwordEC,
                          onFieldSubmitted: (_) => _formSubmit(),
                          decoration: const InputDecoration(
                            label: Text('Senha'),
                          ),
                          validator:
                              Validatorless.required('Senha obrigatória'),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              _formSubmit();
                            },
                            child: const Text('Entrar'),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
