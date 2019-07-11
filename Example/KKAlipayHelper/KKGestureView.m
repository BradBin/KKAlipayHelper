//
//  KKGestureView.m
//  KKAlipayHelper_Example
//
//  Created by 尤彬 on 2019/7/11.
//  Copyright © 2019 BradBin. All rights reserved.
//

#import "KKGestureView.h"

static CGFloat const kkGestureMinimumTranslation = 5.0;


typedef NS_ENUM(NSUInteger,KKGestrueDirection) {
   KKGestrueDirectionNone = 0,
   KKGestrueDirectionUp,
   KKGestrueDirectionDown,
   KKGestrueDirectionLeft,
   KKGestrueDirectionRight
};

@interface KKGestureView()<UIGestureRecognizerDelegate,CAAnimationDelegate>
@property (nonatomic,strong) UIView *backgroudView;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic,assign) KKGestrueDirection      gestrueDirection;
@property (nonatomic,assign) CGFloat                 topSpace;

@end

@implementation KKGestureView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self kkSetupView];
    }
    return self;
}

- (void)kkSetupCommit{
    self.topSpace         = 0.0;
    self.gestrueDirection = KKGestrueDirectionNone;
    
    
    
}

- (void)kkSetupView{
    
    self.panRecognizer = ({
        UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognizer:)];
        gesture.delegate = self;
        [self addGestureRecognizer:gesture];
        gesture;
        
    });

    self.backgroudView = ({
        UIView *view = UIView.alloc.init;
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view.superview).insets(UIEdgeInsetsZero);
        }];
        view;
    });
    
    self.contentView = ({
        UIView *view = UIView.alloc.init;
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view.superview.mas_top).offset(self.topSpace);
            make.left.equalTo(view.superview.mas_left);
            make.right.equalTo(view.superview.mas_right);
            make.bottom.equalTo(view.superview.mas_bottom);
        }];
        view;
    });

}


#pragma mark -
#pragma mark - 粘合手势的事件响应
- (void)panRecognizer:(UIPanGestureRecognizer *)gesture{
    UIGestureRecognizerState state = gesture.state;
    //获取手势在视图上的CGPoint位置
    CGPoint point = [gesture translationInView:self];
    
   KKGestrueDirection gestureDirection = [self determineDirection:point];
    
    NSLog(@"--- %ld   %.2f %.2f",gestureDirection,point.x,point.y);
    
    switch (state) {
        case UIGestureRecognizerStateChanged:
        {
        
        
        } break;
    
            case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateFailed:
        {
        
        } break;
    
        case UIGestureRecognizerStateBegan:{
            
        } break;
        
        default:
            break;
    }
}





#pragma mark -
#pragma mark - 获取手势的移动方向
- (KKGestrueDirection)determineDirection:(CGPoint)translation{
    if (self.gestrueDirection != KKGestrueDirectionNone) {
        return self.gestrueDirection;
    }
    if (fabs(translation.x) > kkGestureMinimumTranslation) {
        BOOL horizontal = false;
        if (translation.y == 0.0) {
            horizontal = true;
        }else{
            horizontal = fabs(translation.x - translation.y) > kkGestureMinimumTranslation;
        }
        if (horizontal) {
            if (translation.x > 0.0) {
                return KKGestrueDirectionRight;
            }else{
                return KKGestrueDirectionLeft;
            }
        }
    }else if (fabs(translation.y) > kkGestureMinimumTranslation){
        BOOL vertical = false;
        if (translation.x == 0.0) {
            vertical = true;
        }else{
            vertical = fabs(translation.x - translation.y) > kkGestureMinimumTranslation;
        }
        if (vertical) {
            if (translation.y > 0.0) {
                return KKGestrueDirectionDown;
            }else{
                return KKGestrueDirectionUp;
            }
        }
    }else{
        return self.gestrueDirection;
    }
     return self.gestrueDirection;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/







@end
