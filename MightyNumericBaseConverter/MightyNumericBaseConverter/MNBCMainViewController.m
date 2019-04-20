// из 8 не правильный ввод
// в 8 теряется дробь

#import "MNBCMainViewController.h"

#import "stdio.h"
#import "stdlib.h"
#import "string.h"
#import "math.h"


@interface MNBCMainViewController ()
@end


@interface NSString (NSStringWithOctal)   
    - (int) octalIntValue;
@end


@implementation NSString (NSStringWithOctal)
- (int) octalIntValue
{
    int iResult = 0, iBase = 1;
    char c;
    
    for(int i = (int)[self length] - 1; i >= 0; i--)
    {
        c = [self characterAtIndex:i];
        /*     if((c<'0')||(c>'7')) //Если пользователь не использует ввод в соответствующем интервале для восьмеричной базы, приложение выскакивает окно с ошибкой.
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка ввода"
                                                                                      message:@"Пожалуйста, используйте соответствующие цифры!"
                                                                                     delegate:nil
                                                                            cancelButtonTitle:@"GOT IT!"
                                                                            otherButtonTitles:nil];
            [alert show]; return 0;
        }*/
        iResult += (c - '0') * iBase;
        iBase *= 8;
    }
    return iResult;
}
@end


@implementation MNBCMainViewController

