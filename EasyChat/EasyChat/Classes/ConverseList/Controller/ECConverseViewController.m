//
//  ECConverseViewController.m
//  EasyChat
//
//  Created by wanghu on 16/5/22.
//  Copyright © 2016年 wanghu. All rights reserved.
//

#import "ECConverseViewController.h"
#import "EMSDK.h"
#import "ECToTableViewCell.h"
#import "ECFromTableViewCell.h"
@interface ECConverseViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, EMChatManagerDelegate>
@property (nonatomic, strong) NSMutableArray *news;
// 输入View的底部约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyViewBottomConstraint;
// 输入view的高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyViewHeight;
@property (weak, nonatomic) IBOutlet UITableView *contentView;
@property (weak, nonatomic) IBOutlet UIView *keyBoardView;
// 当前会话对象
@property (nonatomic, strong) EMConversation *currentConversation;
// 计算cell高度
@property (nonatomic, strong) ECFromTableViewCell *cellHeightTool;
@end

@implementation ECConverseViewController

static NSString *fromId = @"fromNew";
static NSString *toId = @"toNew";

- (NSMutableArray *)news
{
    if (!_news) {
        _news = [NSMutableArray array];
    }
    return _news;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 会话的各种设置
    [self conversationSet];
    // 加载历史消息
    [self loadHistoryNews];
    
}

- (void)conversationSet
{
    self.view.backgroundColor = ECGlobalBgColor;
    self.contentView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    // 获取会话
    self.currentConversation = [[EMClient sharedClient].chatManager getConversation:self.buddy type:EMConversationTypeChat createIfNotExist:YES];
    
    // 监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDiHiden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    //消息回调:EMChatManagerChatDelegate
    //注册消息回调
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    // 注册cell identifier
    [self.contentView registerNib:[UINib nibWithNibName:NSStringFromClass([ECFromTableViewCell class]) bundle:nil] forCellReuseIdentifier:fromId];
    [self.contentView registerNib:[UINib nibWithNibName:NSStringFromClass([ECToTableViewCell class]) bundle:nil] forCellReuseIdentifier:toId];
    
    self.cellHeightTool = [self.contentView dequeueReusableCellWithIdentifier:fromId];
}

// 键盘Hiden
- (void)keyboardDiHiden:(NSNotification *)note
{
    self.keyViewBottomConstraint.constant = 0;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.view layoutIfNeeded];
    }];
    [self scrollToBottom];
}
// 键盘Show
- (void)keyboardDidShow:(NSNotification *)note
{
//    CGRect keyF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
  
    CGRect keyF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyViewBottomConstraint.constant = keyF.size.height;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.view layoutIfNeeded];
    }];
    [self scrollToBottom];
}

- (void)loadHistoryNews
{
    NSArray *news = [self.currentConversation loadMoreMessagesFromId:nil limit:20 direction:EMMessageSearchDirectionUp];
    [self.news addObjectsFromArray:news];
    [self.contentView reloadData];
    [self scrollToBottom];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.news.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    EMMessage *messge = self.news[indexPath.row];
    if (messge.direction == EMMessageDirectionSend) {
        ECFromTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:fromId];
        cell.message = messge;
        return cell;
    } else {
        ECFromTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:toId];
        cell.message = messge;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.cellHeightTool.message = self.news[indexPath.row];
    return self.cellHeightTool.cellHeight;
}
// 发送文字
- (void)sendMessage:(NSString *)messageText
{
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:messageText];
    NSString *from = [[EMClient sharedClient] currentUsername];
    
    //生成Message
    EMMessage *message = [[EMMessage alloc] initWithConversationID:nil from:from to:self.buddy body:body ext:nil];
    message.chatType = EMChatTypeChat;// 设置为单聊消息
    //message.chatType = EMChatTypeGroupChat;// 设置为群聊消息
    //message.chatType = EMChatTypeChatRoom;// 设置为聊天室消息
    [self.news addObject:message];
    [self.contentView reloadData];
    
    [[EMClient sharedClient].chatManager asyncSendMessage:message progress:^(int progress) {
        
    } completion:^(EMMessage *message, EMError *error) {
        
    }];
}


- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat height = 0;
    CGFloat minHeight = 30;
    CGFloat maxHeight = 150;
    CGFloat contentHeight = textView.contentSize.height;
    if (contentHeight < minHeight) {
        height = minHeight;
    } else if (contentHeight > maxHeight) {
        height = maxHeight;
    } else {
        height = contentHeight;
    }
    self.keyViewHeight.constant = contentHeight + 7 * 2;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        // 监听send键点击
        [self sendMessage:textView.text];
        textView.text = nil;
        [textView setContentOffset:CGPointZero];
        [self scrollToBottom];
        [self textViewDidChange:textView];
        return NO;
    }
    
    return YES;
}


#pragma mark - EMChatManagerDelegate

/*!
 @method
 @brief 接收到一条及以上非cmd消息
 */
- (void)didReceiveMessages:(NSArray *)aMessages
{
    [self.news addObjectsFromArray:aMessages];
    [self.contentView reloadData];
    [self scrollToBottom];
}

// converseView 滚到底部
- (void)scrollToBottom
{
    if (self.news.count <= 0) return;
    NSIndexPath *index = [NSIndexPath indexPathForRow:self.news.count - 1 inSection:0];
    [self.contentView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (void)setBuddy:(NSString *)buddy
{
    _buddy = [buddy copy];
    self.title = buddy;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //移除消息回调
    [[EMClient sharedClient].chatManager removeDelegate:self];
}

@end
