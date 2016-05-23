//
//  ECFromTableViewCell.m
//  EasyChat
//
//  Created by wanghu on 16/5/9.
//  Copyright © 2016年 wanghu. All rights reserved.
//

#import "ECFromTableViewCell.h"
@interface ECFromTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@end

@implementation ECFromTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0];
//    self.titleBtton.titleLabel.backgroundColor = [UIColor redColor];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setMessage:(EMMessage *)message
{
    _message = message;
    
    EMMessageBody *msgBody = message.body;
    switch (msgBody.type) {
        case EMMessageBodyTypeText:
        {
            // 收到的文字消息
            EMTextMessageBody *textBody = (EMTextMessageBody *)msgBody;
            self.messageLabel.text = textBody.text;
        }
            break;
        case EMMessageBodyTypeImage:
        {
            // 收到的文字消息
            EMImageMessageBody *imageBody = (EMImageMessageBody *)msgBody;
            UIImage *image = [UIImage imageWithContentsOfFile:imageBody.thumbnailLocalPath];
            NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
            attachment.image = image;
            attachment.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
            self.messageLabel.attributedText = [NSAttributedString attributedStringWithAttachment:attachment];
        }
            break;
        case EMMessageBodyTypeLocation:
            break;
        case EMMessageBodyTypeVoice:
            break;
        case EMMessageBodyTypeVideo:
            break;
        case EMMessageBodyTypeFile:
            
        default:
            break;
    }
    
}

- (CGFloat)cellHeight
{
    [self layoutIfNeeded];
    return CGRectGetMaxY(self.bgImageView.frame) + 10;
}

@end
