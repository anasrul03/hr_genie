import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_genie/Components/customTextField.dart';
import 'package:hr_genie/cubit/auth_cubit/auth_cubit.dart';
import 'package:hr_genie/cubit/auth_cubit/auth_state.dart';

class CustomFormState extends StatefulWidget {
  const CustomFormState({super.key});

  @override
  State<CustomFormState> createState() => _CustomFormStateState();
}

class _CustomFormStateState extends State<CustomFormState> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool isObscure = true;
  bool _rememberMe = false;
  bool isValid = false;
  @override
  void initState() {
    context.read<AuthCubit>().loadUserEmailPassword();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.error) {
        } else if (state.status == AuthStatus.initial) {
          setState(() {
            _emailController.text = state.email;
            _passwordController.text = state.password;
          });

          print(_emailController.text);
          print(_passwordController.text);
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset("assets/logo.jpeg"),
              CustomTextField(
                hintText: "Your Working email",
                icon: const Icon(Icons.email_sharp),
                onchanged: (value) {
                  context.read<AuthCubit>().emailChanged(value);
                },
                errorStyle: state.validEmail
                    ? null
                    : const TextStyle(color: Colors.red),
                errorText: state.validEmail ? null : "Your input is not valid",
              ),
              PasswordField(
                obscurePassword: isObscure,
                onpress: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
                onchanged: (value) {
                  context.read<AuthCubit>().passwordChanged(value);
                },
                errorStyle:
                    state.validPass ? null : const TextStyle(color: Colors.red),
                errorText:
                    state.validPass ? null : "Your password is not valid!",
                hintText: "Password",
              ),
              CheckboxListTile(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = !_rememberMe;
                  });
                },
                title: const Text("Remember me"),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: const EdgeInsets.fromLTRB(10, 0, 2, 0),
                splashRadius: 20.0,
                enableFeedback: true,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 200, 0, 40),
                height: 46,
                width: 300,
                child: ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)))),
                    onPressed: state.isNotNull
                        ? () {
                            context.read<AuthCubit>().signIn(state.email,
                                state.password, context, _rememberMe);
                          }
                        : null,
                    child: const Text("Login")),
              )
            ],
          )),
        );
      },
    );
  }
}