//
//  RootViewController.m
//

#import "RootViewController.h"
#import "EventHub-Swift.h"
#import "Reachability.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "CategoryCell.h"

@interface RootViewController ()

@property(nonatomic, strong) Reachability *internetReachability;

@end

@implementation RootViewController

@synthesize firstArray;
@synthesize firstForTable;
@synthesize activityView, isCall, isAvail, btnGo;
@synthesize selectedIndex, selectedIndexLevel1, selectedIndexLevel2, selectedIndexLevel3;

- (void)viewDidLoad
{
	[super viewDidLoad];
    self.isCall = YES;
    self.isAvail = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:Nil];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
}

/*----------------------------------------------------
 * Function Name : updateInterfaceWithReachability
 * Function Param : Reachability
 * Function Return Type: -
 * Function Purpose: check network connection.
 ------------------------------------------------------*/

-(void)updateInterfaceWithReachability:(Reachability *)reachability
{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    BOOL connReq = [reachability connectionRequired];
    
    NetworkUnRechableViewController *network = [self.storyboard instantiateViewControllerWithIdentifier:@"NetworkUnRechableViewController"];
    
    switch (netStatus)
    {
        case NotReachable:

            [self.view addSubview:[network view]];
            [self addChildViewController:network];
            [self.view endEditing:YES];
            self.view.alpha = 1;
            self.navigationController.navigationBar.userInteractionEnabled = NO;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.tableView setScrollEnabled:NO];
            connReq = NO;
            break;
            
        case ReachableViaWiFi:
            self.navigationController.navigationBar.userInteractionEnabled = YES;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            if (self.isCall == YES)
            {
                [self getAllCategory];
                self.firstForTable=[[NSMutableArray alloc] init];
                self.isCall = NO;
            }
            [self.tableView setScrollEnabled:YES];
            break;
            
        case ReachableViaWWAN:
            self.navigationController.navigationBar.userInteractionEnabled = YES;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            if (self.isCall == YES)
            {
                [self getAllCategory];
                self.firstForTable=[[NSMutableArray alloc] init];
                self.isCall = NO;
            }
            [self.tableView setScrollEnabled:YES];
            break;
            
        default:
            self.navigationController.navigationBar.userInteractionEnabled = YES;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

            break;
    }
}

