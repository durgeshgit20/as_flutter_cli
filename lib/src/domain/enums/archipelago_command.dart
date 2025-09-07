enum ArchipelagoCommand {
  initializeMonorepo,
  generateFeatureSkeleton,
  generateLocalization,
  generateUIKit,
  generateCubitSkeleton;

  String get label => switch (this) {
        initializeMonorepo => 'Initialize Monorepo',
        generateFeatureSkeleton => 'Generate Feature Skeleton',
        generateLocalization => 'Generate Localization Package',
        generateUIKit => 'Generate UI Kit Package',
        generateCubitSkeleton => 'Generate Cubit Skeleton',
      };
}
