

#import <Foundation/Foundation.h>

#define kQueryURL @"https://api.wolframalpha.com/v2/query?" 
#define kAppID @"JGHHUQ-7L5JJEYR4R"
#warning set your own app id here.


@interface BGWolframAlphaHelper : NSObject <NSXMLParserDelegate>

- (NSArray *)imagesFromHelper;

- (instancetype)initWithData:(NSData *)data;

+ (void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *))completionHandler;


@end
