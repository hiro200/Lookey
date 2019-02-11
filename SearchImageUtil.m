//
//  SearchImageUtil.m
//  Lookey
//
//  Created by jg.hwang on 2015. 5. 3..
//  Copyright (c) 2015년 comants. All rights reserved.
//

#import "SearchImageUtil.h"

#import "AppDataManager.h"

@interface SearchImageResultObject : NSObject

@property (nonatomic, strong) NSString *resultCode;
@property (nonatomic, assign) float score;

@end

@implementation SearchImageResultObject

@end

@interface SearchImageUtil () <NSStreamDelegate>

@property (nonatomic, assign) id<SearchImageDelegate> delegate;
@property (nonatomic, strong) NSInputStream *inputStream;
@property (nonatomic, strong) NSOutputStream *outputStream;
@property (nonatomic, strong) NSMutableArray *resultList;

@property (nonatomic, strong) NSMutableData *sendSocketData;
@property (nonatomic, assign) int currentDataOffset;

@end

@implementation SearchImageUtil

@synthesize inputStream, outputStream, resultList, sendSocketData, currentDataOffset;

- (id) initWithDelegate: (id<SearchImageDelegate>) delegate
				  image: (UIImage*) image {
	if (self = [super init]) {
		
		self.delegate = delegate;
		self.resultList = [NSMutableArray array];
		
		CFReadStreamRef readStream;
		CFWriteStreamRef writeStream;
		NSString *serverURL = [AppDataManager appDataManager].IMAGE_SERVER_IP;
		CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)serverURL, 9877, &readStream, &writeStream);
		CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
		CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
		
		self.inputStream = (__bridge_transfer NSInputStream *)readStream;
		inputStream.delegate = self;
		[inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		[inputStream open];
		
		self.outputStream = (__bridge_transfer NSOutputStream *)writeStream;
		outputStream.delegate = self;
		[outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		[outputStream open];
		
        NSLog(@"Camera 2");
        
		NSData *imageData = UIImageJPEGRepresentation(image, 1);
		self.sendSocketData = [self makeSocketData: 5 imageData: imageData];
		currentDataOffset = 0;
        
        
	}
	return self;
}


- (NSMutableData*) makeSocketData: (int) maxResult imageData: (NSData*) imageData {
	NSMutableData *socketData = [NSMutableData data];
    
    NSLog(@"Camera 3");
    
	[socketData appendData: [NSData dataWithBytes: &maxResult length: sizeof(maxResult)]];
	
	int imageSize = (int) imageData.length;
	[socketData appendData: [NSData dataWithBytes: &imageSize length: sizeof(imageSize)]];
	[socketData appendData: imageData];
	return socketData;
}


#pragma mark - NSStreamDelegate

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
	
	switch (streamEvent) {
		
		case NSStreamEventOpenCompleted: {
			NSLog(@"NSStreamEventOpenCompleted");
			break;
		}
			
		case NSStreamEventHasSpaceAvailable: {
			if (theStream != outputStream) {
				return;
			}
			uint8_t *readBytes = (uint8_t *)[sendSocketData bytes];
			readBytes += currentDataOffset;
			NSUInteger dataLength = [sendSocketData length];
			NSInteger bytesWritten = [outputStream write: readBytes maxLength: dataLength - currentDataOffset];
			currentDataOffset += bytesWritten;
			break;
		}
		
		case NSStreamEventHasBytesAvailable: {
			if (theStream == inputStream) {
				
				uint8_t buffer[1024];
				long len;
				
				while ([inputStream hasBytesAvailable]) {
					len = [inputStream read:buffer maxLength:sizeof(buffer)];
					if (len > 0) {
						
						int index = 0;
						int resultNum = buffer[index];
						index += sizeof(int);
						
                        NSLog(@"Result Count : %d", resultNum);
                        
						for (int i = 0 ; i < resultNum ; i++) {
							SearchImageResultObject *result = [[SearchImageResultObject alloc] init];
							
							int size = buffer[index];
							index += 4;
							result.resultCode = [[NSString alloc] initWithBytes: &buffer[index] length: size encoding:NSASCIIStringEncoding];
							index += size;
							result.score = buffer[index];
							index += sizeof(float);
							[resultList addObject: result];
						}
					}
				}
			}
			break;
		}
		
		case NSStreamEventErrorOccurred: {
			NSLog(@"Can not connect to the host!");
			[_delegate searchImageResult: nil];
			break;
		}
		
		case NSStreamEventEndEncountered: {
			NSLog(@"NSStreamEventEndEncountered");
			theStream.delegate = nil;
			[theStream close];
			[theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
			if (theStream == inputStream) {
				self.outputStream = nil;
				self.inputStream = nil;
				if (resultList.count == 0) {
					[_delegate searchImageResult: nil];
				} else {
					SearchImageResultObject *result = resultList[0];
					[_delegate searchImageResult: result.resultCode];
				}
			}
			break;
		}
		
		default:
		NSLog(@"Unknown event");
		break;
	}	
}

@end
