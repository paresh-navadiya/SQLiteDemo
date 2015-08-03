//
//  ViewController.m
//  Practical
//
//  Created by ECWIT on 03/08/15.
//  Copyright (c) 2015 ECWIT. All rights reserved.
//

#import "HomeVC.h"
#import "AppDelegate.h"
#import <AddressBook/AddressBook.h>

#import "AllContactVC.h"
#import "ProfessionalContatctVC.h"
#import "PersonalContactVC.h"

@interface HomeVC ()
{
    NSMutableArray *mutArrSaveContact;
}
@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    mutArrSaveContact = [NSMutableArray array];
    
    ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
        if (!granted)
        {
            //4
            NSLog(@"Just denied");
            return;
        }
        //5
        NSLog(@"Just authorized");
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Methods

-(IBAction)btnSaveContact:(id)sender
{
    NSLog(@"save contact");
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
        ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted){
        //1
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Contact" message:@"Contact acccess denied. Go to settings and allow access" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertView show];
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        //2
        
        [self saveContact];
        
    } else{ //ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined
        //3
        NSLog(@"Not determined");
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Contact" message:@"Contact acccess not determined. Go to settings and allow access" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertView show];
    }
}

-(IBAction)btnAllContact:(id)sender
{
    AllContactVC *objAllContactVC = (AllContactVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"AllContactVC"];
    
    [self.navigationController pushViewController:objAllContactVC animated:YES];
}

-(IBAction)btnPersonalContact:(id)sender
{
    PersonalContactVC *objPersonalContactVC = (PersonalContactVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"PersonalContactVC"];
    
    [self.navigationController pushViewController:objPersonalContactVC animated:YES];
}

-(IBAction)btnProfessionalContact:(id)sender
{
    ProfessionalContatctVC *objProfessionalContatctVC = (ProfessionalContatctVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"ProfessionalContatctVC"];
    
    [self.navigationController pushViewController:objProfessionalContatctVC animated:YES];
}

#pragma mark - 

-(void)saveContact
{
    AppDelegate *objAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    // open the default address book.
    ABAddressBookRef addressBook = ABAddressBookCreate( );
    
    if (addressBook)
    {
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
        CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
        for (int i=0;i < nPeople;i++)
        {
            NSMutableDictionary* tempContactDic = [NSMutableDictionary new];
            
            ABRecordRef ref = CFArrayGetValueAtIndex(allPeople,i);

            ABRecordID recordID = ABRecordGetRecordID(ref);
            NSNumber *contactID = [NSNumber numberWithInt:(int)recordID];
            [tempContactDic setValue:contactID forKey:@"contactid"];
            
            CFStringRef firstName, lastName;
            firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
            lastName  = ABRecordCopyValue(ref, kABPersonLastNameProperty);
            NSString *strName = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
            if (strName.length == 0)
                strName = @"";
            
            [tempContactDic setValue:strName forKey:@"contactname"];
            //fetch email id
            NSString *strEmail;
            ABMultiValueRef email = ABRecordCopyValue(ref, kABPersonEmailProperty);
            CFStringRef tempEmailref = ABMultiValueCopyValueAtIndex(email, 0);
            strEmail = (__bridge  NSString *)tempEmailref;
            
            if (strEmail.length == 0)
                strEmail = @"";

            [tempContactDic setValue:strEmail forKey:@"contactemail"];
            
            ABMultiValueRef phones = ABRecordCopyValue(ref, kABPersonPhoneProperty);
            CFRelease(phones);
            NSString *strMobile = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, 0);
            if (strMobile.length == 0)
                strMobile = @"";
            
            [tempContactDic setValue:strMobile forKey:@"contactphone"];
            
            NSString *strQuery = [NSString stringWithFormat:@"insert into allContact (contactid,contactname,contactphone,contactemail) values(%@,'%@','%@','%@')",contactID,strName,strMobile,strEmail];
            
            NSError *error = [objAppDelegate.objSQLiteManager doQuery:strQuery];
            if (error)
                NSLog(@"error : %@",[error description]);
            
            [mutArrSaveContact addObject:tempContactDic];
            
        }
        
        NSLog(@"mutArrSaveContact : %@",mutArrSaveContact);
        
        if ([mutArrSaveContact count]>0)
        {
           UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Contact" message:@"Contact saved successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    else
    {
        NSLog(@"No access address book");
        
    }

}

@end
