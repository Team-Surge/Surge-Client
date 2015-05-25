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
  
  [self initNetworkCommunication];
  
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
  [self transmitMessage: text];

  [JSQSystemSoundPlayer jsq_playMessageSentSound];
  [self finishSendingMessageAnimated:YES];
}

- (void)didPressAccessoryButton:(UIButton *)sender
{
  // Do nothing, for now...
  [super didPressAccessoryButton: sender];
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
      break;
      
    default:
      NSLog(@"Unknown event");
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
  JSQMessage *newMessage = [JSQMessage messageWithSenderId:@"1" displayName:@"OtherGuy" text:msg];
  [self.messages addObject:newMessage];
  [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
  [self scrollToBottomAnimated:YES];
  [self finishReceivingMessageAnimated:YES];
  
}

- (void)transmitMessage:(NSString *)message
{
  NSLog(@"Sending %@", message);
  NSData *data = [[NSData alloc] initWithData:[message dataUsingEncoding:NSASCIIStringEncoding]];
  
  [_outputStream write:[data bytes] maxLength:[data length]];
}
@end
