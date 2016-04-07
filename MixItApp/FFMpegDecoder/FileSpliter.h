#import <Foundation/Foundation.h>
#import "avformat.h"
#import "avcodec.h"
#import "avio.h"
#import "swscale.h"
#import <AudioToolbox/AudioQueue.h>
#import <AudioToolbox/AudioToolbox.h>
#import "FileSpliterDelegate.h"

#define MAX_STREAM_NR 100

#define ENCODE_MONO false


@interface FileSpliter : NSObject
{
    AVFormatContext *inFormatCtx;
    AVCodecContext *inCodecCtx;
    
//    AVFormatContext *outFormatCtx;
    AVCodecContext *outCodecCtx;
    
//    AVFrame *pFrame;
//    AVPacket packet;
    
    NSString* url;

}
- (id)  initWithURL:(NSString *)moviePath;
- (int) splitFile;

@property (nonatomic, retain) IBOutlet id<FileSpliterDelegate> delegate;

@end
