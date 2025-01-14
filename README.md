[![Build Status][gh-actions-badge]][gh-actions]
[![LFE Versions][lfe-badge]][lfe]
[![Erlang Versions][erlang-badge]][versions]
[![Tags][github-tags-badge]][github-tags]
[![Downloads][hex-downloads]][hex-package]

[![Project Logo][logo]][logo-large]

# ljson

*A wrapper for `json` in the Erlang stdlib for 27+ and for `jsx` in Erlang 26 and below*


## About

ljson provides a very thin wrapper around the `encode/1`, `encode/2` functions of the jsx library when running in OTP versions 26 and below; it provides a similar wrapper for `encode/1`, `encode/3` when running in OTP 27 and above.

In both cases, binary is returned. Since Erlang 27's `json` returns an iolist, this does add a step for Erlang 27+ and breaks a bit of that compatibility in the interest of preserving more backwards compatibility for projects that have used jsx.

How long will this library be around? Until there's a better library easily usable from LFE projects, or until all supported Erlang versions have `json` and provide a backwards-compatible feature set, this library will be around.

## Usage

The following usage examples are from LFE, but the same applies to Erlang (though hyphens in the LFE function name can be replaced with underscores in the same Erlang function).

Encode simple LFE data to JSON:

```cl
lfe> (ljson:encode 'a)
#"\"a\""
lfe> (ljson:encode "a")
#"[97]"
lfe> (ljson:encode 1)
#"1"
lfe> (ljson:encode 3.14)
#"3.14"
lfe> (ljson:encode '(a b c 42))
#"[\"a\",\"b\",\"c\",42]"
lfe> (ljson:encode #m(a b))
#"{\"a\":\"b\"}"
lfe> (ljson:encode #m(a b c d))
#"{\"c\":\"d\",\"a\":\"b\"}"
```

Decode simple JSON:

```cl
lfe> (ljson:decode #"\"a\""))
#"a"
lfe> (ljson:decode #b("[97]"))
"a"
lfe> (ljson:decode #b("1"))
1
lfe> (ljson:decode #b("3.14"))
3.14
lfe> (ljson:decode #b("[\"a\",\"b\",\"c\",42]"))
(#"a" #"b" #"c" 42)
lfe> (ljson:decode #"{\"a\": \"b\"}")
#M(#"a" #"b")
lfe> (ljson:decode #"{\"a\":\"b\",\"c\":\"d\"}")
#M(#"a" #"b" #"c" #"d")
lfe> (ljson:decode
lfe>     #B(123 34 97 34 58 34 98 34 44 34 99 34 58 34 100 34 125))
#M(#"a" #"b" #"c" #"d")
```

