//
//  RootViewController.m
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController {
	
}

@property (nonatomic, retain) NSArray *firstArray;

@property (nonatomic, retain) NSMutableArray *firstForTable;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityView;

@property (nonatomic, retain) NSMutableDictionary  *tempDictionary;
@property (nonatomic, retain) IBOutlet UIButton *btnGo;

@property (nonatomic, retain) NSIndexPath  *selectedIndex;
@property (nonatomic) BOOL isCall;
@property (nonatomic) BOOL isAvail;

@property (nonatomic, retain) NSIndexPath  *selectedIndexLevel1;
@property (nonatomic, retain) NSIndexPath  *selectedIndexLevel2;
@property (nonatomic, retain) NSIndexPath  *selectedIndexLevel3;


-(void)miniMizeFirstsRows:(NSArray*)ar;

@end
