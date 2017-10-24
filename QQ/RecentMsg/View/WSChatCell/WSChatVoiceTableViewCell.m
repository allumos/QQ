//
//  WSChatVoiceTableViewCell.m
//  QQ
//
//  Created by weida on 15/9/22.
//  Copyright (c) 2015年 weida. All rights reserved.
//  https://github.com/weida-studio/QQ

#import "WSChatVoiceTableViewCell.h"


#define kHMinOffsetSecondLable_supView            (40)  //水平方向上，秒数Lable和父控件之间最小间隙
#define kHOffsetSecondLable_voiceImageView        (10)  //水平方向上，秒数Lable和喇叭ImageVIew之间的间隙
#define kHOffsetSecondLable_BubbleView            (20)  //水平方向上，秒数Lable和气泡之间的间隙
#define kHOffsetVoiceImage_BubbleView             (25)  //水平方向上，喇叭和气泡之间的间隔
#define kVOffsetSecondLable_BubbleView            (20)   //垂直方向上，秒数Lable和气泡顶部间隔

//对方秒数Lable 字体颜色
#define kTextColorSecondLable_Receive             ([UIColor blackColor])
#define kTextColorSecondLable_Sender              ([UIColor whiteColor])

#define kFontText               ([UIFont systemFontOfSize:12])

@interface WSChatVoiceTableViewCell ()
{    
    /**
     *  @brief  声音秒数
     */
    UILabel   *mSecondLable;
    
    /**
     *  @brief  喇叭
     */
    UIImageView *mVoiceImageView;
}
@end

@implementation WSChatVoiceTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(voiceBeenTaped:)];
        [mBubbleImageView addGestureRecognizer:tap];
        
        mSecondLable = [[UILabel alloc]init];
        mSecondLable.backgroundColor = [UIColor clearColor];
        mSecondLable.font = kFontText;
        [self.contentView addSubview:mSecondLable];
        
        mVoiceImageView = [[UIImageView alloc]init];
        mVoiceImageView.backgroundColor= [UIColor clearColor];
        [self.contentView addSubview:mVoiceImageView];

       // CGFloat scale = 0.6;
        //[mVoiceImageView autoSetDimensionsToSize:CGSizeMake(29 *scale, 33*scale)];
        mVoiceImageView.animationDuration = 1;
        mVoiceImageView.animationRepeatCount = 0;
        
        if (isSender)
        {
            mSecondLable.textAlignment = NSTextAlignmentRight;
            mSecondLable.textColor = kTextColorSecondLable_Sender;
           
            //[mSecondLable autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:mVoiceImageView withOffset:-kHOffsetSecondLable_voiceImageView];
           // [mSecondLable autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:mBubbleImageView withOffset:kHOffsetSecondLable_BubbleView];

           // [mSecondLable autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kHMinOffsetSecondLable_supView relation:NSLayoutRelationGreaterThanOrEqual];
            
            mVoiceImageView.image = [UIImage imageNamed:@"chat_voice_sender3"];
            mVoiceImageView.animationImages = @[[UIImage imageNamed:@"chat_voice_sender1"],
                                                [UIImage imageNamed:@"chat_voice_sender2"],
                                                [UIImage imageNamed:@"chat_voice_sender3"]];
           // [mVoiceImageView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:mBubbleImageView withOffset:-kHOffsetVoiceImage_BubbleView];
            
            
        }else
        {
            mVoiceImageView.image = [UIImage imageNamed:@"chat_voice_receive3"];
            mVoiceImageView.animationImages = @[[UIImage imageNamed:@"chat_voice_receive1"],
                                                [UIImage imageNamed:@"chat_voice_receive2"],
                                                [UIImage imageNamed:@"chat_voice_receive3"]];
           // [mVoiceImageView autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:mBubbleImageView withOffset:kHOffsetVoiceImage_BubbleView];
            
            
            mSecondLable.textColor = kTextColorSecondLable_Receive;
            mSecondLable.textAlignment = NSTextAlignmentLeft;
           // [mSecondLable autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:mVoiceImageView withOffset:kHOffsetSecondLable_voiceImageView];
           // [mSecondLable autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:mBubbleImageView withOffset:-kHOffsetSecondLable_BubbleView];
           // [mSecondLable  autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kHMinOffsetSecondLable_supView relation:NSLayoutRelationGreaterThanOrEqual];
        }
        
       /*
        [mVoiceImageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:mSecondLable];
        [mSecondLable autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:mBubbleImageView withOffset:kVOffsetSecondLable_BubbleView];
        [mVoiceImageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:mBubbleImageView];
        [mBubbleImageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];*/
        
    }
    
    return self;
}

