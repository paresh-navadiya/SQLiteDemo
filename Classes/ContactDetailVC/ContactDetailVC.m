//
//  ContactDetailVC.m
//  Practical
//
//  Created by ECWIT on 03/08/15.
//  Copyright (c) 2015 ECWIT. All rights reserved.
//

#import "ContactDetailVC.h"


@interface ContactDetailVC () <UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UITableView *tblViewContacts;
    NSMutableArray *mutArrContactDetail;
}
@end

@implementation ContactDetailVC
@synthesize dictContact;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Contact Detail";
    tblViewContacts.tableFooterView  = [UIView new];
    
    if (dictContact)
    {
        NSString *strName = [self.dictContact objectForKey:@"contactname"];
        NSString *strEmail = [self.dictContact objectForKey:@"contactemail"];
        NSString *strPhone = [self.dictContact objectForKey:@"contactphone"];
        NSString *strIsPersonal = [self.dictContact objectForKey:@"ispersonal"];
        NSString *strIsProfessional = [self.dictContact objectForKey:@"isprofessional"];
        
        NSDictionary *dictName = [NSDictionary dictionaryWithObjectsAndKeys:@"Name",@"title",strName,@"value",nil];
        NSDictionary *dictEmail = [NSDictionary dictionaryWithObjectsAndKeys:@"Email",@"title",strEmail,@"value",nil];
        NSDictionary *dictPhone = [NSDictionary dictionaryWithObjectsAndKeys:@"Phone",@"title",strPhone,@"value",nil];
        NSDictionary *dictrIsPersonal = [NSDictionary dictionaryWithObjectsAndKeys:@"Personal",@"title",strIsPersonal,@"value",nil];
        NSDictionary *dictIsProfessional = [NSDictionary dictionaryWithObjectsAndKeys:@"Professional",@"title",strIsProfessional,@"value",nil];
        
        mutArrContactDetail = [NSMutableArray arrayWithObjects:dictName,dictEmail,dictPhone,dictrIsPersonal,dictIsProfessional,nil];
    }
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
    return [mutArrContactDetail count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if ([mutArrContactDetail count] > 0)
        return 60;
    else
        return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
    
    UIButton *btnCall = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCall.frame = CGRectMake((footerView.frame.size.width/2)-60, 20, 120.f, 40);
    [btnCall addTarget:self action:@selector(btnCallAction:) forControlEvents:UIControlEventTouchUpInside];
    btnCall.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
    [btnCall.layer setCornerRadius:6.0f];
    [btnCall setTitle:@"Call" forState:UIControlStateNormal];
    [btnCall setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footerView addSubview:btnCall];
    
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictDetail = [mutArrContactDetail objectAtIndex:indexPath.row];
    NSString *strTitle = [dictDetail objectForKey:@"title"];
    NSString *strValue = [dictDetail objectForKey:@"value"];
    
    UITableViewCell *cell = nil;
    if (indexPath.row == 3)
    {
        static NSString *simpleTableIdentifier = @"personal";
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        BOOL value = [strValue boolValue];
        
        UISwitch *curSwitch = (UISwitch *)[cell viewWithTag:100];
        [curSwitch setOn:value animated:YES];
    }
    else if (indexPath.row ==4)
    {
        static NSString *simpleTableIdentifier = @"professional";
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        BOOL value = [strValue boolValue];
        
        UISwitch *curSwitch = (UISwitch *)[cell viewWithTag:100];
        [curSwitch setOn:value animated:YES];
    }
    else
    {
        static NSString *simpleTableIdentifier = @"cell";
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        UILabel *lblTitle = (UILabel *)[cell viewWithTag:99];
        lblTitle.text = strTitle;
        
        UILabel *lblValue = (UILabel *)[cell viewWithTag:100];
        lblValue.text = strValue;
    }
    
    return cell;
}

#pragma mark - Switch Action

-(IBAction)btnSwitchPersonalAction:(id)sender
{
    UISwitch *curSwitch = (UISwitch *)sender;
    
    NSInteger contactid = [[self.dictContact objectForKey:@"contactid"] integerValue];
    NSString *strUpdateQuery = @"";
    if (curSwitch.isOn)
        strUpdateQuery = [NSString stringWithFormat:@"update allContact set ispersonal = 1 where contactid = %ld",(long)contactid];
    else
        strUpdateQuery = [NSString stringWithFormat:@"update allContact set ispersonal = 0 where contactid = %ld",(long)contactid];
    
    NSError *error = [objSQLiteManager doQuery:strUpdateQuery];
    if (error)
        NSLog(@"%@",[error  description]);
    else
    {
        NSString *strMessage = nil;
        if (curSwitch.isOn)
            strMessage = @"Contact added  to personal";
        else
            strMessage = @"Contact removed from personal";
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Contact" message:strMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertView show];
    }
}

-(IBAction)btnSwitchProfessionalAction:(id)sender
{
    UISwitch *curSwitch = (UISwitch *)sender;
    
    NSInteger contactid = [[self.dictContact objectForKey:@"contactid"] integerValue];
    NSString *strUpdateQuery = @"";
    if (curSwitch.isOn)
        strUpdateQuery = [NSString stringWithFormat:@"update allContact set isprofessional = 1 where contactid = %ld",(long)contactid];
    else
        strUpdateQuery = [NSString stringWithFormat:@"update allContact set isprofessional = 0 where contactid = %ld",(long)contactid];
    
    NSError *error = [objSQLiteManager doQuery:strUpdateQuery];
    if (error)
        NSLog(@"%@",[error  description]);
    else
    {
        NSString *strMessage = nil;
        if (curSwitch.isOn)
            strMessage = @"Contact added  to professional";
        else
            strMessage = @"Contact removed from professional";
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Contact" message:strMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertView show];
    }
    
}

#pragma mark - Methods

-(IBAction)btnCallAction:(id)sender
{
    NSString *strPhone = [self.dictContact objectForKey:@"contactphone"];
    
    if (strPhone.length>0)
    {
        NSString *strTELURL = [@"tel://" stringByAppendingString:strPhone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strTELURL]];
    }
}


@end
