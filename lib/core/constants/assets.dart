import 'package:flutter/material.dart';

abstract class ImageAssets {
  final String asset;

  ImageAssets(this.asset);

  Image get image => Image(image: AssetImage(asset));
}

enum AppImageAssets implements ImageAssets {
  /// Onboarding specifics
  onboarding1('assets/onboarding/onboarding1.png'),
  onboarding2('assets/onboarding/onboarding2.png'),

  /// Subacription specifics
  adFreeExperinece('assets/images/ad_free_experiece.png'),
  documentScanner('assets/images/document_scanner.png'),
  unlimitedSignature('assets/images/unlimited_signature.png'),

  /// Documents list specific

  /// Document specific
  ;

  @override
  final String asset;

  const AppImageAssets(this.asset);

  @override
  Image get image => Image(image: AssetImage(asset));
}
