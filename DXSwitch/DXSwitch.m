//
//  DXSwitch.m
//  DXSwitcher
//
//  Created by Andriy Fedin on 8/1/12.
//  Copyright (c) 2012 111 Minutes. All rights reserved.
//

#import "DXSwitch.h"

@interface DXSwitch ()
{
    UIImage *_maskImage;
    UIView *_fillingView;
    UIImageView *_lever;
    BOOL _mooved;
    BOOL _on;
    float _switchOffset;
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
    _mooved = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
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

- (void)setOn:(BOOL)on animated:(BOOL)animated
{
    float animationDuration = 0;
    if (animated) {
        animationDuration = 0.3;
    }

    if (on) {
        _on = YES;
        [UIView animateWithDuration:animationDuration animations:^{
            _fillingView.center = CGPointMake(_fillingView.frame.size.width/2, _fillingView.center.y);
        }completion:^(BOOL finished) {
            if (finished) {
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }
        }];
    }
    else {
        _on = NO;
        [UIView animateWithDuration:animationDuration animations:^{
            _fillingView.center = CGPointMake(0 + _lever.frame.size.width/2, _fillingView.center.y);
        }completion:^(BOOL finished) {
            if (finished) {
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }
        }];
    }
    
}

- (void)switchState
{
    if (_on) {
        _on = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _fillingView.center = CGPointMake(0 + _lever.frame.size.width/2, _fillingView.center.y);
        }completion:^(BOOL finished) {
            if (finished) {
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }
        }];
    }
    else {
        _on = YES;    
        [UIView animateWithDuration:0.3 animations:^{
            _fillingView.center = CGPointMake(_fillingView.frame.size.width/2, _fillingView.center.y);
        }completion:^(BOOL finished) {
            if (finished) {
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }
        }];
    }
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
        [_fillingView addSubview:_lever];
        _lever.frame = CGRectMake(bkgrOn.frame.size.width-_lever.frame.size.width/2, 
                                 bkgrOn.frame.size.height/2 - _lever.frame.size.height/2,
                                 _lever.frame.size.width, _lever.frame.size.height);
        [self addSubview:_fillingView];
        
        
        CALayer *maskLayer = [CALayer layer];
        maskLayer.contents = (id)[_maskImage CGImage];
        maskLayer.frame = _fillingView.frame;
        self.layer.mask = maskLayer;

        _fillingView.frame = CGRectMake(0, 0, bkgrOn.frame.size.width + bkgrOff.frame.size.width, _fillingView.frame.size.height);    
        
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
