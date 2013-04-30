//
//  OWRecordingController.h
//  OpenWatch
//
//  Created by Christopher Ballinger on 11/13/12.
//  Copyright (c) 2012 OpenWatch FPC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OWLocalRecording.h"

@interface OWRecordingController : NSObject


+ (OWRecordingController *)sharedInstance;

- (NSArray*) allManagedRecordings;
- (NSArray*) allLocalRecordings;

- (void) removeRecording:(NSManagedObjectID*)recordingID;

- (void) scanVideoDirectoryForChanges;
- (void) scanRecordingsForUnsubmittedData;
+ (OWLocalRecording*) localRecordingForObjectID:(NSManagedObjectID*)objectID;
+ (OWManagedRecording*) recordingForObjectID:(NSManagedObjectID*)objectID;
+ (NSURL*) detailPageURLForRecordingServerID:(int)serverID;

@end
