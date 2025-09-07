enum PrefixNamingStrategy {
  pascalCase,
  upperCase;

  String get label => switch (this) {
        pascalCase => 'Pascal Case',
        upperCase => 'Upper Case',
      };
}
