//
//  GuideViewController.m
//  PageScrollSample
//

#import "GuideViewController.h"


#define SPACE_WIDTH 20
//#define CONTENT_SIZEHEIGHT 480
#define CONTENT_NUM 2
#define CONTENT_SIZEWEIGHT 320
#define GUIDE_VIEW_COLOR [UIColor colorWithRed:48.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1.0]

@implementation GuideViewController

@synthesize scrollView ;
@synthesize isChangeAction;
@synthesize pageControl;

- (void)dealloc
{
    [scrollView release];
    [pageControl release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame = [[UIScreen mainScreen] applicationFrame];
    self.view.backgroundColor = GUIDE_VIEW_COLOR;
    
    CGRect frame = CGRectMake(0, 0, CONTENT_SIZEWEIGHT, self.view.frame.size.height);
    self.scrollView = [[[UIScrollView alloc] initWithFrame:frame] autorelease];
    self.scrollView.clipsToBounds = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    
    [self.view addSubview:self.scrollView];
    
    NSInteger contentWidth = self.scrollView.frame.size.width - SPACE_WIDTH;
    
    NSFileManager *file = [NSFileManager defaultManager];
    NSBundle *bundle =[NSBundle mainBundle];
    NSString *str = [bundle pathForResource:@"guide" ofType:@"bundle"];
    NSArray *list = nil;
    if ([file fileExistsAtPath:str]) {
        list = [file contentsOfDirectoryAtPath:str error:nil];
    }
    int count = list.count / 3;
    for (int i = 0; i < count; ++i) {
        CGRect frame = {(contentWidth + SPACE_WIDTH) * i, 0, CONTENT_SIZEWEIGHT, self.view.frame.size.height};
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        CGFloat h = [UIScreen mainScreen].bounds.size.height;
        NSString *path;
        if (h >= 568) {
            path  = [NSString stringWithFormat:@"guide%d-568h@2x.png",i+1];
        }else{
            path  = [NSString stringWithFormat:@"guide%d.png",i+1];
        }
        
        NSString *main_images_dir_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"guide.bundle"];
        NSString *image_path = [main_images_dir_path stringByAppendingPathComponent:path];
        [imageView setImage:[UIImage imageWithContentsOfFile:image_path]];
        imageView.userInteractionEnabled = YES;
        if (i == count-1) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height);
            //            [btn setImage:[UIImage imageNamed:@"icon"] forState:UIControlStateNormal];
            //            [btn setImage:[UIImage imageNamed:@"icon"] forState:UIControlStateHighlighted];
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:btn];
        }
        [self.scrollView addSubview:imageView];
        
        [imageView release];
    }
    
//    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(140, self.view.frame.size.height-50, 60, 30)];  //创建UIPageControl，位置在屏幕最下方
//    pageControl.numberOfPages = count;
//    pageControl.currentPage = 0;
//    
//    [self.pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:pageControl];  //将UIPageControl添加到主界面上。
    
    self.scrollView.contentSize = CGSizeMake((contentWidth + SPACE_WIDTH) * count, self.view.frame.size.height);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.scrollView = nil;
    self.pageControl = nil;
}

- (void)loginAction {
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:1.0];
    self.view.alpha = 0;
    [UIView commitAnimations];
    
    [self.view removeFromSuperview];
}

- (void)back {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)ascrollView
{
    //更新UIPageControl的当前页
    CGPoint offset = ascrollView.contentOffset;
    CGRect bounds = ascrollView.frame;
    [pageControl setCurrentPage:offset.x / bounds.size.width];
}

- (void)scrollViewDidScroll:(UIScrollView *)ascrollView{
    NSFileManager *file = [NSFileManager defaultManager];
    NSBundle *bundle =[NSBundle mainBundle];
    NSString *str = [bundle pathForResource:@"guide" ofType:@"bundle"];
    NSArray *list = nil;
    if ([file fileExistsAtPath:str]) {
        list = [file contentsOfDirectoryAtPath:str error:nil];
    }
    
    CGPoint offset = ascrollView.contentOffset;
    if (offset.x>(list.count/3 - 1) * 320+50) {
        [self loginAction];
    }
}

- (void)pageTurn:(UIPageControl*)sender
{
    //令UIScrollView做出相应的滑动显示
    CGSize viewSize = scrollView.frame.size;
    CGRect rect = CGRectMake(sender.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    [scrollView scrollRectToVisible:rect animated:YES];
}

@end
