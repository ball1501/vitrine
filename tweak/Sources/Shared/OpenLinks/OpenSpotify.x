// Links opened into the app by the "Open in Spotify" Safari extensions of the EeveeSpotify family: their
// content script sends the open.spotify.com tab to spotify://eevee/open.spotify.com/…, Spotify's own scheme
// with a rewritten destination, which Spotify itself would refuse with "Couldn't Open Link". The https URL
// they mean is handed back in its place, so Spotify's own link handling runs on it; every other URL a scene
// is opened with is untouched.
#import "Core/SGCore.h"

%hook UIOpenURLContext
- (NSURL *)URL {
    NSURL *url = %orig;
    if (![url.host.lowercaseString isEqualToString:@"eevee"]) return url;
    NSURL *https = [NSURL URLWithString:[NSString stringWithFormat:@"https:/%@", url.path]];
    if (!https) return url;
    SGLog(@"open links: %@ -> %@", url, https);
    return https;
}
%end

%ctor {
    %init;
}
