//
//  ViewController.m
//  KScrollableTopMenuDemo
//
//  Created by Krishana on 6/15/16.
//  Copyright © 2016 Konstant Info Solutions Pvt. Ltd. All rights reserved.
//

#import "ViewController.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define kDefaultEdgeInsets UIEdgeInsetsMake(5, 10, 5, 10)

@interface ViewController ()<UIScrollViewDelegate>
{
    /**
     *  Reference to array containing button title of top menu
     */
    NSArray *btnArray;
}

/**
 *  Reference to Container scroll view containing all related controllers
 */
@property (weak) IBOutlet UIScrollView *containerScrollView;

/**
 *  Reference to Scroll View containg all top menu items
 */
@property (weak) IBOutlet UIScrollView *menuScrollView;

/**
 *  Add Menu Buttons in Menu Scroll View
 *
 *  @param buttonArray Array containing all menu button title
 */

-(void) addButtonsInScrollMenu:(NSArray *)buttonArray;


/**
 *  Any Of the Top Menu Button Press Action
 *
 *  @param sender id of the button pressed
 */
-(void) buttonPressed:(id) sender;


/**
 *  Calculating width of button added on top menu
 *
 *  @param title            Title of the Button
 *  @param buttonEdgeInsets Edge Insets for the title
 *
 *  @return Width of button
 */
- (CGFloat)widthForMenuTitle:(NSString *)title buttonEdgeInsets:(UIEdgeInsets)buttonEdgeInsets;


/**
 *  Adding all related controllers in to the container
 *
 *  @param controllersArr Array containing objects of all controllers
 */
-(void) addChildViewControllersOntoContainer:(NSArray *)controllersArr;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    btnArray = @[@"Menu One", @"Menu Two", @"Menu Three more long button", @"Menu Four"];
    [self addButtonsInScrollMenu:btnArray];
    
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    OneViewController *oneVC = [storyBoard instantiateViewControllerWithIdentifier:@"OneViewController"];
    TwoViewController *twoVC = [storyBoard instantiateViewControllerWithIdentifier:@"TwoViewController"];
    ThirdViewController *thirdVC = [storyBoard instantiateViewControllerWithIdentifier:@"ThirdViewController"];
    FourthViewController *fourthVC = [storyBoard instantiateViewControllerWithIdentifier:@"FourthViewController"];
    NSArray *controllerArray = @[oneVC, twoVC, thirdVC, fourthVC];
    [self addChildViewControllersOntoContainer:controllerArray];
}

/**
 *  Add Menu Buttons in Menu Scroll View
 *
 *  @param buttonArray Array containing all menu button title
 */

#pragma mark - Add Menu Buttons in Menu Scroll View
-(void) addButtonsInScrollMenu:(NSArray *)buttonArray
{
    CGFloat buttonHeight = self.menuScrollView.frame.size.height;
    CGFloat cWidth = 0.0f;
    
    for (int i = 0 ; i<buttonArray.count; i++)
    {
        NSString *tagTitle = [buttonArray objectAtIndex:i];
        
        CGFloat buttonWidth = [self widthForMenuTitle:tagTitle buttonEdgeInsets:kDefaultEdgeInsets];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(cWidth, 0.0f, buttonWidth, buttonHeight);
        [button setTitle:tagTitle forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:10.0f];
       
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [self.menuScrollView addSubview:button];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, button.frame.size.height - 5, button.frame.size.width, 5)];
        bottomView.backgroundColor = [UIColor redColor];
        bottomView.tag = 1001;
        [button addSubview:bottomView];
        if (i == 0)
        {
            button.selected = YES;
            [bottomView setHidden:NO];
        }
        else
        {
            [bottomView setHidden:YES];
        }
        
        
        cWidth += buttonWidth;
    }
    
    NSLog(@"scroll menu width->%f",cWidth);
    self.menuScrollView.contentSize = CGSizeMake(cWidth, self.menuScrollView.frame.size.height);
}


/**
 *  Any Of the Top Menu Button Press Action
 *
 *  @param sender id of the button pressed
 */

#pragma mark - Menu Button press action
-(void) buttonPressed:(id) sender
{
    UIButton *senderbtn = (UIButton *) sender;
    float buttonWidth = 0.0f;
    for (UIView *subView in self.menuScrollView.subviews)
    {
        UIButton *btn = (UIButton *) subView;
        UIView *bottomView = [btn viewWithTag:1001];

        if (btn.tag == senderbtn.tag)
        {
            btn.selected = YES;
            [bottomView setHidden:NO];
        }
        else
        {
            btn.selected = NO;
            [bottomView setHidden:YES];
        }
    }
    
    [self.containerScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * senderbtn.tag, 0) animated:YES];
    
    float xx = SCREEN_WIDTH * (senderbtn.tag) * (buttonWidth / SCREEN_WIDTH) - buttonWidth;
    [self.menuScrollView scrollRectToVisible:CGRectMake(xx, 0, SCREEN_WIDTH, self.menuScrollView.frame.size.height) animated:YES];
}

/**
 *  Calculating width of button added on top menu
 *
 *  @param title            Title of the Button
 *  @param buttonEdgeInsets Edge Insets for the title
 *
 *  @return Width of button
 */

#pragma mark - Calculate width of menu button
- (CGFloat)widthForMenuTitle:(NSString *)title buttonEdgeInsets:(UIEdgeInsets)buttonEdgeInsets
{
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10.0f]};
    
    CGSize size = [title sizeWithAttributes:attributes];
    return CGSizeMake(size.width + buttonEdgeInsets.left + buttonEdgeInsets.right, size.height + buttonEdgeInsets.top + buttonEdgeInsets.bottom).width;
}


/**
 *  Adding all related controllers in to the container
 *
 *  @param controllersArr Array containing objects of all controllers
 */
#pragma mark - Adding all related controllers in to the container
-(void) addChildViewControllersOntoContainer:(NSArray *)controllersArr
{
    for (int i = 0 ; i < controllersArr.count; i++)
    {
        UIViewController *vc = (UIViewController *)[controllersArr objectAtIndex:i];
        CGRect frame = CGRectMake(0, 0, self.containerScrollView.frame.size.width, self.containerScrollView.frame.size.height);
        frame.origin.x = SCREEN_WIDTH * i;
        vc.view.frame = frame;
        
        [self addChildViewController:vc];
        [self.containerScrollView addSubview:vc.view];
        [vc didMoveToParentViewController:self];
    }
    
    self.containerScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * controllersArr.count + 1, self.containerScrollView.frame.size.height);
    self.containerScrollView.pagingEnabled = YES;
    self.containerScrollView.delegate = self;
}


#pragma mark - Scroll view delegate methods
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = (scrollView.contentOffset.x / SCREEN_WIDTH);
    
    UIButton *btn;
    float buttonWidth = 0.0;
    for (UIView *subView in self.menuScrollView.subviews)
    {
        btn = (UIButton *) subView;
        UIView *bottomView = [btn viewWithTag:1001];

        if (btn.tag == page)
        {
            btn.selected = YES;
            buttonWidth = btn.frame.size.width;
            [bottomView setHidden:NO];
        }
        else
        {
            btn.selected = NO;
            [bottomView setHidden:YES];
        }
    }
    
    float xx = scrollView.contentOffset.x * (buttonWidth / SCREEN_WIDTH) - buttonWidth;
    [self.menuScrollView scrollRectToVisible:CGRectMake(xx, 0, SCREEN_WIDTH, self.menuScrollView.frame.size.height) animated:YES];
}

#pragma mark - other methods
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
