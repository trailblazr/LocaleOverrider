//
//  LanguageViewController.m
//  LocaleOverrider
//
//  Created by Lincoln Six Echo on 24.05.14.
//  Copyright (c) 2014 appdoctors. All rights reserved.
//

#import "LanguageViewController.h"

@implementation LanguageViewController

@synthesize languageSegementedControl;
@synthesize loremIpsumTextView;
@synthesize localeImage;
@synthesize warningLabel;

- (void) dealloc {
    self.languageSegementedControl = nil;
    self.loremIpsumTextView = nil;
    self.localeImage = nil;
    self.warningLabel = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // FORMAT TEXT A LITTLE BIT
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.minimumLineHeight = 19.f;
    paragraphStyle.maximumLineHeight = 19.f;
    NSDictionary *attributes = @{ NSParagraphStyleAttributeName : paragraphStyle };
    loremIpsumTextView.attributedText = [[[NSAttributedString alloc] initWithString:LOC( @"LoremIpsum" ) attributes:attributes] autorelease];
    loremIpsumTextView.layer.cornerRadius = 5.0;
    loremIpsumTextView.clipsToBounds = YES;
    // ADJUST SEGMENT
    [languageSegementedControl setSelectedSegmentIndex:[self segmentedControlIndex]];
    // INDICATE IF WE ARE ON IOS/SYSTEM LANGUAGE
    if( [self segmentedControlIndex] == 0 ) {
        [localeImage setImage:[UIImage imageNamed:@"flag_apple.png"]];
    }
    // WARNING
    warningLabel.text = LOC( @"Warning" );
}

- (NSUInteger) segmentedControlIndex {
    NSString *languageComponents = [[NSUserDefaults standardUserDefaults] objectForKey:kLOCALE_OVERRIDE_COMPONENTS];
    if( !languageComponents ) return 0;
    NSArray *choices = @[ @"en_US", @"de_DE", @"ja_JP" ];
    NSUInteger index = 0;
    for( NSString *currentChoice in choices ) {
        index++;
        if( [currentChoice isEqualToString:languageComponents] ) {
            return index;
        }
    }
    return index;
}

#pragma mark - user actions

- (IBAction) actionLanguageChanged:(UISegmentedControl*)segmentedControl {
    NSString *languageComponents = nil;
    switch (segmentedControl.selectedSegmentIndex) {

        case 0:
            languageComponents = nil;
            break;

        case 1:
            languageComponents = @"en_US";
            break;

        case 2:
            languageComponents = @"de_DE";
            break;

        case 3:
            languageComponents = @"ja_JP";
            break;
            
        default:
            break;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if( languageComponents ) {
        [defaults setObject:languageComponents forKey:kLOCALE_OVERRIDE_COMPONENTS];
    }
    else {
        [defaults removeObjectForKey:kLOCALE_OVERRIDE_COMPONENTS];
    }
    [defaults synchronize];
    
    // NOW ADJUST DEFAULTS
    NSArray *localeComponents = [[defaults objectForKey:kLOCALE_OVERRIDE_COMPONENTS] componentsSeparatedByString:@"_"];
    NSString *languageIdentifier = @"en";
    NSString *countryIdentifier = @"US";
    BOOL shouldOverrideLocale = ( localeComponents && [localeComponents count] > 1 );
    
    if( shouldOverrideLocale ) {
        languageIdentifier = [localeComponents firstObject];
        countryIdentifier = [localeComponents lastObject];
        NSLog( @"OVERRIDING SYSTEM LOCALE WITH : %@_%@",languageIdentifier, countryIdentifier );
        [defaults setObject:[NSArray arrayWithObject:languageIdentifier] forKey:@"AppleLanguages"];
        [defaults setObject:[NSArray arrayWithObjects:languageIdentifier, nil] forKey:@"NSLanguages"];
        [defaults setObject:[NSString stringWithFormat:@"%@_%@", languageIdentifier, countryIdentifier] forKey:@"AppleLocale"];
        [defaults synchronize];
    }
    else {
        NSArray *keysToRemove = @[@"AppleLanguages",@"NSLanguages",@"AppleLocale"];
        NSLog( @"RESETTING TO USE SYSTEM LOCALE" );
        @try {
            for( NSString *currentKey in keysToRemove ) {
                if( [defaults objectForKey:currentKey] ) {
                    [defaults removeObjectForKey:currentKey];
                }
            }
        }
        @catch (NSException *exception) {
            // NOTHNG TO CATCH HERE
        }
        @finally {
            [defaults synchronize];
        }
    }
    // PRESENT ALERT
    UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:LOC( @"Language" ) message:LOC( @"You changed the language" ) delegate:nil cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
    [alert show];
}

@end
