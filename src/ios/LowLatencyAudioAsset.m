//
//  LowLatencyAudioAsset.m
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

#import "LowLatencyAudioAsset.h"

@implementation LowLatencyAudioAsset

-(id) initWithPath:(NSString*) path withVoices:(NSNumber*) numVoices withVolume:(NSNumber*) volume
{
    self = [super init];
    if(self) {
        voices = [[NSMutableArray alloc] init];
        self.errors = [[NSMutableArray alloc] init];
        
        NSURL *pathURL = [NSURL fileURLWithPath : path];
        
        for (int x = 0; x < [numVoices intValue]; x++) {
            NSError *error=nil;
            AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:pathURL error: &error];
            if (player)
            {
                player.volume = volume.floatValue;
                player.delegate = self;
                [player prepareToPlay];
                [voices addObject:player];
            }else{
                if (error)
                {
                    [self.errors addObject:error];
                }
            }
            
        }
        
        playIndex = 0;
    }
    return(self);
}

- (void) play
{
    AVAudioPlayer * player = [voices objectAtIndex:playIndex];
    [player setCurrentTime:0.0];
    player.numberOfLoops = 0;
    [player play];
    playIndex += 1;
    playIndex = playIndex % [voices count];
}

- (void) stop
{
    for (int x = 0; x < [voices count]; x++) {
        AVAudioPlayer * player = [voices objectAtIndex:x];
        [player stop];
    }
}

- (void) loop
{
    [self stop];
    AVAudioPlayer * player = [voices objectAtIndex:playIndex];
    [player setCurrentTime:0.0];
    player.numberOfLoops = -1;
    [player play];
    playIndex += 1;
    playIndex = playIndex % [voices count];
}

- (void) unload 
{
    [self stop];
    for (int x = 0; x < [voices count]; x++) {
        AVAudioPlayer * player = [voices objectAtIndex:x];
        player = nil;
    }
    voices = nil;
}

#pragma mark - AVAudioPlayerDelegate methods

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag
{
    [self.delegate audioAssetFinishedPlaying:self withAsset:player context:self.context succesfully:flag];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player
                                 error:(NSError *)error
{
    [self.delegate audioAsset:self withError:error context:self.context];
}

@end
