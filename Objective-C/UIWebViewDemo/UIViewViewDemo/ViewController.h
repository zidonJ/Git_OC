#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate,UIWebViewDelegate>
{
    UIWebView *_webView;
    UITextField *_urlField;
}


@end
