# zyrxog
## Optimization by Introspection


### i7-4790K CPU @ 4.40GHZ (Linux - x64)

| milliseconds | ldc 0.16.1 | clang 3.5 | gdc 4.9.2 | g++ 4.9.2 | dmd v2.069.2 | dmd v2.067.1 |
|--------------|------------|-----------|-----------|-----------|--------------|--------------|
| Put(easy)    | 0.642      | 1.450     | 0.838     | 1.473     | 2.665        | 2.991        |
| Put(hard)    | 1.483      | 1.970     | 1.712     | 2.071     | 4.415        | 4.665        |
| Get          | 95.409     | 101.087   | 122.735   | 125.310   | 116.273      | 117.834      |

### i7-5960X CPU @ 3.90GHZ (Windows - x64)

| milliseconds | ldc 0.16.1 | dmd v2.069.0 | VS2015 - C# | VS2013 - C# |
|--------------|------------|--------------|-------------|-------------|
| Put(easy)    | 0.727      | 1.961        | 2.3866      | 2.6501      |
| Put(hard)    | 1.667      | 2.999        | 4.4824      | 4.8575      |
| Get          | 108.110    | 125.199      | 161.3824    | 208.6069    |

### i5-4258U CPU @ 2.40GHZ (OS X - x64)

| milliseconds | ldc 0.16.1 | swift 1.1 (LLVM 3.5) | dmd v2.069.2 |
|--------------|------------|----------------------|--------------|
| Put(easy)    | 0.996      | 4.025                | 4.195        |
| Put(hard)    | 2.234      | 7.421                | 6.826        |
| Get          | 154.826    | 174.480              | 206.599      |