Decode a JSON data structure (note that, for formatting purposes, the data
below has been presented separated with newlines; this won't work in the
LFE REPL -- you'll need to put it all on one line):

```cl
lfe> (set json-data #"{
  \"First Name\": \"Jón\",
  \"Last Name\": \"Þórson\",
  \"Is Alive?\": true,
  \"Age\": 25,
  \"Height_cm\": 167.6,
  \"Address\": {
    \"Street Address\": \"í Gongini 5 Postsmoga 108\",
    \"City\": \"Tórshavn\",
    \"Country\": \"Faroe Islands\",
    \"Postal Code\": \"100\"
  },
  \"Phone Numbers\": [
    {
      \"Type\": \"home\",
      \"Number\": \"20 60 30\"
    },
    {
      \"Type\": \"office\",
      \"Number\": \"+298 20 60 20\"
    }
  ],
  \"Children\": [],
  \"Spouse\": null}")
lfe> (set data (ljson:decode json-data))
#M(#"Address"
     #M(#"City" #"Tórshavn" #"Country" #"Faroe Islands"
        #"Postal Code" #"100"
        #"Street Address" #"í Gongini 5 Postsmoga 108")
   #"Age" 25 #"Children" () #"First Name" #"Jón" #"Height_cm" 167.6
   #"Is Alive?" true #"Last Name" #"Þórson"
   #"Phone Numbers"
     (#M(#"Number" #"20 60 30" #"Type" #"home")
      #M(#"Number" #"+298 20 60 20" #"Type" #"office"))
   #"Spouse" null)
```

Now let's take it full circle by encoding it again:

```cl
lfe> (ljson:encode data)
#"{\"Address\":{\"City\":\"Tórshavn\",\"Country\":\"Faroe Islands\",\"Postal Code\":\"100\",\"Street Address\":\"í Gongini 5 Postsmoga 108\"},\"Age\":25,\"Children\":[],\"First Name\":\"Jón\",\"Height_cm\":167.6,\"Is Alive?\":true,\"Last Name\":\"Þórson\",\"Phone Numbers\":[{\"Number\":\"20 60 30\",\"Type\":\"home\"},{\"Number\":\"+298 20 60 20\",\"Type\":\"office\"}],\"Spouse\":null}"
```

Let's do the same, but this time from LFE data:

```cl
lfe> (set lfe-data
   '#m(#"First Name" #"Jón"
       #"Last Name" #"Þórson"
       #"Is Alive?" true
       #"Age" 25
       #"Height_cm" 167.6
       #"Address" #m(#"Street Address" #"í Gongini 5 Postsmoga 108"
                     #"City" #"Tórshavn"
                     #"Country" #"Faroe Islands"
                     #"Postal Code" #"100")
       #"Phone Numbers" (#m(#"Type" #"home" #"Number" #"20 60 30")
                         #m(#"Type" #"office" #"Number" #"+298 20 60 20"))
       #"Children" ()
       #"Spouse" null))
(#(#B(...)))
lfe> (ljson:encode lfe-data)
#"{\"Address\":{\"City\":\"Tórshavn\",\"Country\":\"Faroe Islands\",\"Postal Code\":\"100\",\"Street Address\":\"í Gongini 5 Postsmoga 108\"},\"Age\":25,\"Children\":[],\"First Name\":\"Jón\",\"Height_cm\":167.6,\"Is Alive?\":true,\"Last Name\":\"Þórson\",\"Phone Numbers\":[{\"Number\":\"20 60 30\",\"Type\":\"home\"},{\"Number\":\"+298 20 60 20\",\"Type\":\"office\"}],\"Spouse\":null}"
```

## License 

Apache Version 2 License

Copyright © 2014-2015, Dreki Þórgísl

Copyright © 2015, arpunk

Copyright © 2015-2025, Duncan McGreggor <oubiwann@gmail.com>

[//]: ---Named-Links---

[logo]: priv/images/jason-argonauts-small.png
[logo-large]: http://dropr.com/coenhamelink/15218/jason_and_the_argonauts/+?p=97582
[org]: https://github.com/lfex
[github]: https://github.com/lfex/ljson
[gitlab]: https://gitlab.com/lfex/ljson
[gh-actions-badge]: https://github.com/lfex/ljson/workflows/ci%2Fcd/badge.svg
[gh-actions]: https://github.com/lfex/ljson/actions
[lfe]: https://github.com/rvirding/lfe
[lfe-badge]: https://img.shields.io/badge/lfe-1.3.0-blue.svg
[erlang-badge]: https://img.shields.io/badge/erlang-17.5%20to%2022.0-blue.svg
[versions]: https://github.com/lfex/ljson/blob/master/.travis.yml
[github-tags]: https://github.com/lfex/ljson/tags
[github-tags-badge]: https://img.shields.io/github/tag/lfex/ljson.svg
[hex-badge]: https://img.shields.io/hexpm/v/ljson.svg?maxAge=2592000
[hex-package]: https://hex.pm/packages/ljson
[hex-downloads]: https://img.shields.io/hexpm/dt/ljson.svg
