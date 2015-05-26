//
//  ChatViewController.m
//  Surge-Client
//
//  Created by Dustin Guerrero on 5/24/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

#import "SurgeChatViewController.h"
#import "Surge_Client-Swift.h"

@interface SurgeChatViewController ()
@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;
@property (strong) NSInputStream *inputStream;
@property (strong) NSOutputStream *outputStream;
@property BOOL chatDoesExist;
@property NSInteger conversationID;
@property NSInteger userID;
@end

@implementation SurgeChatViewController

#pragma mark - View Lifetime
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
  self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleBlueColor]];
  self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
  
  self.title = @"Messaging";
  self.senderId = @"-1";
  self.senderDisplayName = @"Self";
  self.messages = [[NSMutableArray alloc] init];
  
  self.showLoadEarlierMessagesHeader = NO;
  
  //[self initNetworkCommunication];
  [SurgeChatAPIRequests createChatFromCommentWithID:[self.parentCommentID integerValue]
                                           callBack:^(NSInteger conversationID) {self.conversationID = conversationID;}];
  
  [SurgeChatAPIRequests getUserID:^(NSNumber *id) {
    self.userID = [id integerValue];
    [self updatePosts];
    NSString *msg = [SurgeChatAPIRequests getChatServerConnectMessage:self.userID];
    [self transmitMessage:msg];
  }];
  //[self updatePosts];
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date
{
  JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
                                           senderDisplayName:senderDisplayName
                                                        date:date
                                                        text:text];
  [self.messages addObject:message];
  assert(self.conversationID > 0);
  [SurgeChatAPIRequests sendMessageWithConversationID:self.conversationID message:text];

  [JSQSystemSoundPlayer jsq_playMessageSentSound];
  [self finishSendingMessageAnimated:YES];
}

- (void)didPressAccessoryButton:(UIButton *)sender
{
  [self updatePosts];
}

#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
  return [self.messages objectAtIndex:[indexPath row]];
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
  // No avatars
  return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
  JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
  
  if ([message.senderId isEqualToString:self.senderId]) {
    return nil;
  }
  
  if (indexPath.item - 1 > 0) {
    JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
    if ([[previousMessage senderId] isEqualToString:message.senderId]) {
      return nil;
    }
  }
  
  return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
  JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
  
  if ([message.senderId isEqualToString:self.senderId]) {
    return self.outgoingBubbleImageData;
  }
  
  return self.incomingBubbleImageData;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return [self.messages count];
}


#pragma mark - Network Methods

- (void)initNetworkCommunication {
  CFReadStreamRef readStream;
  CFWriteStreamRef writeStream;
  CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"surge.seektom.com", 8000, &readStream, &writeStream);
  _inputStream = (NSInputStream *)CFBridgingRelease(readStream);
  _outputStream = (NSOutputStream *)CFBridgingRelease(writeStream);
  
  [_inputStream setDelegate:self];
  [_outputStream setDelegate:self];
  
  [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
  [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

  [_inputStream open];
  [_outputStream open];
  
  
}

- (void) viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [_inputStream close];
  [_outputStream close];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [self initNetworkCommunication];
  
}

- (void)stream:(NSStream *)sender handleEvent:(NSStreamEvent)streamEvent
{
  
  switch (streamEvent) {
      
    case NSStreamEventOpenCompleted:
      
      NSLog(@"Stream opened");
      break;
      
    case NSStreamEventHasBytesAvailable:
      if (sender == _inputStream) {
        [self receiveMessage];
      }
      break;
      
    case NSStreamEventErrorOccurred:
      NSLog(@"NSStreamEventErrorOccured");
      break;
      
    case NSStreamEventEndEncountered:
      NSLog(@"Connection Closed");
      break;
      
    case NSStreamEventNone:
    default:
      break;
  }
  
}

