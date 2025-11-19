| result |

Stdio stdout nextPutAll: 'Starting load test...'; lf; flush.

"CPU-intensive calculation to generate load"
result := 0.
1 to: 100000000 do: [ :i |
    result := result + (i factorial abs).
].

Stdio stdout nextPutAll: 'Load test completed. Result: ', result asString; lf; flush.
