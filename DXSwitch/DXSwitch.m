//
//  DXSwitch.m
//  DXSwitcher
//
//  Created by Andriy Fedin on 8/1/12.
//  Copyright (c) 2012 111 Minutes. All rights reserved.
//

#import "DXSwitch.h"

#define ANIMATION_DURATION 0.2

@interface DXSwitch ()
{
    UIImage *_maskImage;
    UIView *_fillingView;
    UIImageView *_lever;
    BOOL _mooved;
    BOOL _on;
    float _switchOffset;
    UIGestureRecognizer *gestureRecognizer;
}

@end



@implementation DXSwitch

- (BOOL)on
{
    return _on;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    CGPoint position = [[touches anyObject] locationInView:self];
    _switchOffset = _fillingView.center.x - position.x;
    
    
    
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    CGPoint position = [[touches anyObject] locationInView:self];

    _fillingView.center = CGPointMake(position.x + _switchOffset, _fillingView.center.y);
    if (_fillingView.frame.origin.x > 0) {
        _fillingView.frame = CGRectMake(0, _fillingView.frame.origin.y, _fillingView.frame.size.width, _fillingView.frame.size.height);
    }
    if (_fillingView.frame.origin.x < -_fillingView.frame.size.width/2  + _lever.frame.size.width/2) {
        _fillingView.frame = CGRectMake(-_fillingView.frame.size.width/2 + _lever.frame.size.width/2, _fillingView.frame.origin.y, _fillingView.frame.size.width, _fillingView.frame.size.height);
    }
    _lever.center = _fillingView.center;
    _mooved = YES;
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    CGPoint position = [[touches anyObject] locationInView:self];
    
    if ([self hitTest:position withEvent:event]) {
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    
    if (_mooved) {
        if (_fillingView.center.x < (_fillingView.frame.size.width / 2 + _lever.frame.size.width / 2)/2) {
            [self setOn:NO animated:YES];
        }
        else {
            [self setOn:YES animated:YES];
        }
    }
    else {
        [self switchState];
    }
    
    _mooved = NO;
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setOn:_on animated:NO];
}



- (void)setOn:(BOOL)on animated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            [self switchVisual:on];
        }completion:^(BOOL finished) {
            if (finished) {
                [self switchLatent:on];
            }
        }];
    }
    else {
        [self switchVisual:on];
        [self switchLatent:on];
    }
        
    
}

- (void)switchVisual:(BOOL)finalState
{
    if (finalState) {
        _fillingView.center = CGPointMake(_fillingView.frame.size.width/2, _fillingView.center.y);
    }
    else {
        _fillingView.center = CGPointMake(0 + _lever.frame.size.width/2, _fillingView.center.y);
    }
    _lever.center = _fillingView.center;
}

- (void)switchLatent:(BOOL)finalState
{
    _on = finalState;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)switchState
{
    if (_on) {
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            _fillingView.center = CGPointMake(0 + _lever.frame.size.width/2, _fillingView.center.y);
            _lever.center = _fillingView.center;
        }completion:^(BOOL finished) {
            if (finished) {
                _on = NO;
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }
        }];
    }
    else {
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            _fillingView.center = CGPointMake(_fillingView.frame.size.width/2, _fillingView.center.y);
            _lever.center = _fillingView.center;
        }completion:^(BOOL finished) {
            if (finished) {
                _on = YES;  
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }
        }];
    }
}




- (id)initWithFrame:(CGRect)frame onBackgroundImage:(UIImage *)onBackImg offBackgroundImg:(UIImage *)offBackImg leverImage:(UIImage *)leverImage 
{
    self = [super init];
    if (self) {
        _mooved = NO;
        _on = YES;
        _switchOffset = 0.0;
        
        _fillingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width*2 - frame.size.height, frame.size.height)];
        
        UIImageView *bkgrOn = [[UIImageView alloc] initWithImage:onBackImg];
        bkgrOn.frame = CGRectMake(0, 0, frame.size.width - frame.size.height/2, frame.size.height);
        
        
        bkgrOn.contentMode = UIViewContentModeScaleToFill;
        
        
        _lever = [[UIImageView alloc] initWithImage:leverImage];
        
        UIImageView *bkgrOff = [[UIImageView alloc] initWithImage:offBackImg];
        bkgrOff.frame = CGRectMake(frame.size.width - frame.size.height/2, 0, frame.size.width - frame.size.height/2, frame.size.height);
        [_fillingView addSubview:bkgrOn];
        [_fillingView addSubview:bkgrOff];

        
        _lever.frame = CGRectMake(frame.size.width - frame.size.height, 0, frame.size.height, frame.size.height);
        [self addSubview:_fillingView];
        
        _fillingView.userInteractionEnabled = NO;
        _fillingView.exclusiveTouch = YES;
        self.exclusiveTouch = YES;
        
        
        
        CALayer *maskLayer = [CALayer layer];
        maskLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        maskLayer.backgroundColor = [UIColor blackColor].CGColor;
        maskLayer.cornerRadius = frame.size.height/2;
        self.layer.mask = maskLayer;
        
        CALayer *innerShadow = [CALayer layer];
        [innerShadow setMasksToBounds:YES];
        [innerShadow setCornerRadius:maskLayer.cornerRadius];
        [innerShadow setBorderColor:[UIColor blackColor].CGColor];
        [innerShadow setBorderWidth:1.05];
        [innerShadow setShadowColor:[UIColor blackColor].CGColor];
        [innerShadow setShadowOffset:CGSizeMake(0, 0)];
        [innerShadow setShadowOpacity:1.0];
        [innerShadow setShadowRadius:2.5];
        innerShadow.frame = CGRectMake(-1, -1, frame.size.width+2, frame.size.height+20);
        [self.layer addSublayer:innerShadow];
        
        [_lever.layer setShadowOpacity:0.5];
        [_lever.layer setShadowOffset:CGSizeMake(0, 1)];
        [_lever.layer setShadowRadius:1.0];
        [self addSubview:_lever];
        
        self.frame = frame;
    }
    return self;
}

