@protocol FileSpliterDelegate <NSObject>

- (void)onProgressUpdate: (double) progress;
- (void)onDownloadSuccess;

@end