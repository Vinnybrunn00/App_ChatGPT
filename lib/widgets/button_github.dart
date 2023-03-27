import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/api_consts.dart';

class ButtonGitHub extends StatefulWidget {
  const ButtonGitHub({Key? key}) : super(key: key);

  @override
  State<ButtonGitHub> createState() => _ButtonGitHubState();
}

class _ButtonGitHubState extends State<ButtonGitHub> {
  Future<void> _launchUrl() async {
    if (!await launchUrl(
      Uri.parse(REPO_URL),
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $_launchUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(1),
        margin: const EdgeInsets.only(bottom: 70),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 0, 177, 129),
            borderRadius: BorderRadius.circular(50)),
        child: IconButton(
          splashRadius: 31,
          splashColor: const Color.fromARGB(255, 255, 0, 160),
          icon: Image.asset('assets/images/github.png'),
          onPressed: () {
            try {
              _launchUrl();
            } catch (e) {
              print('error $e');
            }
          },
        ),
      ),
    );
  }
}
