// ignore_for_file: unnecessary_string_escapes, avoid_print

void printWelcomeScreen() {
  // ANSI color codes
  const blue = '\x1B[34m';
  const cyan = '\x1B[36m';
  // const green = '\x1B[32m';
  const reset = '\x1B[0m';
  const bold = '\x1B[1m';

  print('''
$blue                                  
    █████  ██████   ██████ ██   ██ ██ ██████  ███████ ██       █████   ██████   ██████  
   ██   ██ ██   ██ ██      ██   ██ ██ ██   ██ ██      ██      ██   ██ ██       ██    ██ 
   ███████ ██████  ██      ███████ ██ ██████  █████   ██      ███████ ██   ███ ██    ██ 
   ██   ██ ██   ██ ██      ██   ██ ██ ██      ██      ██      ██   ██ ██    ██ ██    ██ 
   ██   ██ ██   ██  ██████ ██   ██ ██ ██      ███████ ███████ ██   ██  ██████   ██████         $reset

$bold                        🏝  Flutter Starter Kit  🚀$reset

$cyan================================================================================$reset

$bold             Welcome to Archipelago - Your Flutter Monorepo Solution
                
           $cyan"Like islands connected by water, we connect your packages"$reset

$cyan================================================================================$reset
''');
}

void printFooter() {
  // ANSI color codes
  // const blue = '\x1B[34m';
  const cyan = '\x1B[36m';
  // const green = '\x1B[32m';
  const reset = '\x1B[0m';
  const bold = '\x1B[1m';
  print('''
$cyan================================================================================$reset

$bold${cyan}For documentation and guides, visit: ${reset}Coming Soon
$bold${cyan}Need help? Join our Discord: ${reset}https://discord.gg/2gJes2Xcfx

$cyan================================================================================$reset

$bold             "The whole is greater than the sum of its parts" 
                          - Aristotle$reset

$cyan================================================================================$reset
''');
}
