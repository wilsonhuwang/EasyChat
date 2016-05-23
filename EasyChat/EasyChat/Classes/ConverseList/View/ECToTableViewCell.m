//
//  ECToTableViewCell.m
//  EasyChat
//
//  Created by wanghu on 16/5/9.
//  Copyright © 2016年 wanghu. All rights reserved.
//

#import "ECToTableViewCell.h"
@interface ECToTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@end

@implementation ECToTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0];
//    self.titleButton.titleLabel.backgroundColor = [UIColor redColor];
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
//            self.titleButton.titleLabel.text = textBody.text;
//            [self.titleButton setTitle:textBody.text forState:UIControlStateNormal];
            self.messageLabel.text = textBody.text;
        }
            break;
        case EMMessageBodyTypeImage:
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

@end
