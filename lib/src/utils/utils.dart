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
                      ########          #######  ##     ## ####  ######  ##    ## 
                      ##               ##     ## ##     ##  ##  ##    ## ##   ##  
                      ##               ##     ## ##     ##  ##  ##       ##  ##   
                      ######   ####### ##     ## ##     ##  ##  ##       #####    
                      ##               ##  ## ## ##     ##  ##  ##       ##  ##   
                      ##               ##    ##  ##     ##  ##  ##    ## ##   ##  
                      ##                ##### ##  #######  ####  ######  ##    ##    $reset



          $bold                        🏝  Flutter Starter Kit  🚀$reset

$cyan================================================================================$reset


        $bold             Welcome to FQuick - Your Flutter Monorepo Solution
                
                   $bold  $cyan"He who climbs the ladder must begin at the bottom!"$reset

                    $bold      $cyan"It’s a waste of life to be scared"$reset

                    $bold$cyan"I’m not number one in anything at this point in time. 
                 But that’s not enough of a reason to quit, nor is it an excuse."$reset
                        

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

                               $bold${cyan}Thank you for using FQuick! Happy coding! 🚀${reset}

$cyan================================================================================$reset
''');
}
