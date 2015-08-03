//
//  ProfessionalContatctVC.m
//  Practical
//
//  Created by ECWIT on 03/08/15.
//  Copyright (c) 2015 ECWIT. All rights reserved.
//

#import "ProfessionalContatctVC.h"
#import "ContactDetailVC.h"
#import "AppDelegate.h"

@interface ProfessionalContatctVC () <UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UITableView *tblViewContacts;
    NSMutableArray *mutArrProfessionalContact;
}
@end

@implementation ProfessionalContatctVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Professional Contacts";
    tblViewContacts.tableFooterView  = [UIView new];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (mutArrProfessionalContact)
        [mutArrProfessionalContact removeAllObjects];
    
    AppDelegate *objAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    mutArrProfessionalContact = [[objAppDelegate.objSQLiteManager getRowsForQuery:[NSString stringWithFormat:@"select * from allContact where isprofessional = 1"]] mutableCopy];
    [tblViewContacts reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITabViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mutArrProfessionalContact count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if ([mutArrProfessionalContact count] == 0)
        return 50;
    else
        return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UILabel *lblFooterTitle = [UILabel new];
    lblFooterTitle.textAlignment = NSTextAlignmentCenter;
    lblFooterTitle.text = @"No contact";
    return lblFooterTitle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSDictionary *dictContact = [mutArrProfessionalContact objectAtIndex:indexPath.row];
    //NSString *strContactImg = [dictContact objectForKey:@"image"];
    NSString *strContactName = [dictContact objectForKey:@"contactname"];
    NSString *strContactNumber = [dictContact objectForKey:@"contactphone"];;
    
    UILabel *lblContactName = (UILabel *)[cell viewWithTag:100];
    lblContactName.text = strContactName;
    
    UILabel *lblContactNumber = (UILabel *)[cell viewWithTag:101];
    lblContactNumber.text = strContactNumber;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictCurContact = [mutArrProfessionalContact objectAtIndex:indexPath.row];
    
    ContactDetailVC *objContactDetailVC = (ContactDetailVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ContactDetailVC"];
    objContactDetailVC.dictContact = dictCurContact;
    [self.navigationController pushViewController:objContactDetailVC animated:YES];
}

@end