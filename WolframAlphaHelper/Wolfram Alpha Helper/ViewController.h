

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>{
    
}
@property (strong, nonatomic) IBOutlet UITextField *valueFild;
@property (strong, nonatomic) IBOutlet UIView *decisionButton;
- (IBAction)decisionAction:(id)sender;
- (IBAction)historiAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *resultTable;

@end

