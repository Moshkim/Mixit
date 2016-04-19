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
    fn = [fn stringByReplacingOccurrencesOfString:  @"file://" withString: @""];
    
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

- (int) openOutputFiles: (NSString*) inputFile streamIndex:(int)streamIndex {
    
    AVStream *out_stream;
    AVStream *in_stream;
    AVCodecContext *dec_ctx, *enc_ctx;
    AVCodec *encoder;
    int ret;
    unsigned int i;
    
    //
    //
    // Create Format Context
    //
    
    self->outFormatContextsLen = 0;
    
    
    AVFormatContext *outFormatCtx = NULL;
    AVDictionary *opts = 0;
    
    
    ///
    // broken ffmpeg default settings detected
    // use an encoding preset (e.g. -vpre medium)
    // preset usage: -vpre <speed> -vpre <profile>
    // speed presets are listed in x264 --help
    //
    
    av_dict_set(&opts, "vpreset", "fast", 0); //this preset setting doesn't work but it should some bug in ffmpeg
    //av_dict_set(&opts, "tune", "zerolatency", 0);
    //av_dict_set(&opts, "profile", "baseline", 0);
    
    
    
    for (i = 0; i < inFormatCtx->nb_streams; i++) {

        //FIND AUDIO
        if (self->inFormatCtx->streams[i]->codec->codec_type == AVMEDIA_TYPE_AUDIO) {
        
            
            //number of channels in audio
            int nb_channels = self->inFormatCtx->streams[i]->codec->channels;

            
           
            ////
            ///
            //
            // add context for all channels
            //
            ///
            ////
            
            for (int c = 0; c < nb_channels; c++) {
                
                
                ////
                ///
                // compute filename
                //
                ///
                ////
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                
                NSString *ifile = [inputFile stringByDeletingPathExtension];
                
                
                NSString* outputFile = [NSString stringWithFormat:@"%@_%i.m4a", ifile, c];
                

                //
                // check if the file exists
                //
                
                BOOL b = [fileManager removeItemAtPath:outputFile error:NULL];
                
                if(b) {
                    NSLog(@"File %@ already existed. overwritting...", outputFile);
                }
                
                //
                // convert name to non %20
                //
                
                const char *filename = [outputFile cStringUsingEncoding:[NSString defaultCStringEncoding]];
                NSString* fn = [NSString stringWithFormat:@"%s" , filename];
                NSString *decoded = [fn stringByRemovingPercentEncoding];
                
                const char* decodedFilename = [decoded UTF8String];
                
                
                ////
                ///
                //
                // create output format contex for the file
                //
                ///
                ////
                
                avformat_alloc_output_context2(&outFormatCtx, NULL, NULL, decodedFilename);
                
                if (!outFormatCtx) {
                    av_log(NULL, AV_LOG_ERROR, "Could not create output context\n");
                    return AVERROR_UNKNOWN;
                }
                
                outFormatCtx->strict_std_compliance = FF_COMPLIANCE_EXPERIMENTAL;
                
                
                //
                // create out streams in context (must be all for all contexts)
                //
                
                for( int j = 0; j < inFormatCtx->nb_streams; j++ ) {
                    
                    in_stream = self->inFormatCtx->streams[j];
                    dec_ctx = in_stream->codec;

                    out_stream = avformat_new_stream(outFormatCtx, NULL);
                    
                    if (!out_stream) {
                        av_log(NULL, AV_LOG_ERROR, "Failed allocating output stream\n");
                        return AVERROR_UNKNOWN;
                    }
                    
                    // duplicate context from input
                    out_stream->time_base = in_stream->time_base;
                    
                }
                
                /* if this stream must be remuxed with sound codec */
                ret = avcodec_copy_context(outFormatCtx->streams[i]->codec,
                                           inFormatCtx->streams[i]->codec);
                
                
                if (ret < 0) {
                    av_log(NULL, AV_LOG_ERROR, "Copying stream context failed\n");
                    return ret;
                }
                
                
                if (outFormatCtx->oformat->flags & AVFMT_GLOBALHEADER) {
                    outFormatCtx->streams[i]->codec->flags |= AV_CODEC_FLAG_GLOBAL_HEADER;
                }
                
                if( ENCODE_MONO ) {
                    outFormatCtx->streams[i]->codec->channels = 1;
                    outFormatCtx->streams[i]->codec->channel_layout = AV_CH_LAYOUT_MONO;
                    
                }
                
                ///
                //
                // open encoder for audio stream (i)
                //
                ///
                
                enc_ctx = outFormatCtx->streams[i]->codec;
                enc_ctx->strict_std_compliance = FF_COMPLIANCE_EXPERIMENTAL; // AAC is experimental in ffmpeg
                
                encoder = avcodec_find_encoder(enc_ctx->codec_id);
                ret = avcodec_open2(enc_ctx, encoder, &opts);
                
                if (ret < 0) {
                    av_log(NULL, AV_LOG_ERROR, "Cannot open video encoder for stream #%u\n, errr: %i", i, ret);
                    return ret;
                }
                
                
                ////
                ///
                //
                //  open file
                //
                ///
                ////
                
                av_dump_format(outFormatCtx, 0, decodedFilename, 1);
                
                if (!(outFormatCtx->oformat->flags & AVFMT_NOFILE)) {
                    ret = avio_open(&outFormatCtx->pb, decodedFilename, AVIO_FLAG_WRITE);
                    if (ret < 0) {
                        av_log(NULL, AV_LOG_ERROR, "Could not open output file '%s'", decodedFilename);
                        return ret;
                    }
                }
                
                /* init muxer, write output file header */
                ret = avformat_write_header(outFormatCtx, NULL);
                if (ret < 0) {
                    av_log(NULL, AV_LOG_ERROR, "Error occurred when opening output file\n");
                    return ret;
                }
                
                //
                // store context for future reference
                //
                
                [self addOutFormatContext: outFormatCtx];
                [self->outputFiles addObject: decoded];
            }
            
            
         }// if audio

        
    } //for
    

    
    
    return 0;
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
    
    if ((ret = [self openOutputFiles: inputFile streamIndex:i]) < 0) {
        NSLog(@"openOutputFile failed");
        return -1;
    }
    
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
    
        /* break after crossing -t time */
        
        // use the packet decode timestamp as pts
        double dts = (double)packet.dts;
        
        // multiply by time base to get the time offset
        AVStream* pStream = inFormatCtx->streams[stream_index];
        double avq2d = av_q2d(pStream->time_base);
        double sec = (dts - inFormatCtx->start_time) * avq2d;
        double progress = sec/(inFormatCtx->duration* avq2d);
        
        if(type == AVMEDIA_TYPE_AUDIO) {
            if( progress >= 1 ) {
                //NSLog(@"finishing... toTime: %f, %f", progress, sec);
                [self.delegate onProgressUpdate: 1];
                [self.delegate onDownloadSuccess];
                break;
            } else if(packet.dts%30 == 0) {
                //NSLog(@"time: %f, %f", progress, sec);
                [self.delegate onProgressUpdate: progress];
                
            }
        
        }
        
        ///
        ///
        ///  DECODE AUDIO PACKET
        ///
        
        AVCodecContext* dec_ctx = inFormatCtx->streams[stream_index]->codec;
        
        int ret;
        int got_frame = 0;
        int enc_got_frame = 0;
        
        AVPacket enc_pkt;
        
        AVFrame *frame = NULL;
        frame = av_frame_alloc();
        
        ret = avcodec_decode_audio4(dec_ctx,
                                    frame,
                                    &got_frame,
                                    &packet);
        
        

       int nchannels = dec_ctx->channels;
        
       if (got_frame) {
           
            //
            ///
            /// for all channels
            ///
            //
        
            for( int c = nchannels - 1; c >= 0; c-- ) {
                
                AVFormatContext* outFormatCtx = [self getOutFormatContextForChannel:c];
                AVCodecContext* enc_ctx = outFormatCtx->streams[stream_index]->codec;

            
                /// duplicate frame
                
                int ret = 0;
            
                AVFrame* frame_copy = av_frame_alloc();
                ret = av_frame_ref(frame_copy, frame);
                
                if( !ENCODE_MONO ) {
                
                    for (int cc = 0; cc < nchannels; cc++) {
                        if(c != cc) {
                            if(frame_copy->extended_data[cc] != NULL) {
                                memset(frame_copy->extended_data[cc], 0, frame_copy->linesize[0]); //silence
                            }
                        }
                    }
                
                } else {
                
                    //mono
                    memcpy(frame_copy->extended_data[0], frame_copy->extended_data[0], frame_copy->linesize[0]); //copy right channel to first
                    
                    //clear oher channels
                    for (int cc = 1; cc < nchannels; cc++) {
                        if(c != cc) {
                            if(frame_copy->extended_data[cc] != NULL) {
                                memset(frame_copy->extended_data[cc], 0, frame_copy->linesize[0]); //silence
                            }
                        }
                    }
                    
                }
                
                
                /// encode

                frame_copy->pts = av_frame_get_best_effort_timestamp(frame);
                frame_copy->pict_type = AV_PICTURE_TYPE_NONE;
                
                if(ENCODE_MONO) {
                    
                    frame_copy->channels = 1;
                    frame_copy->channel_layout = AV_CH_LAYOUT_MONO;
                    
                }

                enc_pkt.data = NULL;
                enc_pkt.size = 0;
                enc_pkt.pts = packet.pts;
                enc_pkt.dts = packet.dts;
                
                av_init_packet(&enc_pkt);

                ret = avcodec_encode_audio2(enc_ctx, &enc_pkt,
                               frame_copy, &enc_got_frame);

                //printf("Encode 1 Packet\tsize:%d\tpts:%lld\n",enc_pkt.size,enc_pkt.pts);

                if (ret < 0) {
                    NSLog(@"Encoding failed");
                    return -1;
                }

                av_packet_rescale_ts(&enc_pkt,
                                     inFormatCtx->streams[stream_index]->time_base,
                                     outFormatCtx->streams[stream_index]->time_base);
            
                // write to file
                
                
                ret = av_interleaved_write_frame(outFormatCtx, &enc_pkt);
                
                if (ret < 0) {
                    break;
                }
                
                av_frame_free(&frame_copy);
                
            } //for all channels
        
            av_frame_free(&frame);
            av_packet_unref(&packet);
            
            if (!enc_got_frame) {
                //NSLog(@"End of packet");
                continue;
            }
           
        }//got frame

        
    } //while
    

    //end
    
    av_packet_unref(&packet);
    av_frame_free(&frame);
    
    int nb_channels = self->outFormatContextsLen;
    
    for (i = 0; i < nb_channels; i++) {
        
        AVFormatContext *outFormatCtx = [self getOutFormatContextForChannel: i];
        av_write_trailer(outFormatCtx);
        
        
        if (outFormatCtx && !(outFormatCtx->oformat->flags & AVFMT_NOFILE)) {
            avio_closep(&outFormatCtx->pb);
        }
        
        avformat_free_context(outFormatCtx);
        
//        if (ret < 0) {
//            av_log(NULL, AV_LOG_ERROR, "Error occurred: %s\n", av_err2str(ret));
//            return -1;
//        }
    }
    
    avformat_close_input(&inFormatCtx);

    NSLog(@"FINISHED.");
    
    return nb_channels;
}





@end