//


#import <CoreData/CoreData.h>

@interface MNBCMainViewController : UIViewController <UITextFieldDelegate>

{
    
    IBOutlet UITextField *textField;
    IBOutlet UILabel *label;
    IBOutlet UISegmentedControl *segmentedcontrol1;
    IBOutlet UISegmentedControl *segmentedcontrol2;
}


- (IBAction)histore:(id)sender;
- (IBAction)convert:(id)sender;


@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
