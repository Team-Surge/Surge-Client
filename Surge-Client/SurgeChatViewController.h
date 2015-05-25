//
//  ChatViewController.h
//  Surge-Client
//
//  Created by Dustin Guerrero on 5/24/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessages.h>

@interface SurgeChatViewController : JSQMessagesViewController <JSQMessagesCollectionViewDataSource, JSQMessagesCollectionViewDelegateFlowLayout, NSStreamDelegate>

@end
