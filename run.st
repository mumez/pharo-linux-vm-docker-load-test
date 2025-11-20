| server client accepted |

Stdio stdout nextPutAll: ('Starting test:', DateAndTime current asString); lf; flush.

"Originally in https://github.com/pharo-project/pharo-vm/issues/1018"
server := Socket newTCP listenOn: 12345 backlogSize: 5.
[client := Socket newTCP connectTo: NetNameResolver localHostAddress port: 12345] fork.
server waitForConnectionFor: 30.
accepted := server accept.

(Delay forMilliseconds: 1000) wait.
"The following order is irrelevant if these are both done"
accepted sendData: (String new: 1 withAll: $a). 
(Delay forMilliseconds: 500) wait.
client destroy. 

Stdio stdout nextPutAll: ('Test completed: ', DateAndTime current asString); lf; flush.
