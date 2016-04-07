#import "FileSpliter.h"
#import "Utilities.h"

#include "libswresample/swresample.h"
#include "libavutil/samplefmt.h"
#include "libavutil/opt.h"


@implementation FileSpliter {

    NSMutableArray *outputFiles;
    AVFormatContext* outFormatContexts[MAX_STREAM_NR];
    int outFormatContextsLen;
}


- (id)initWithURL:(NSString *)moviePath
{
    self->url = moviePath;
    
    // Register all formats and codecs
    avcodec_register_all();
    av_register_all();
    avformat_network_init();
    
    self->outputFiles = [NSMutableArray array];
    self->outFormatContextsLen = 0;
    
    return self;
}

- (int) openInputFile: (NSString*) fileURL {
    
    int ret;
    unsigned int i;
    
    const char *filename = [fileURL cStringUsingEncoding:[NSString defaultCStringEncoding]];
    
    inFormatCtx = NULL;
    
    AVDictionary *options = NULL;
    av_dict_set(&options, "pattern_type", "none", 0);
    //av_dict_set(&options, "pixel_format", "rgb24", 0);

    char errbuf[100];
    
    NSString* fn = [NSString stringWithFormat:@"%s" , filename];
    NSString *decoded = [fn stringByRemovingPercentEncoding];
    
    if ((ret = avformat_open_input(&inFormatCtx, [decoded UTF8String], NULL, &options)) < 0) {
        av_strerror(ret, errbuf, sizeof(errbuf));
        av_log(NULL, AV_LOG_ERROR, "Cannot open input file %s\n", filename);
        return ret;
    }
    
    if ((ret = avformat_find_stream_info(inFormatCtx, NULL)) < 0) {
        av_log(NULL, AV_LOG_ERROR, "Cannot find stream information\n");
        return ret;
    }
    
    inFormatCtx->strict_std_compliance = FF_COMPLIANCE_EXPERIMENTAL;
    
    inFormatCtx->nb_streams = inFormatCtx->nb_streams > 2 ? 2 : inFormatCtx->nb_streams ; //XXX: a hack = only first two streams - audio and video
    
    for (i = 0; i < inFormatCtx->nb_streams; i++) {
        
        AVStream *stream;
        AVCodecContext *codec_ctx;
        stream = inFormatCtx->streams[i];
        
        codec_ctx = stream->codec;
      
        /* Reencode video & audio */
        
        if (codec_ctx->codec_type == AVMEDIA_TYPE_VIDEO
            || codec_ctx->codec_type == AVMEDIA_TYPE_AUDIO) {
        
            /* Open decoder */
            ret = avcodec_open2(codec_ctx,
                                avcodec_find_decoder(codec_ctx->codec_id), NULL);
            if (ret < 0) {
                av_log(NULL, AV_LOG_ERROR, "Failed to open decoder for stream #%u\n", i);
                return ret;
            }
        }
    }
    
    av_dump_format(inFormatCtx, 0, filename, 0);
    return 0;
}

- (void) addOutFormatContext: (AVFormatContext *) outFormatContext {
    self->outFormatContexts[self->outFormatContextsLen] = outFormatContext;
    self->outFormatContextsLen++;
}


-(AVFormatContext*) getOutFormatContextForChannel: (int)channelIndex {
    
    if( channelIndex >= self->outFormatContextsLen || channelIndex < 0) {
        return NULL;
    }
    
    return self->outFormatContexts[channelIndex];
}


- (int) splitFile
{
    NSString* inputFile = self->url;
    
    
    [self.delegate onProgressUpdate: 0];

    
    int ret;
    AVPacket packet = { .data = NULL, .size = 0 };
    AVFrame *frame = NULL;
    enum AVMediaType type;
    unsigned int stream_index;
    unsigned int i;
    
//    int got_frame;
//    int (*dec_func)(AVCodecContext *, AVFrame *, int *, const AVPacket *);
    
    //already initialized
    
    
    if ((ret = [self openInputFile: inputFile]) < 0) {
        NSLog(@"openInputFile failed");
        return -1;
    }
    
    /*if ((ret = [self openOutputFiles: inputFile streamIndex:i]) < 0) {
        NSLog(@"openOutputFile failed");
        return -1;
    }*/ // need to add back
    
    /* force first keyframe */
    
//    int justOnceFlag = AV_PKT_FLAG_KEY;
    
    
    /* read all packets */
    while (1) {
        
        if ((ret = av_read_frame(inFormatCtx, &packet)) < 0) {
            break;
        }
        
        stream_index = packet.stream_index;
        
        type = inFormatCtx->streams[stream_index]->codec->codec_type;
        

        
        //av_log(NULL, AV_LOG_DEBUG, "Demuxer gave frame of stream_index %u\n",
        //       stream_index);
        
        
        // XXX: only audio AVMEDIA_TYPE_AUDIO
        if(type != AVMEDIA_TYPE_AUDIO ) {
            continue;
        }
    }

    
    return 0;
}


@end