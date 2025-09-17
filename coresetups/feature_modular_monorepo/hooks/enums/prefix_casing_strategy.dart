enum PrefixCasingStrategy {
  upperCase,
  pascalCase;

  factory PrefixCasingStrategy.fromValue(String value) => values.firstWhere(
        (e) => e.name == value,
        orElse: () => pascalCase,
      );
}