NSMutableArray *myArray;



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return 0;
}
- (IBAction)histore:(id)sender {
    NSString *message;
    
    message = [NSString stringWithFormat:@"%@", myArray];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"История"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"Ок"
                                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)convert:(id)sender {
    
    int number, counter, b, periods = 0;
    static float sonuc = 0;
    int minus = 0 - 1;
    
    switch (segmentedcontrol1.selectedSegmentIndex) { //Вверхняя панель
            
        case 0:
        {
            NSString *numero = textField.text;
            int length = (int)[numero length];
            
            for (counter = 0; counter < length; counter ++) {
                
                if ([numero characterAtIndex:counter] != '1' && [numero characterAtIndex:counter] != '0' && [numero characterAtIndex:counter] != '.') {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка ввода"
                                                                   message:@"Пожалуйста, используйте соответствующие цифры!"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ок!"
                                                          otherButtonTitles:nil];
                                                                    [alert show];
                    break;
                    
                }
            }
            
            for (counter = 0; counter < length; counter ++) {
                if ([numero characterAtIndex:counter] == '.') {
                    periods = counter + 1;
                    break;
                }
            }
            
            if (periods > 1) {
                
                for (counter = 0; counter < (periods-1); counter ++) {
                    if ([numero characterAtIndex:counter] == '1') {
                        sonuc = sonuc + pow(2.0, (double)(periods-2-counter));
                    } else {
                        continue;
                    }
                }
                
                for (counter = periods; counter < length; counter ++) {

                    if ([numero characterAtIndex:counter] == '1') {
                        sonuc = sonuc + pow(2.0, (double)(periods-1-counter));
                        
                    } else if ([numero characterAtIndex:counter] == '.') {
                        periods = 0;
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка ввода"
                                                                        message:@"Пожалуйста, не используйте два периода!"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ок!"
                                                              otherButtonTitles:nil];
                        [alert show];
                        sonuc = 0;
                        numero = @"0";
                    }
                    else {
                        continue;
                    }
                }
                
            } else if (periods == 1) {
                
                periods = 0;
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка ввода"
                                                                message:@"Ты начал не с числа."
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ок!"
                                                      otherButtonTitles:nil];
                [alert show];
                sonuc = 0;
                numero = @"0";
                
            } else {
                
                for (counter = 0; counter < length; counter ++) {
                    if ([numero characterAtIndex:counter] == '1') {
                        sonuc = sonuc + pow(2.0, (double)(length-1-counter));
                    } else {
                        continue;
                    }
                }
            }

            switch (segmentedcontrol2.selectedSegmentIndex) {
                    
                case 0:
                    
                    label.text = textField.text;
                    
                    break;
                    
                case 2:
                    
                    if (periods>1) {
                        label.text = [NSString stringWithFormat:@"%.3f", sonuc];
                    } else {
                        label.text = [NSString stringWithFormat:@"%d", (int)sonuc];
                    }
                    
                    break;
                    
                case 1: // вот тут ошибка
                {
                    label.text = [NSString stringWithFormat:@"%o", (int)sonuc];
                    break;
                }
                case 3:
                    
                    label.text = [NSString stringWithFormat:@"%x", (int)sonuc];
                    
                    break;
                    
                default:
                    break;
            }
            
            break;
        }
        case 2: //FROM 10
            
            sonuc = [textField.text floatValue];
            
            float floater;
            number = (int)sonuc;
            floater = sonuc - number;
            
            
            switch (segmentedcontrol2.selectedSegmentIndex) {
                    
                case 0:
                {
                    if (sonuc != 0) {
                        static int maxnumber;
                        maxnumber = log2(number); //ищем максимальное кол чисел
                        int i, y, x;
                        char output[1024];
                        output[maxnumber+1] = '\0';
                        
                        for(i = maxnumber; i >= 0; i--)
                        {
                            x = number/pow(2, i);
                            if (x < 1) {
                                output[maxnumber-i] = '0';
                            } else {
                                output[maxnumber-i] = '1';
                                y = pow(2, i);
                                number %= y;                             }
                        }
                        if (floater > 0) {
                            output[maxnumber+1] = '.';
                            int tugrul = 0;
                            
                            for (tugrul = minus; floater > 0; tugrul --) {
                                if (floater < pow(2, tugrul)) {
                                    output[maxnumber + 1 - tugrul] = '0';
                                } else {
                                    output[maxnumber + 1 - tugrul] = '1';
                                    floater -= pow(2, tugrul);
                                }
                            }
                            
                            output[maxnumber + 1 - tugrul] = '\0';
                        }
                        
                        label.text = [NSString stringWithFormat:@"%s", output];
                    } else {
                        label.text = [NSString stringWithFormat:@"%d", 0];
                    }
                    break;
                }
                case 2:
                {
                    label.text = textField.text;
                    
                    break;
                }
                case 1:
                {
                    label.text = [NSString stringWithFormat:@"%o", number];
                    break;
                }
                case 3:
                {
                    label.text = [NSString stringWithFormat:@"%x", number];
                    break;
                }
                default:
                    break;
            }
            
            break;
            
        case 1: //FROM 8
        {
            number = [textField.text octalIntValue];
            
            switch (segmentedcontrol2.selectedSegmentIndex) {
                case 0:
                {
                    if (number!=0) {
                        static int maxnumber;
                        maxnumber = log2(number);
                        int i, y, x;
                        char output[1024];
                        output[maxnumber+1] = '\0';
                        for(i = maxnumber; i >= 0; i --)
                        {
                            x = number/pow(2, i);
                            if (x < 1) {
                                output[maxnumber-i] = '0';
                            } else {
                                output[maxnumber-i] = '1';
                                y = pow(2, i);
                                number %= y;
                            }
                        }
                        label.text = [NSString stringWithFormat:@"%s", output];
                    } else {
                        label.text = [NSString stringWithFormat:@"%d", 0];
                    }
                    break;
                }
                case 2:
                {
                    label.text = [NSString stringWithFormat:@"%d", number];
                    break;
                }
                case 1:
                {
                    label.text = textField.text;
                    break;
                }
                case 3:
                {
                    label.text = [NSString stringWithFormat:@"%x", number];
                    break;
                }
                default:
                    break;
            }
            
            break;
        }
        case 3:
        {
            
            NSString *hex = textField.text;
            NSUInteger hexAsInt;
            [[NSScanner scannerWithString:hex] scanHexInt:&hexAsInt];
            if ([hex length] == 0) {
                hexAsInt = 0;
            }
            NSCharacterSet* notDigits = [[NSCharacterSet
                                          characterSetWithCharactersInString:@"0123456789ABCDEFabcdef"] invertedSet];
            if ([hex rangeOfCharacterFromSet:notDigits].location == NSNotFound)
            {
                
                // Hexadecimal to Decimal
                NSInteger temp = 0;
                for (long i = hex.length - 1; i >= 0; i--)
                {
                    int charAtIndex;
                    char c = [hex characterAtIndex:(i)];
                    if (c == 'A' || c == 'a') charAtIndex = 10;
                    else if (c == 'B' || c == 'b') charAtIndex = 11;
                    else if (c == 'C' || c == 'c') charAtIndex = 12;
                    else if (c == 'D' || c == 'd') charAtIndex = 13;
                    else if (c == 'E' || c == 'e') charAtIndex = 14;
                    else if (c == 'F' || c == 'f') charAtIndex = 15;
                    else charAtIndex = c - '0';
                    
                    temp += (charAtIndex) * pow(16, hex.length - 1 - i);
                }
                
                switch (segmentedcontrol2.selectedSegmentIndex) {
                    case 0:
                    {
                       // label.text = [self decimalToBinary:temp];
                        label.text = [self decToBinary:temp];
                        break;
                    }
                    case 1:
                    {
                        label.text = [NSString stringWithFormat:@"%o", (int)hexAsInt];
                        break;
                    }
                    case 2:
                    {
                        label.text = [@(temp) stringValue];
                        break;
                    }
                    case 3:
                    {
                        label.text = hex;
                        break;
                    }
                    default:
                    {
                        break;
                    }
                        
                }
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка ввода"
                                                                message:@"Неверный шестнадцатеричный ввод!"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ок!"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            
            break;
        }
            
        default:
            break;
    }
    [myArray addObject:[NSString stringWithFormat:@"%@ -> %@",textField.text , label.text]];
    
    number = 0; counter = 0; b = 0; periods = 0; sonuc = 0;
}


-(NSString*)decimalToBinary:(NSInteger)decimal
{
    float decimalCopy = (float)decimal;
    float temp;
    NSMutableString *hexString = [NSMutableString stringWithString:@""];
    
    while (decimalCopy > 0)
    {
        temp = (float)decimalCopy / 2.0f;
        
        float remainder = temp - (int)temp;
        
        // Store the floor of temp in decimalCopy.
        decimalCopy = temp - remainder;
        
        // Multiply by 16 to get true remainder.
        remainder *= 2.0f;
        
        char c;
        if (remainder == 0) c = '0';
        else c = '1';
        
        [hexString insertString:[NSString stringWithFormat:@"%c", c] atIndex:0];
    }
    
    return hexString;
}

-(NSString *)decToBinary:(NSUInteger)decInt
{
    NSLog(@"Я тут");
    NSString *string = @"" ;
    NSUInteger x = decInt ;
    do {
        string = [[NSString stringWithFormat: @"%lu", x&1] stringByAppendingString:string];
    } while (x >>= 1);
    return string;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    myArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
/*
#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(MNBCFlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}
*/
@end