- (void)receiveMessage
{
  uint8_t buffer[1024];
  int len;
  
  NSString *msg = @"";
  while ([_inputStream hasBytesAvailable]) {
    len = [_inputStream read:buffer maxLength:sizeof(buffer)];
    if (len > 0) {
      NSString *chunk = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
      msg = [msg stringByAppendingString:chunk];
    }
  }
  
  NSLog(@"Received message: %@", msg);
  NSError *error = nil;

  id object = [NSJSONSerialization
               JSONObjectWithData:[msg dataUsingEncoding:NSASCIIStringEncoding]
               options:0
               error:&error];
  
  if (error) {
    NSLog(@"Error: %@", error);
  } else if (![object isKindOfClass:[NSDictionary class]]) {
    NSLog(@"Failed to receive message");
  } else {
    NSDictionary *results = object;
    NSDictionary *message = [results objectForKey:@"message"];
    NSLog(@"Message: %@", message[@"content"]);
    
    NSNumber *number = message[@"tid"];
    NSString *senderID = [number stringValue];
    JSQMessage *newMessage = [JSQMessage messageWithSenderId: senderID displayName:@"OtherGuy" text:message[@"content"]];
    [self.messages addObject:newMessage];
    [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
    [self scrollToBottomAnimated:YES];
    [self finishReceivingMessageAnimated:YES];
  }
  
  /*
    NSDictionary *results = object;
    id object2 = [NSJSONSerialization
                 JSONObjectWithData:[results[@"message"] dataUsingEncoding:NSASCIIStringEncoding]
                 options:0
                 error:&error];
    if (error) {
      NSLog(@"Error: %@", error);
    } else {
      NSDictionary *message = object2;
      JSQMessage *newMessage = [JSQMessage messageWithSenderId:@"1" displayName:@"OtherGuy" text:message[@"content"]];
      [self.messages addObject:newMessage];
      [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
      [self scrollToBottomAnimated:YES];
      [self finishReceivingMessageAnimated:YES];
  }*/
}

- (void)transmitMessage:(NSString *)message
{
  NSLog(@"Sending %@", message);
  NSData *data = [[NSData alloc] initWithData:[message dataUsingEncoding:NSASCIIStringEncoding]];
  
  [_outputStream write:[data bytes] maxLength:[data length]];
}

#pragma mark - API Methods

- (void) createChat
{
  /*
    let request = HTTPTask()
    let lastLocation = LocationManager.sharedInstance().lastLocation
    let params: [String:AnyObject] = ["action": "postCreate", "handle": handleField.text, "content": textView.text, "lat": toString(lastLocation.coordinate.latitude), "lng": toString(lastLocation.coordinate.longitude)]
    
    if hasValidPostText() == false {
      return
    }
    
    request.POST("http://surge.seektom.com/post", parameters: params,
      success: {(response: HTTPResponse) in
      }, failure: {(error: NSError, response: HTTPResponse?) in
        SurgeToast.showError("Failed to create post", onCompletion: ({_ in}))
      }
    )*/
  
  
}

-(void) updatePosts
{
  
  [SurgeChatAPIRequests getConversationByCommentID:[self.parentCommentID integerValue]
                                          callBack:^(ChatMessageResponse *response) {
                                            NSLog(@"Received message subject: %@", response.subject);
                                            self.senderId = [NSString stringWithFormat: @"%ld", (long)response.id];
                                            self.senderDisplayName = [NSString stringWithFormat: @"%ld", (long)response.id];
                                            self.conversationID = response.conversationID;
                                            [self.messages removeAllObjects];
                                            for (ChatMessage *msg in response.messages) {
                                              NSString *senderID = [NSString stringWithFormat: @"%ld", (long)msg.senderID];
                                              JSQMessage *newMessage = [JSQMessage messageWithSenderId:senderID displayName:senderID text:msg.content];
                                              [self.messages addObject:newMessage];
                                              dispatch_async(dispatch_get_main_queue(),
                                                             ^{
                                                               [self finishReceivingMessageAnimated:YES];
                                                             });
                                              
                                            }
                                          }];
}

@end

