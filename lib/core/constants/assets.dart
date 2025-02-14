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
  scan('assets/images/scan.png'),
  gallery('assets/images/gallery.png'),
  files('assets/images/files.png'),
  nothing('assets/images/nothing.png'),

  /// Document info specific
  share('assets/images/share.png'),
  print('assets/images/print.png'),
  delete('assets/images/delete.png'),
  ;

  @override
  final String asset;

  const AppImageAssets(this.asset);

  @override
  Image get image => Image(image: AssetImage(asset));
}