- (id)initWithOnBackgroundName:(NSString *)onBackName offBackgroundName:(NSString *)offBackName leverName:(NSString *)leverName maskName:(NSString *)maskName
{
    self = [super init];
    if (self) {
        _mooved = NO;
        _on = YES;
        _switchOffset = 0.0;
        _maskImage = [UIImage imageNamed:maskName];
        _fillingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _maskImage.size.width, _maskImage.size.height)];
        UIImageView *bkgrOn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:onBackName]];
        _lever = [[UIImageView alloc] initWithImage:[UIImage imageNamed:leverName]];
        UIImageView *bkgrOff = [[UIImageView alloc] initWithImage:[UIImage imageNamed:offBackName]];
        bkgrOff.frame = CGRectMake(bkgrOn.frame.size.width, bkgrOn.frame.origin.y, bkgrOff.frame.size.width, bkgrOff.frame.size.height);
        [_fillingView addSubview:bkgrOn];
        [_fillingView addSubview:bkgrOff];
        
        _lever.frame = CGRectMake(bkgrOn.frame.size.width-_lever.frame.size.width/2,
                                  bkgrOn.frame.size.height/2 - _lever.frame.size.height/2,
                                  _lever.frame.size.width, _lever.frame.size.height);
        [self addSubview:_fillingView];
        
        _fillingView.userInteractionEnabled = NO;
        
        CALayer *maskLayer = [CALayer layer];
        maskLayer.contents = (id)[_maskImage CGImage];
        maskLayer.frame = _fillingView.frame;
        self.layer.mask = maskLayer;
        
        _fillingView.frame = CGRectMake(0, 0, bkgrOn.frame.size.width + bkgrOff.frame.size.width, _fillingView.frame.size.height);
        
        [self addSubview:_lever];
        self.frame = CGRectMake(0, 0, _maskImage.size.width, _maskImage.size.height);
    }
    return self;
}

- (void)setOnImage:(NSString *)onImgName offImage:(NSString *)offImgName
{
    UIImageView *onImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:onImgName]];
    UIImageView *offImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:offImgName]];
    
    onImg.center = CGPointMake(_fillingView.frame.size.width/4 - _lever.frame.size.width/8, _fillingView.frame.size.height/2);
    offImg.center = CGPointMake(_fillingView.frame.size.width/4*3 + _lever.frame.size.width/8, _fillingView.frame.size.height/2);
    
    [_fillingView addSubview:onImg];
    [_fillingView addSubview:offImg];
}

- (void)setLabelsWithFont:(UIFont *)font onText:(NSString *)onText offText:(NSString *)offText onTextColor:(UIColor *)onTextColor offTextColor:(UIColor *)offTextColor;
{
    UILabel *onLabel = [[UILabel alloc] init];
    UILabel *offLabel = [[UILabel alloc] init];
    
    onLabel.text = onText;
    onLabel.backgroundColor = [UIColor clearColor];
    onLabel.textColor = onTextColor;
    onLabel.textAlignment = UITextAlignmentCenter;
    onLabel.font = font;
    
    offLabel.text = offText;
    offLabel.backgroundColor = [UIColor clearColor];
    offLabel.textColor = offTextColor;
    offLabel.textAlignment = UITextAlignmentCenter;
    offLabel.font = font;
    
    onLabel.frame = CGRectMake(0, 0, _fillingView.frame.size.width/2 - _lever.frame.size.width/4*3, _fillingView.frame.size.height);
    offLabel.frame = onLabel.frame;
    
    
    onLabel.center = CGPointMake(_fillingView.frame.size.width/4 - _lever.frame.size.width/8, _fillingView.center.y);
    offLabel.center = CGPointMake(_fillingView.frame.size.width/4*3 + _lever.frame.size.width/8, _fillingView.center.y);
    [_fillingView addSubview:onLabel];
    [_fillingView addSubview:offLabel];
}

@end
