# nimhq

nimhq is a HQ Trivia API wrapper written in nim.

### Usage
Install the package with `nimble`
```nim
nimble install nimhq
```
To use nimhq, you must import both `nimhq` and `json`
```nim
import nimhq, json
```
When compiling, you must define a conditional symbol of `SSL`, to enable SSL support. For example:
```sh
nim c -d:SSL -r file.nim
```

### Example Usage

Creating a new hqClient to interface with the API
```nim
let client = hqClient(loginToken="ac4321NGx06pCFVHZEfSmD4k5caYE3NbR8utLrvduGJPYGTpkoctVdMGukC5VMFF")
```
Displaying the schedule
```nim
echo client.schedule()
```
Changing a username
```nim
discard(client.changeUsername("ExampleUsername123"))
```

### A note on Nim Limitations

This wrapper was originally inteded to use types, which, for example, would have changed `echo client["accessToken"]` to `echo client.accessToken`. While that would be much more preferred, Nim does not *currently* support types than can vary, as parts of the HQ Trivia API change the type of data they return. As such, using `JsonNode`'s was the best possible solution, despite being the less desirable one. If Nim adds support for this in the future, usage of types may be revisited.


License
----

MIT

