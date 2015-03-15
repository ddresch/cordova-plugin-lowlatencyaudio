//
//  LowLatencyAudioAsset.h
//  LowLatencyAudioAsset
//
//  Created by Andrew Trice on 1/23/12.
//
// THIS SOFTWARE IS PROVIDED BY ANDREW TRICE "AS IS" AND ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
// EVENT SHALL ANDREW TRICE OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
// INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
// OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
// ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//


#import <Foundation/Foundation.h>
#import <AVFoundation/AVAudioPlayer.h>

@class LowLatencyAudioAsset;

@protocol LowLatencyAudioAssetDelegate <NSObject>
@optional
-(void)audioAssetFinishedPlaying:(LowLatencyAudioAsset*)asset withAsset:(AVAudioPlayer*)player context:(id)context succesfully:(BOOL)success;
-(void)audioAsset:(LowLatencyAudioAsset*)asset withError:(NSError*)error context:(id)context;
@end

@interface LowLatencyAudioAsset : NSObject<AVAudioPlayerDelegate> {
    NSMutableArray* voices;
    int playIndex;
    
}
@property(nonatomic,strong) NSMutableArray* errors;
@property(nonatomic,weak) id<LowLatencyAudioAssetDelegate> delegate;
@property(nonatomic,retain) id context;

-(id) initWithPath:(NSString*) path withVoices:(NSNumber*) numVoices withVolume:(NSNumber*) volume;
- (void) play;
- (void) stop;
- (void) loop;
- (void) unload;
@end
