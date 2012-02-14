# Wat?
[Marketplace](http://www.marketplacemac.com/) is Craigslist without the ugly. Search across multiple regions and filter your results.

It's the first paid Mac app I ever released.

Unfortunately, I don't have the time to maintain and support it anymore. *But* there's still a group of people using the app, and goodness knows, Craigslist still has the ugly.

So after much deliberation, I've decided to open source it. I'm hoping someone can make something awesome from its ashes. There's plenty of potential. Here we go.

## Code
Mostly the code is a wreck. I learned as I went.

It was originally built on Mac OS X 10.5, but I did the bare minimum to get it to build for 10.7. There are some deprecated APIs that should be cleaned up.

### Interesting bits
Probably the most interesting and valuable part is the Craigslist scraping. See [SearchParser.m](https://github.com/joshaber/Marketplace/blob/master/Classes/SearchParser.m) and [SearchParseWorker.m](https://github.com/joshaber/Marketplace/blob/master/Classes/SearchParseWorker.m).

## The Future
As I said above, I don't have the time to maintain and support it. So I won't be accepting pull requests, but I will happily link to any interesting forks that are. Just let me know.

## License
Original BSD. Make it awesome. Let me know. Have fun kids.

```
Copyright (c) 2012, Josh Abernathy
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
3. All advertising materials mentioning features or use of this software must display the following acknowledgement: This product includes software developed by Josh Abernathy.
4. Neither the name of Josh Abernathy nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY JOSH ABERNATHY ''AS IS'' AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL JOSH ABERNATHY BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```