-(void)setModel:(WSChatModel *)model width:(CGFloat)width
{
    if (!model.content){
        model.content = [self.class makeContent:model.secondVoice];
    }
    mSecondLable.text = model.content;
    
    NSDictionary *dict = model.subViewsFrame[@(width)];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSValue *frame = dict[@"mSecondLable"];
        mSecondLable.frame = [frame CGRectValue];
        
        frame = dict[@"mVoiceImageView"];
        mVoiceImageView.frame = [frame CGRectValue];
    }else{
        [model calculateSubViewsFrame:width];
        [self setModel:model width:width];
    }
    
    [super setModel:model width:width];
}

+(NSDictionary *)calculateSubViewsFramewithModel:(WSChatModel *)model width:(CGFloat)width{
    NSMutableDictionary *dict = [super calculateSubViewsFramewithModel:model width:width].mutableCopy;
    if (!model.content){
        model.content = [self makeContent:model.secondVoice];
    }
    CGRect textRect = [model.content boundingRectWithSize:CGSizeMake(MAXFLOAT,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kFontText} context:nil];
    
    CGFloat widthVoiceImage = 29*0.6;
    CGFloat heightVoiceImage = 33*0.6;
    
    CGFloat hOffsetVoice_Lable = 20;
    
    CGFloat xBubble = kLeadingHead+kWidthHead+kOffsetHHeadToBubble;
    CGFloat yBubble = kTopHead+kOffsetTopHeadToBubble;
    CGFloat widthBubble = kHOffsetVoiceImage_BubbleView*2 +widthVoiceImage+hOffsetVoice_Lable+textRect.size.width;
    CGFloat heightBubble = textRect.size.height + 2*kVOffsetSecondLable_BubbleView;
    
    CGFloat yVoiceImage = yBubble+(heightBubble-heightVoiceImage)/2;
    CGFloat xVoiceImage = xBubble+kHOffsetVoiceImage_BubbleView;
    CGFloat xSecondLable = xBubble + kHOffsetVoiceImage_BubbleView+widthVoiceImage+hOffsetVoice_Lable;
    if (dict && model) {
        if ([model.isSender boolValue]) {
            [dict setObject:[NSValue valueWithCGRect:CGRectMake(width-xBubble-widthBubble,yBubble, widthBubble,heightBubble)] forKey:@"mBubbleImageView"];
            
            [dict setObject:[NSValue valueWithCGRect:CGRectMake(width-xVoiceImage-widthVoiceImage, yVoiceImage,widthVoiceImage, heightVoiceImage)] forKey:@"mVoiceImageView"];
            
            [dict setObject:[NSValue valueWithCGRect:CGRectMake(width-xSecondLable-textRect.size.width,yBubble+kVOffsetSecondLable_BubbleView, textRect.size.width, textRect.size.height)] forKey:@"mSecondLable"];
            
        }else{
            
            [dict setObject:[NSValue valueWithCGRect:CGRectMake(xBubble, yBubble,widthBubble,heightBubble)] forKey:@"mBubbleImageView"];
            
            [dict setObject:[NSValue valueWithCGRect:CGRectMake(xVoiceImage,yVoiceImage,widthVoiceImage, heightVoiceImage)] forKey:@"mVoiceImageView"];
            
            [dict setObject:[NSValue valueWithCGRect:CGRectMake(xSecondLable,yBubble+kVOffsetSecondLable_BubbleView, textRect.size.width, textRect.size.height)] forKey:@"mSecondLable"];
        }
        [dict setObject:@(80) forKey:@"height"];
        return @{@(width):dict};
    }
    return dict;
}


+(NSString*)makeContent:(NSNumber*)secondVoice
{
    NSString *voiceStr = nil;
    NSInteger second = secondVoice.integerValue;
    
    if (second >= 60){
        voiceStr = [NSString stringWithFormat:@"%ld'%ld''",second/60,second%60];
    }else{
        voiceStr = [NSString stringWithFormat:@"%@''",secondVoice];
    }
    return  voiceStr;
}


-(void)longPress:(UILongPressGestureRecognizer *)Press
{
    if (Press.state == UIGestureRecognizerStateBegan)
    {
        [self becomeFirstResponder];
        
        UIMenuItem *remove = [[UIMenuItem alloc]initWithTitle:@"删除" action:@selector(menuRemove:)];
        
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:@[remove]];
        [menu setTargetRect:mBubbleImageView.frame inView:self];
        [menu setMenuVisible:YES animated:YES];
        
    }
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return  (action == @selector(menuRemove:));
}


#pragma mark --删除处理

-(void)menuRemove:(id)sender
{
    [self routerEventWithType:EventChatCellRemoveEvent userInfo:@{kModelKey:model}];
}


-(void)voiceBeenTaped:(UITapGestureRecognizer*)tap
{
    mVoiceImageView.isAnimating?[mVoiceImageView stopAnimating]:[mVoiceImageView startAnimating];
}

@end
