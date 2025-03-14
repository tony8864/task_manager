import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/shared/widgets/primary_button.dart';
import 'package:task_manager/view/onboarding/widgets/title_widget.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const Spacer(flex: 2,),
            TitleWidget(),
            const Spacer(flex: 1,),
            PrimaryButton(
              text: 'Register',
              textColor: Colors.black,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              onPressed: () {
                context.go('/register');
              },
            ),
            const SizedBox(height: 40,),
            PrimaryButton(
              text: 'Log in',
              textColor: Colors.white,
              borderColor: Colors.white,
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () {
                context.go('/login');
              },
            ),
            const Spacer(flex: 3,),
          ],
        ),
      ),
    );
  }
}
