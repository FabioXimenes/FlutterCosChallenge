import 'package:flutter/material.dart';
import 'package:flutter_cos_challenge/app/core/core_resources_startup.dart';
import 'package:flutter_cos_challenge/app/core/resources_startup/resources_startup.dart';
import 'package:flutter_cos_challenge/app/cos_challenge_app.dart';
import 'package:flutter_cos_challenge/app/features/authentication/authentication_resources_startup.dart';
import 'package:get_it/get_it.dart';

void main() async {
  for (final resource in Resources.resources) {
    await resource.init(GetIt.instance);
  }

  runApp(const CosChallengeApp());
}

class Resources {
  static final List<ResourcesStartup> resources = [
    CoreResourcesStartup(),
    AuthenticationResourcesStartup(),
  ];
}
