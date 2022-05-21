import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:slibro/application/res/palette.dart';
import 'package:slibro/presentation/screens/dashboard_page.dart';

import 'story_writing/story_length.dart';

class GreetScreen extends StatelessWidget {
  const GreetScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Palette.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Spacer(),
              Column(
                children: [
                  const Text(
                    'Hi',
                    style: TextStyle(
                      color: Palette.greyDark,
                      fontSize: 32,
                    ),
                  ),
                  Text(
                    user.name.split(' ').first,
                    style: const TextStyle(
                      color: Palette.blackLight,
                      fontSize: 36,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(
                    thickness: 2,
                    color: Palette.greyLight,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Slibro is a story writing platform that supports short and long format stories.',
                    style: TextStyle(
                      color: Palette.blackLight,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Spacer(),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DashboardPage(
                          user: user,
                        ),
                      ),
                    );
                  },
                  child: const Text('Continue to Dashboard'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.maxFinite,
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: Palette.blackLight,
                    side: const BorderSide(color: Palette.black, width: 2),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 14.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  onPressed: () async {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => StoryLengthScreen(
                          user: user,
                          isInitial: true,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Start Writing',
                    style: TextStyle(),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
