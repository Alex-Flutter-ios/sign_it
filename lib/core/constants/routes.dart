enum Routes {
  splash,
  onboarding,
  subscription,
  documents,
  documentInfo,
  paywallA,
  paywallB,
}

extension RoutesExtension on Routes {
  String get name {
    switch (this) {
      case Routes.splash:
        return '/';
      case Routes.onboarding:
        return '/onboarding';
      case Routes.subscription:
        return '/subscription';
      case Routes.documents:
        return '/documents';
      case Routes.documentInfo:
        return '/documentInfo';
      case Routes.paywallA:
        return '/paywallA';
      case Routes.paywallB:
        return '/paywallB';
    }
  }
}
