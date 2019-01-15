import httpclient, json, nimhq/endpoints

## Due to limitations of Nim, typed responses cannot be used.
## Instead, most functions return a JsonNode. 

proc request (a: JsonNode, requestMethod: HttpMethod, urlStr: string, requestBody: JsonNode, auth: bool): JsonNode =
    let client = newHttpClient()
    client.headers = newHttpHeaders({ 
        "Content-Type": "application/json",
        "x-hq-client": "iOS/1.3.29 b123",
        "User-Agent": "HQ-iOS/123 CFNetwork/975.0.3 Darwin/18.2.0",
    })
    if auth:
        client.headers["Authorization"] = "Bearer " & a["accessToken"].getStr()
    let response = client.request(url = urlStr, httpMethod = requestMethod, body = $requestBody)
    return parseJson(response.body)
    
proc tokens* (a: JsonNode): JsonNode =
    ## Returns token information for an account.
    let requestBody = %*{
        "token": a["loginToken"]
    }
    return request(a, HttpPost, endpointTokens, requestBody, false)

proc me* (a: JsonNode): JsonNode =
    ## Returns basic information for an account.
    return request(a, HttpGet, endpointMe, %*{}, true)

proc payouts* (a: JsonNode): JsonNode = 
    ## Returns an array of payouts for an account.
    return request(a, HttpGet, endpointPayouts, %*{}, true)

proc schedule* (a: JsonNode): JsonNode =
    ## Returns a schedule of games accessible to an account.
    return request(a, HttpGet, endpointSchedule, %*{}, true)

proc makeItRain* (a: JsonNode): bool =
    ## Performs the "swipe trick" on an account.
    return request(a, HttpPost, endpointMakeItRain, %*{}, true)["result"].getBool()

proc refreshLogin* (a: JsonNode): JsonNode =
    ## Refreshes the login associated with an account.
    return request(a, HttpGet, endpointToken, %*{}, true)

proc claim* (a: JsonNode, gID: string): bool =
    ## Claims a gift to an account.
    return request(a, HttpPost, endpointClaim(gID), %*{}, true).getBool()

proc changeUsername* (a: JsonNode, username: string): JsonNode =
    ## Changes an accounts username.
    let requestBody = %*{
        "username": username
    }
    return request(a, HttpPatch, endpointMe, requestBody, true)

proc searchUser* (a: JsonNode, username: string): JsonNode =
    ## Searches for a specified username.
    return request(a, HttpGet, endpointSearchUser(username), %*{}, true)

proc addFriend* (a: JsonNode, uID: string): bool =
    ## Adds a specified friend.
    let req = request(a, HttpPost, endpointFriendRequest(uID), %*{}, true)
    if req["status"].getStr() == "PENDING":
        return true
    return false

proc deleteFriend* (a: JsonNode, uID: string): bool =
    ## Deletes a specified friend.
    return request(a, HttpDelete, endpointFriendRequest(uID), %*{}, true)["result"].getBool()

proc requestAWS* (a: JsonNode): JsonNode = 
    ## Returns AWS information.
    return request(a, HttpGet, endpointAWS, %*{}, true)

proc verify* (number, verifyMethod: string): JsonNode =
    ## Verify a phone number via sms or call
    let requestBody = %*{
        "method": verifyMethod, 
        "phone": number
    }
    return request(%*{}, HttpPost, endpointVerifications, requestBody, false)

proc confirm* (verificationID, code: string): JsonNode =
    ## Confirms a verification session
    let requestBody = %*{
        "code": code
    }
    return request(%*{}, HttpPost, endpointVerifications & verificationID, requestBody, false)

proc create* (verificationID, username, referrer, region: string): JsonNode =
    ## Creates an account if a user doesnt exist.
    let requestBody = %*{
        "country": region, 
        "verificationId": verificationId, 
        "username": username, 
        "language": "en", 
        "referringUsername": referrer
    }
    return request(%*{}, HttpPost, endpointUsers, requestBody, false)

proc hqClient* (loginToken: string): JsonNode =
    ## Initializes a specified account.
    var account = %*{"loginToken": loginToken}  
    let tokens = tokens(account)
    account["accessToken"] = tokens["accessToken"]
    account["authToken"] = tokens["authToken"]
    account["loginToken"] = tokens["loginToken"]
    account["admin"] = tokens["admin"]
    account["guest"] = tokens["guest"]
    account["tester"] = tokens["tester"]
    let me = me(account)
    account["username"] = me["username"]
    account["userID"] = me["userId"]
    account["avatarURL"] = me["avatarUrl"]
    return account