-(void)reachabilityChanged:(NSNotification *)sender
{
    Reachability *curReach = sender.object;
    [self updateInterfaceWithReachability:curReach];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int rows = 0;
    switch (section) {
        case 0:
            rows = [self.firstForTable count];
            break;
    }
    return rows;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    
    
    static NSString *CellIdentifier = @"Cell";
    
    CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[CategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }

    if(indexPath.section==0)
    {
        
        cell.lblName.text = [[self.firstForTable objectAtIndex:indexPath.row] valueForKey:@"name"];
        [cell.btnGo addTarget:self action:@selector(btnGoClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnGo.tag = indexPath.row;
        
        if([[[self.firstForTable objectAtIndex:indexPath.row] valueForKey:@"level"] intValue] == 1)
        {
            cell.lblName.frame = CGRectMake(15, 0, cell.lblName.frame.size.width, cell.frame.size.height);
            if(self.selectedIndexLevel1 == indexPath)
            {
                cell.backgroundColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0];
                cell.lblName.textColor = [UIColor whiteColor];
                [cell.btnGo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                cell.btnGo.layer.borderColor = [UIColor whiteColor].CGColor;
            }
            else
            {
                cell.backgroundColor = [UIColor clearColor];
                cell.lblName.textColor = [UIColor blackColor];
                [cell.btnGo setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                cell.btnGo.layer.borderColor = [UIColor grayColor].CGColor;
            }
        }
        else if([[[self.firstForTable objectAtIndex:indexPath.row] valueForKey:@"level"] intValue] == 2)
        {
            cell.lblName.frame = CGRectMake(25, 0, cell.lblName.frame.size.width, cell.frame.size.height);
            if(self.selectedIndexLevel2 == indexPath)
            {
                cell.backgroundColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
                cell.lblName.textColor = [UIColor whiteColor];
                [cell.btnGo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                cell.btnGo.layer.borderColor = [UIColor whiteColor].CGColor;
            }
            else
            {
                cell.backgroundColor = [UIColor clearColor];
                cell.lblName.textColor = [UIColor blackColor];
                [cell.btnGo setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                cell.btnGo.layer.borderColor = [UIColor grayColor].CGColor;
            }
        }
        else if([[[self.firstForTable objectAtIndex:indexPath.row] valueForKey:@"level"] intValue] == 3)
        {
            cell.lblName.frame = CGRectMake(35, 0, cell.lblName.frame.size.width, cell.frame.size.height);
            if(self.selectedIndexLevel3 == indexPath)
            {
                cell.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
                cell.lblName.textColor = [UIColor whiteColor];
                [cell.btnGo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                cell.btnGo.layer.borderColor = [UIColor whiteColor].CGColor;
            }
            else
            {
                cell.backgroundColor = [UIColor clearColor];
                cell.lblName.textColor = [UIColor blackColor];
                [cell.btnGo setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                cell.btnGo.layer.borderColor = [UIColor grayColor].CGColor;
            }
        }
        else
        {
            cell.lblName.frame = CGRectMake(15, 0, cell.lblName.frame.size.width, cell.frame.size.height);
            if(self.selectedIndexLevel1 == indexPath)
            {
                cell.backgroundColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0];
                cell.lblName.textColor = [UIColor whiteColor];
                [cell.btnGo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                cell.btnGo.layer.borderColor = [UIColor whiteColor].CGColor;
            }
            else
            {
                cell.backgroundColor = [UIColor clearColor];
                cell.lblName.textColor = [UIColor blackColor];
                [cell.btnGo setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                cell.btnGo.layer.borderColor = [UIColor grayColor].CGColor;
            }
        }
        if([[[self.firstForTable objectAtIndex:indexPath.row] valueForKey:@"items"] count] > 0)
        {
            cell.btnGo.hidden = NO;
            cell.btnGo.layer.borderWidth = 1;
            cell.btnGo.layer.cornerRadius = 5;
            cell.lblName.text = [NSString stringWithFormat:@"%@ (%lu)",cell.lblName.text, (unsigned long)[[[self.firstForTable objectAtIndex:indexPath.row] valueForKey:@"items"] count]];
        }
        else{
            cell.btnGo.hidden = YES;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath;

    if (indexPath.section==0)
    {
        NSDictionary *d=[self.firstForTable objectAtIndex:indexPath.row];
        
        if ([[d valueForKey:@"level"] isEqualToString:@"1"])
        {
            self.selectedIndexLevel1 = indexPath;
            self.selectedIndexLevel2 = nil;
            self.selectedIndexLevel3 = nil;
        }
        else if ([[d valueForKey:@"level"] isEqualToString:@"2"])
        {
            self.selectedIndexLevel2 = indexPath;
            self.selectedIndexLevel3 = nil;
        }
        else if ([[d valueForKey:@"level"] isEqualToString:@"3"])
        {
            self.selectedIndexLevel3 = indexPath;
        }
        else
        {
            self.selectedIndexLevel1 = indexPath;
            self.selectedIndexLevel2 = nil;
            self.selectedIndexLevel3 = nil;
        }

        if([d valueForKey:@"items"] && [[d valueForKey:@"items"] count] > 0)
        {
            NSDictionary *ar1=[d valueForKey:@"items"];
            NSMutableArray *ar = [[NSMutableArray alloc] init];
            NSMutableArray *arrKeys = [[NSMutableArray alloc] initWithArray:[ar1 allKeys]];
            for (int p = 0; p < arrKeys.count; p++) {
                [ar addObject:[ar1 valueForKey:[arrKeys objectAtIndex:p]]];
            }
            BOOL isAlreadyInserted = NO;
            
            for(NSDictionary *dInner in ar )
            {
                NSInteger index=[self.firstForTable indexOfObjectIdenticalTo:dInner];
                isAlreadyInserted=(index>0 && index!=NSIntegerMax);
                if(isAlreadyInserted) break;
            }
            
            if(isAlreadyInserted)
            {
                [self miniMizeFirstsRows:ar];
            }
            else
            {
                NSUInteger count = indexPath.row+1;
                NSMutableArray *arCells=[NSMutableArray array];
                for(NSDictionary *dInner in ar )
                {
                    [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                    [self.firstForTable insertObject:dInner atIndex:count++];
                }
                [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationLeft];
            }
        }
        else
        {
            
            CategoryModal *catObj = [[CategoryModal alloc] init];
            catObj.cat_Id = [d valueForKey:@"id"];
            catObj.cat_Name = [d valueForKey:@"name"];
            
            NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:catObj forKey:@"categoryObject"];
            
            NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
            [nc postNotificationName:@"categorySelector" object:self userInfo:userInfo];

            [self.navigationController popViewControllerAnimated:YES];

        }
    }
   
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
    }
}
-(void)miniMizeFirstsRows:(NSMutableArray*)ar
{
	for(NSDictionary *dInner in ar ) {
		NSUInteger indexToRemove=[self.firstForTable indexOfObjectIdenticalTo:dInner];
		NSDictionary *arInner=[dInner valueForKey:@"items"];
		if(arInner && [arInner count] > 0)
        {
            NSMutableArray *ar = [[NSMutableArray alloc] init];
            NSMutableArray *arrKeys = [[NSMutableArray alloc] initWithArray:[arInner allKeys]];
            for (int p = 0; p < arrKeys.count; p++) {
                [ar addObject:[arInner valueForKey:[NSString stringWithFormat:@"%@",[arrKeys objectAtIndex:p]]]];
            }
			[self miniMizeFirstsRows:ar];
		}
		
		if([self.firstForTable indexOfObjectIdenticalTo:dInner]!=NSNotFound)
        {
			[self.firstForTable removeObjectIdenticalTo:dInner];
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:
												[NSIndexPath indexPathForRow:indexToRemove inSection:0]
												]
							  withRowAnimation:UITableViewRowAnimationFade];
		}
	}
}

-(IBAction)btnGoClick:(id)sender
{
    NSDictionary *d=[self.firstForTable objectAtIndex:[sender tag]];
    CategoryModal *catObj = [[CategoryModal alloc] init];
    catObj.cat_Id = [d valueForKey:@"id"];
    catObj.cat_Name = [d valueForKey:@"name"];
    EventViewController *eventVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EventListVC"];
    eventVC.catObj = catObj;
    [self.navigationController pushViewController:eventVC animated:true];
}

- (void)getAllCategory
{
    self.tempDictionary = [[NSMutableDictionary alloc] init];
    self.firstForTable = [[NSMutableArray alloc] init];
    
    [self startIndicator];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    
    NSString *stringURL = [[NSString alloc] initWithFormat:@"%@", @"http://eventhubsacramento.com/ws.php?module=eventhub&func=get_categories&type=native"];
    
    [manager GET:stringURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    if (responseObject != nil)
    {
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([jsonDic count] > 0)
        {
            NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:jsonDic.allKeys];
            NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending: YES];
            [arr sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortOrder]];
            
            for (int i = 0; i < arr.count; i++) // main loop with key 10.
            {
                NSMutableDictionary *mainDic = [jsonDic valueForKey:[arr objectAtIndex:i]];
                if ([arr objectAtIndex:i] == [mainDic valueForKey:@"id"])
                {
                    NSMutableDictionary *catDic = [[NSMutableDictionary alloc] initWithDictionary:mainDic];
                    if ([NSString stringWithFormat:@"%@",[catDic valueForKey:@"event_count"]].longLongValue != 0)
                    {
                        NSMutableDictionary *dic0;
                        [catDic setValue:@"1" forKey:@"level"];
                    
                        if (![catDic valueForKey:@"leaf"])
                        {
                            dic0 = [[NSMutableDictionary alloc] init];
                            NSMutableDictionary *innerFirstLevelItems = [catDic valueForKey:@"items"];
                            NSMutableArray *innerFirstLevelItemsKeys = [[NSMutableArray alloc] initWithArray:innerFirstLevelItems.allKeys];
                                
                            NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending: YES];
                            innerFirstLevelItemsKeys = (NSMutableArray *)[innerFirstLevelItemsKeys sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortOrder]];
                                
                            for (int k = 0; k < innerFirstLevelItemsKeys.count; k++)  // innersub loop for 2nd level categories list
                            {
                                NSMutableDictionary *catfirstLevelDic = [innerFirstLevelItems valueForKey:[innerFirstLevelItemsKeys objectAtIndex:k]];
                                if ([NSString stringWithFormat:@"%@",[catfirstLevelDic valueForKey:@"event_count" ]].longLongValue != 0)
                                {
                                    [catfirstLevelDic setValue:@"2" forKey:@"level"];
                                
                                    if (![catfirstLevelDic valueForKey:@"leaf"])
                                    {
                                        NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] init];
                                        NSMutableDictionary *innerSecondLevelItems = [catfirstLevelDic valueForKey:@"items"];
                                        NSMutableArray *innerSecondLevelItemsKeys = [[NSMutableArray alloc] initWithArray:innerSecondLevelItems.allKeys];
                                        
                                        NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending: YES];
                                        innerSecondLevelItemsKeys = (NSMutableArray *)[innerSecondLevelItemsKeys sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortOrder]];
                                        
                                        for (int l = 0; l < innerSecondLevelItemsKeys.count; l++)  // innersub loop for 3rd level categories list
                                        {
                                            NSMutableDictionary *catSecondLevelDic = [innerSecondLevelItems valueForKey:[innerSecondLevelItemsKeys objectAtIndex:l]];
                                            if ([NSString stringWithFormat:@"%@",[catSecondLevelDic valueForKey:@"event_count"]].longLongValue != 0)
                                            {
                                                [catSecondLevelDic setValue:@"3" forKey:@"level"];
                                                [dic1 setObject:catSecondLevelDic forKey:[NSString stringWithFormat:@"%d",l]];
                                            } else {
                                                [[catfirstLevelDic valueForKey:@"items"] removeObjectForKey:[catSecondLevelDic valueForKey:@"id"]];
                                            }
                                        }
                                        if([dic1 allKeys].count > 0)
                                        {
                                            [catfirstLevelDic setObject:dic1 forKey:@"items"];
                                        }
                                    }
                                    [dic0 setObject:catfirstLevelDic forKey:[NSString stringWithFormat:@"%d",k]];
                                }
                            }
                            if([dic0 allKeys].count > 0)
                            {
                                [catDic setObject:dic0 forKey:@"items"];
                            }
                        }
                        [self.tempDictionary setObject:catDic forKey:[NSString stringWithFormat:@"%d",i]];
                    }
                }
            }
            
            
                
            NSMutableArray *arrKeys = [[NSMutableArray alloc] initWithArray:[self.tempDictionary allKeys]];
                
            for (int p = 0; p < arrKeys.count; p++)
                
            
            {
                
          
              
                
                
                if ([self.tempDictionary valueForKey:[NSString stringWithFormat:@"%d",p]])
                {
                    
                    
                    [self.firstForTable addObject:[self.tempDictionary valueForKey:[NSString stringWithFormat:@"%d",p]]];
                    
                }else{
                    
                    
                    
                }
                
                
            }
                
            NSMutableDictionary *tDic = [[NSMutableDictionary alloc] init];
            [tDic setObject:@"0" forKey:@"id"];
            [tDic setObject:@"true" forKey:@"leaf"];
            [tDic setObject:@"1" forKey:@"level"];
            [tDic setObject:@"All events near me" forKey:@"name"];
            [self.firstForTable insertObject:tDic atIndex:0];
         
            [self.tableView reloadData];
            self.isCall = NO;
         }
    }
    [self stopIndicator];
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"Category API Failure : %@", error.description);
        [self stopIndicator];
    }];
}

-(void)startIndicator
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    self.activityView.center = self.tableView.center;
    self.activityView.color = [UIColor orangeColor];
    [self.activityView startAnimating];
    [self.tableView addSubview: self.activityView];
}
-(void)stopIndicator
{
    [self.activityView stopAnimating];
    [self.activityView removeFromSuperview];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

@end
