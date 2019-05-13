

#import "BGWolframAlphaHelper.h"
#import "ViewController.h"
#import "SVProgressHUD.h"
@import UIKit;

@interface BGWolframAlphaHelper()
@property (strong, nonatomic) NSXMLParser *parser;
@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) NSString *elementName;
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *msg;
@property (strong, nonatomic) NSNumber* positions;
@property (strong, nonatomic) NSString *titles;
@property (strong, nonatomic) NSString *imagesUrl;
@end

@implementation BGWolframAlphaHelper


- (instancetype)initWithData:(NSData *)data {
    if(self = [super init]) {
        self.parser = [[NSXMLParser alloc]initWithData:data];
        self.parser.delegate = self;
        [self.parser parse];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        // Инициализация self.
        self.images = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - convieniece

- (NSArray *)imagesFromHelper {
    NSLog(@"Изображений в классе: %lu", (unsigned long)[_images count]);
    return [NSArray arrayWithArray:_images];
}

- (UIImage *)imageFromURLString:(NSString *)url {
    NSURL *imageURL = [NSURL URLWithString:url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    return [UIImage imageWithData:imageData];
}

- (NSMutableArray *)images {
   // NSLog(@"--images");
    if(!_images) {
        _images = [[NSMutableArray alloc] init];
    }
    return _images;
}
/*
- (NSMutableDictionary *)code {
    NSLog(@"--NSMutableDictionary code");
    if(!_code) {
        _code = [[NSMutableDictionary alloc] init];
        NSLog(@"NSMutableDictionary code");
    }
    return _code;
}

- (NSMutableDictionary *)msg {
    NSLog(@"--NSMutableDictionary msg");
    if(!_msg) {
        _msg = [[NSMutableDictionary alloc] init];
        NSLog(@"NSMutableDictionary msg");
    }
    return _msg;
}
*/
- (void)performActionWithElement:(NSString *)element attributes:(NSDictionary *)attributes {
    //All different types of data. As an example, we will take all images from WA
    if([element isEqualToString:@"plaintext"]) {
        
    } else if([element isEqualToString:@"img"]) {
        NSString *imageURLString = [attributes valueForKey:@"src"];
     //   UIImage *image = [self imageFromURLString:imageURLString];
        [self.images addObject:imageURLString];
        NSLog(@"Изображение: %@", imageURLString);
    } else if([element isEqualToString:@"source"]) {
        
    } else if([element isEqualToString:@"pod"]) {
        _positions = [attributes valueForKey:@"position"];
        NSLog(@"\n\nНазвание - %@" , [attributes valueForKey:@"title"]);
        
    } else if([element isEqualToString:@"error"]) {
        
    }
    else if([element isEqualToString:@"code"]) {
     //   [_code addEntriesFromDictionary:attributes];
      //  NSLog(@"code - %@" , attributes);
    }
    else if([element isEqualToString:@"msg"]) {
    //    [_msg addEntriesFromDictionary:attributes];
     //   NSLog(@"msg - %@" , attributes);
        
    }
}

#pragma mark - XML Parser Delegate



- (void)parserDidStartDocument:(NSXMLParser *)parser {
    //here is where parsing begins, we will initialize some data structure to hold all the necessary data
   // NSLog(@"Parsing begins");
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    //here is where parsing ends, we'll send the info back to the caller
 //   NSLog(@"Parsing Ends");
    
    if([_msg length] != 0 && _code != 0) {
        [self displayMessage:@"Что-то пошло не так" msg:[NSString stringWithFormat:@"Ошибка:\n %@ \nКод:\n %@",_msg,_code]];
    }
}

- (void)parser:(NSXMLParser *)parser foundInternalEntityDeclarationWithName:(NSString *)name value:(NSString *)value {
  //  NSLog(@"foundInternalEntityDeclarationWithName: name: %@ , value: %@" , name, value);
}

- (void)parser:(NSXMLParser *)parser foundExternalEntityDeclarationWithName:(NSString *)name publicID:(NSString *)publicID systemID:(NSString *)systemID {
   // NSLog(@"foundExternalEntityDeclarationWithName: name: %@ , publicID: %@ , systemID: %@",name , publicID, systemID);
}

- (void)parser:(NSXMLParser *)parser foundNotationDeclarationWithName:(NSString *)name publicID:(NSString *)publicID systemID:(NSString *)systemID {
  //  NSLog(@"foundNotationDeclarationWithName: name: %@ , publicID: %@ , systemID: %@",name , publicID, systemID);
}

- (void)parser:(NSXMLParser *)parser foundUnparsedEntityDeclarationWithName:(NSString *)name publicID:(NSString *)publicID systemID:(NSString *)systemID notationName:(NSString *)notationName {
  //  NSLog(@"foundUnparsedEntityDeclarationWithName: name: %@ , publicID: %@ , systemID: %@ , notationName: %@",name , publicID, systemID, notationName);
}

- (void)parser:(NSXMLParser *)parser foundAttributeDeclarationWithName:(NSString *)attributeName forElement:(NSString *)elementName type:(NSString *)type defaultValue:(NSString *)defaultValue {
 //   NSLog(@"foundAttributeDeclarationWithName: attributeName: %@ , elementName: %@ , type: %@ , defaultValue: %@",attributeName , elementName, type, defaultValue);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
 //   NSLog(@"foundCharacters: %@" , string);
    if([string length] != 0){
        if([_elementName isEqualToString:@"code"]){
            _code = string;
         //   NSLog(@"Присвоил Коду - вывод: %@", _code);
        }
        else if([_elementName isEqualToString:@"msg"]){
            _msg = string;
          //  NSLog(@"Присвоил соообщение - вывод: %@", _msg);
        }
        else if([_elementName isEqualToString:@"plaintext"]){
           // NSLog(@"Присвоил plaintext - вывод: %@", string);
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndMappingPrefix:(NSString *)prefix {
 //   NSLog(@"didEndMappingPrefix: %@" , prefix);
}


- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    //an error occurred, lets raise an exception if this happens
  //  NSLog(@"Error: %@" , [parseError localizedDescription]);
}

- (void)parser:(NSXMLParser *)parser foundElementDeclarationWithName:(NSString *)elementName model:(NSString *)model {
  //  NSLog(@"--element Name: %@" , elementName);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
  //  NSLog(@"didStartElement Element Name: %@ , qName: %@ , attributes: %@" , elementName, qName, attributeDict);
    [self performActionWithElement:elementName attributes:attributeDict];
    
    _elementName = elementName;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    //отправляется при обнаружении конечного тега. Различные параметры поставляются как указано выше.
  //  NSLog(@"didEndElement Element Name: %@" , elementName);
    _elementName = @"";
    _positions = 0;
}

#pragma mark - making requests

+ (void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *))completionHandler {
    //init a session config object
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    //init a session object
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    //create a data task object to perform the downloading
 
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error) {
            //if an error occurred, log it
            NSLog(@"Error in downloadDataFromURL: %@\n Error - %@" , [error localizedDescription], error);
            NSLog(@"Ошибка в url - %@", url);
            [SVProgressHUD showErrorWithStatus:@"Ошибка"];
        } else {
            //no error occurred, check the HTTP status code
            NSInteger httpStatusCode = [(NSHTTPURLResponse *)response statusCode];
            //if its other than 200, log it
            if(httpStatusCode != 200) {
                NSLog(@"Http status code: %li" , (long)httpStatusCode);
            }
            else {
                NSLog(@"Вывод url: %@", url);
                NSLog(@"Вывод code: %ld", (long)httpStatusCode);
                NSLog(@"Вывод response: %@", response);
                NSLog(@"Вывод task: %@", task);
            }
            // Call the completion handler with the returned data on the main thread.
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completionHandler(data);
            }];
        }
    }];
    //makes the task start working for us
    [task resume];
}

-(void)displayMessage:(NSString*)title msg:(NSString*)msg
{

    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:title message:msg
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}

@end
