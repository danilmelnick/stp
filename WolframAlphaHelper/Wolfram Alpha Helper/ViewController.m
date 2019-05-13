

#import "ViewController.h"
#import "BGWolframAlphaHelper.h"
#import "TableViewCell.h"
#import "SVProgressHUD.h"

@import UIKit;

@interface ViewController ()
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *imagesHelper;
@end

@implementation ViewController


//Simple usage of the WA xml parsing. Grabbing the images from the WAHelper and displaying them.

static int heightForRowAt;
NSMutableArray *myArray;

- (void)viewDidLoad {
    [super viewDidLoad];
  //  [self setUpScrollView];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    _valueFild.delegate = self;
    heightForRowAt = 80;
    
//self.resultTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];

    _resultTable.delegate = self;
    _resultTable.dataSource = self;
    
    _imagesHelper = [[NSMutableArray alloc] init];
    myArray = [[NSMutableArray alloc] init];
   // [self.view addSubview:self.resultTable];
    
}
- (void)viewDidAppear {

}



- (void)makeRequestWithQuery:(NSURL *)query {
    
    [BGWolframAlphaHelper downloadDataFromURL:query withCompletionHandler:^(NSData *data) {
        if(data) {
            NSLog(@"Зашел сюда");
            BGWolframAlphaHelper *helper = [[BGWolframAlphaHelper alloc]initWithData:data];
       //     [self displayImages:[helper imagesFromHelper]];
            [_imagesHelper addObjectsFromArray:[helper imagesFromHelper]];
            NSLog(@"Изобрадения вывод: %@", _imagesHelper);
            NSLog(@"Окончил тут");
            [self.resultTable reloadData];
            [SVProgressHUD dismiss];
        } else {
            NSLog(@"data is nil");
        }
    }];
}

#pragma mark - convienience

- (void)displayImages:(NSArray *)images {
    CGFloat height = 20;
    NSLog(@"-- Количество изображений: %lu", (unsigned long)[images count]);
    NSData *data;
    for(NSString *img in images) {
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:img]];
        CGRect rect = CGRectMake(self.view.frame.size.width/2, height ,100, 100);
        height += 100;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:rect];
      //  imageView.image = [self imageWithImage:img scaledToSize:CGSizeMake(150, 30)];
        imageView.image = [UIImage imageWithData:data];
        imageView.contentMode = UIViewContentModeCenter;
        
        [self.view addSubview:imageView];
        NSLog(@"Вывожу изображения");
     //   [self.scrollView addSubview:imageView];
    }
}

- (void)setUpScrollView {
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 560, 10000)];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 70);
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:self.scrollView];
}

//shout out to Brad Larson on SO
- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (IBAction)decisionAction:(id)sender {
    
    if([_valueFild.text length] == 0) return;
    [myArray addObject:[NSString stringWithFormat:@"%@",_valueFild.text]];
    [_valueFild resignFirstResponder];
    [_imagesHelper removeAllObjects];
    [SVProgressHUD showWithStatus:@"Загрузка решения"];
    //example of pi
    NSString *queryExample = _valueFild.text;
    NSString *urlString = [NSString stringWithFormat:@"%@input=%@&appid=%@&output=xml" , kQueryURL , queryExample , kAppID];
    //input=log(4)&output=xml
    NSLog(@"url - %@ \n text - %@",[NSURL URLWithString:urlString], queryExample);
    [self makeRequestWithQuery:[NSURL URLWithString:urlString]];
    [_resultTable reloadData];
}

- (IBAction)historiAction:(id)sender {
    
    NSString *message = @"-";
    
    for (NSString *item in myArray) {
        
        NSLog(@"%@", item);
        message = [NSString stringWithFormat:@"%@\n%@", message, item];
        //message = [message stringByAppendingString:[NSString stringWithFormat:@"- %@/n",item]];
    }
    
 //   message = [NSString stringWithFormat:@"%@", myArray];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"История"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"Ок"
                                          otherButtonTitles:nil];
    [alert show];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  //  NSLog(@"ТУТ - heightForRowAtIndexPath:");
    return 80;
    /*NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:[_imagesHelper objectAtIndex:indexPath.row]]];
    return [UIImage imageWithData:data].size.width;*/
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Количество изображений: %lu", (unsigned long)[_imagesHelper count]);
    return [_imagesHelper count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSLog(@"ТУТ - cellForRowAtIndexPath: section %ld and row %ld", (long)indexPath.section, (long)indexPath.row);
    
    return [self TableViewCellAt:tableView cellForRowAtIndexPath:indexPath];

}

-(TableViewCell *)TableViewCellAt:(UITableView *)tableView
                   cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellName = [NSString stringWithFormat:@"%@", [TableViewCell class]];
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName forIndexPath:indexPath];
    
    if(!cell){
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
 //       NSLog(@"Создали");
    } //else NSLog(@"Переиспользуем");
 //   NSLog(@"Смотрим изображение по индексу %ld - %@",(long)indexPath.row ,[_imagesHelper objectAtIndex:indexPath.row]);
    //ЗАПОЛНЯЕМ
 //   NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www4d.wolframalpha.com/Calculate/MSP/MSP1337109082hh5b7385i600005663e4d3f67h9265?MSPStoreType=image/gif&s=41"]];
    NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:[_imagesHelper objectAtIndex:indexPath.row]]];
    cell.imagesresult.image = [UIImage imageWithData:data];
    cell.imagesresult.contentMode = UIViewContentModeScaleAspectFit;
  //  NSLog(@" размер изображения %f %f",[UIImage imageWithData:data].size.height, [UIImage imageWithData:data].size.width);
    heightForRowAt = [UIImage imageWithData:data].size.width;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
