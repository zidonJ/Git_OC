#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@implementation ViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.view.backgroundColor=[UIColor grayColor];
    NSArray *arry=[NSArray arrayWithObjects:@"后退",@"前进",@"刷新",@"停止",@"跳转",@"html",@"js", nil];
    for(int i=0;i<arry.count;i++){
        float buttonWidth=320.0/arry.count;
        UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame=CGRectMake(i*buttonWidth, 10, buttonWidth, 25);
        button.tag=i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[arry objectAtIndex:i] forState:UIControlStateNormal];
        [self.view addSubview:button];
    }
    _urlField=[[UITextField alloc] initWithFrame:CGRectMake(0, 40, 320, 25)];
    _urlField.borderStyle=UITextBorderStyleRoundedRect;
    _urlField.delegate=self;
    self.view.backgroundColor=[UIColor redColor];
    [self.view addSubview:_urlField];
    
    _webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 65, 320, CGRectGetHeight(self.view.frame)+69)];
    _webView.delegate=self;
    //_webView.scalesPageToFit=YES;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"www.baidu.com"]]];
    [self.view addSubview:_webView];
    [_webView reload];
}

-(void)buttonClick:(UIButton *)button
{
    //后退
    if(button.tag==0){
        [_webView goBack];
    }
    //前进
    if(button.tag==1){
        [_webView goForward];
    }
    //刷新
    if(button.tag==2){
        [_webView reload];
    }
    //停止
    if(button.tag==3){
        [_webView stopLoading];
    }
    //跳转
    if(button.tag==4){
        if(![_urlField.text hasPrefix:@"http://"]){
            _urlField.text=[NSString stringWithFormat:@"http://%@",_urlField.text];
        }
        NSURL *url=[NSURL URLWithString:_urlField.text];
        NSURLRequest *request=[NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
    }
    //html
    if(button.tag==5){
        NSString *path=[[NSBundle mainBundle] pathForResource:@"xml" ofType:@"html"];
//        //通过这种方式加载的html,不能加载到外部的js代码
//        NSString *str=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//        [_webView loadHTMLString:str baseURL:nil];
        
        NSURL *url=[NSURL fileURLWithPath:path];
        
//        //可能会出现中文乱码的情况,用loadData的方式加载可以解决这个问题
//        NSURLRequest *request=[NSURLRequest requestWithURL:url];
//        [_webView loadRequest:request];
        
        NSData *data=[NSData dataWithContentsOfURL:url];
        [_webView loadData:data MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:url];
    }
    //oc与javascript交互
    if(button.tag==6){
        //alert(order);
        //getKuaiQianPayInfo (order,user,ip)
        //15947958502
        //[_webView stringByEvaluatingJavaScriptFromString:@"getKuaiQianPayInfo('aawangpengfei','asd','pengfei')"];
        
        [_webView stringByEvaluatingJavaScriptFromString:@"func('hello world','这个是oc给js传的参数')"];
//        [_webView stringByEvaluatingJavaScriptFromString:@"sayHello()"];
    }
}

- (NSString *)mimeType:(NSURL *)url
{
    //1NSURLRequest
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //2NSURLConnection
    
    //3 在NSURLResponse里，服务器告诉浏览器用什么方式打开文件。
    
    //使用同步方法后去MIMEType
    NSURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    return response.MIMEType;
}

-(void)ocFunc:(id)str andFunc:(id)str1
{
    NSLog(@"我是oc的方法11%@-%@",str,str1);
}

-(void)ocFunc
{
    NSLog(@"我是被js调用的oc方法");
}
#pragma mark --UIWebViewDelegate--
//js与oc交互
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //判断地址的协议头是什么
    if ([@"objc" isEqualToString:request.URL.scheme]) {
        NSString *url = request.URL.absoluteString;
        NSLog(@"%@",url);
    }
    //刷新地址栏
    _urlField.text=request.URL.absoluteString;
    
    if([request.URL.absoluteString hasPrefix:@"objc://"]){
        NSString *path=[request.URL.absoluteString substringFromIndex:[@"objc://" length]];
        //找参数
        NSArray *subPath=[path componentsSeparatedByString:@"?"];
        
        NSString *methodName = [[subPath firstObject] stringByReplacingOccurrencesOfString:@"_" withString:@":"];
    
        [self performSelector:NSSelectorFromString(methodName) withObject:@"1" withObject:@"2"];
    }
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{

}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{

}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end