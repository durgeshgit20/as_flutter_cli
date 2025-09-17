
class {{appName.pascalCase()}}Exception implements Exception {
  const {{appName.pascalCase()}}Exception({
    required this.message,
  });

  final String message;

  @override
  String toString() => '$this - $message';
}