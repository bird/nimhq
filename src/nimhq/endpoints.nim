from cgi import encodeUrl

var
    endpointBase* = "https://api-quiz.hype.space/"

    endpointUsers* = endpointBase & "users/"
    endpointMe* = endpointUsers & "me/"
    endpointPayouts* = endpointMe & "payouts/"
    endpointShows* = endpointBase & "shows/"
    endpointSchedule* = endpointShows & "now?type=hq"
    endpointAvatarURL* = endpointMe & "avatarUrl/"
    endpointFriends* = endpointBase & "friends/"
    endpointVerifications* = endpointBase & "verifications/" 
    endpointEasterEggs* = endpointBase & "easter-eggs/"
    endpointAWS* = endpointBase & "credentials/s3"
    endpointMakeItRain* = endpointEasterEggs & "makeItRain/"
    endpointTokens* = endpointBase & "tokens/"
    endpointToken* = endpointMe & "token/"
    endpointGifts* = endpointBase & "gifts/"
    endpointDrops* = endpointGifts & "drops/"
    endpointDevices* = endpointMe & "devices/"

    endpointUser* = proc (uID: string): string = return endpointUsers & uID & "/"
    endpointClaim* = proc (gID: string): string = return endpointDrops & gID & "/claims"
    endpointFriend* = proc (uID: string): string = return endpointFriends & uID & "/"
    endpointDocuments* = proc (uID: string): string = return endpointUsers & uID & "/payouts/documents"
    endpointFriendRequest* = proc (uID: string): string = return endpointFriend(uID) & "requests/"
    endpointSearchUser* = proc (query: string): string = return endpointUsers & "?q=" & encodeUrl(query)