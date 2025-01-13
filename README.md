# ljson
[![Build Status][travis badge]][travis]
[![LFE Versions][lfe badge]][lfe]
[![Erlang Versions][erlang badge]][versions]
[![Tags][github tags badge]][github tags]
[![Downloads][hex downloads]][hex package]

*A wrapper for `json` in the Erlang stdlib for 27+ and for `jsx` in Erlang 26 and below*

[![Project Logo][logo]][logo-large]

## About

Until all supported Erlang versions have `json` and support a backwards-compatible feature set, this library will be around.

## Usage

The following usage examples are from LFE, but the same applies to Erlang (though hyphens in the LFE function name can be replaced with underscores in the same Erlang function).

Encode simple LFE data to JSON:

```cl
> (ljson:encode 'a)
#"\"a\""
ok
> (ljson:encode "a")
#"[97]"
ok
> (ljson:encode 1)
#"1"
ok
> (ljson:encode 3.14)
#"3.14"
ok
> (ljson:encode '(a b c 42))
#"[\"a\",\"b\",\"c\",42]"
ok
> (ljson:encode #(a b))
#"{\"a\":\"b\"}"
ok
> (ljson:encode '(#(a b) #(c d)))
#"{\"a\":\"b\",\"c\":\"d\"}"
ok
>
```

Decode simple JSON:

```cl
> (ljson:decode #b("\"a\""))
#"a"
ok
> (ljson:decode "\"a\""))
#"a"
ok
> (ljson:decode #b("[97]"))
"a"
ok
> (ljson:decode #b("1"))
1
ok
> (ljson:decode #b("3.14"))
3.14
ok
> (ljson:decode #b("[\"a\",\"b\",\"c\",42]"))
(#"a" #"b" #"c" 42)
ok
> (ljson:decode "{\"a\": \"b\"}")
#(#"a" #"b")
ok
> (ljson:decode "{\"a\":\"b\",\"c\":\"d\"}")
(#(#"a" #"b") #(#"c" #"d"))
ok
> (ljson:decode
    #B(123 34 97 34 58 34 98 34 44 34 99 34 58 34 100 34 125))
(#(#"a" #"b") #(#"c" #"d"))
ok
```

Decode a JSON data structure (note that, for formatting purposes, the data
below has been presented separated with newlines; this won't work in the
LFE REPL -- you'll need to put it all on one line):

```cl
> (set json-data "{
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
> (set data (ljson:decode json-data))
(#(#"First Name" #"Jón")
 #(#"Last Name" #"Þórson")
 #(#"Is Alive?" true)
 #(#"Age" 25)
 #(#"Height_cm" 167.6)
 #(#"Address"
   (#(#"Street Address" #"í Gongini 5 Postsmoga 108")
    #(#"City" #"Tórshavn")
    #(#"Country" #"Faroe Islands")
    #(#"Postal Code" #"100")))
 #(#"Phone Numbers"
   ((#(#"Type" #"home") #(#"Number" #"20 60 30"))
    (#(#"Type" #"office") #(#"Number" #"+298 20 60 20"))))
 #(#"Children" ())
 #(#"Spouse" null))
```

Now let's take it full circle by encoding it again:

```cl
> (ljson:prettify (ljson:encode data))
{
  "First Name": "Jón",
  "Last Name": "Þórson",
  "Is Alive?": true,
  "Age": 25,
  "Height_cm": 167.6,
  "Address": {
    "Street Address": "í Gongini 5 Postsmoga 108",
    "City": "Tórshavn",
    "Country": "Faroe Islands",
    "Postal Code": "100"
  },
  "Phone Numbers": [
    {
      "Type": "home",
      "Number": "20 60 30"
    },
    {
      "Type": "office",
      "Number": "+298 20 60 20"
    }
  ],
  "Children": [],
  "Spouse": null
}
ok
```

Let's do the same, but this time from LFE data:

```cl
> (set lfe-data
   `(#(#b("First Name") ,(binary ("Jón" utf8)))
     #(#b("Last Name") ,(binary ("Þórson" utf8)))
     #(#b("Is Alive?") true)
     #(#b("Age") 25)
     #(#b("Height_cm") 167.6)
     #(#b("Address")
      #((#(#b("Street Address") ,(binary ("í Gongini 5 Postsmoga 108" utf8)))
        #(#b("City") ,(binary ("Tórshavn" utf8)))
        #(#b("Country") #b("Faroe Islands"))
        #(#b("Postal Code") #b("100")))))
     #(#b("Phone Numbers")
      (#((#(#b("Type") #b("home")) #(#b("Number") #b("20 60 30"))))
       #((#(#b("Type") #b("office")) #(#b("Number") #b("+298 20 60 20"))))))
     #(#b("Children") ())
     #(#b("Spouse") null)))
(#(#B(...)))
> (ljson:prettify (ljson:encode lfe-data))
{
  "First Name": "Jón",
  "Last Name": "Þórson",
  "Is Alive?": true,
  "Age": 25,
  "Height_cm": 167.6,
  "Address": {
    "Street Address": "í Gongini 5 Postsmoga 108",
    "City": "Tórshavn",
    "Country": "Faroe Islands",
    "Postal Code": "100"
  },
  "Phone Numbers": [
    {
      "Type": "home",
      "Number": "20 60 30"
    },
    {
      "Type": "office",
      "Number": "+298 20 60 20"
    }
  ],
  "Children": [],
  "Spouse": null
}
ok
```


Extract elements from the original converted data structure as well as
our LFE data structure we just entered directly, above:

```cl
> (ljson:get data '("First Name"))
#"Jón"
> (ljson:get data '("Address" "City"))
#"Tórshavn"
> (ljson:get data '("Phone Numbers" 1 "Type"))
#"home"
> (ljson:get lfe-data '("First Name") )
#"Jón"
> (ljson:get lfe-data '("Address" "City")data)
#"Tórshavn"
> (ljson:get lfe-data '("Phone Numbers" 1 "Type"))
#"home"
```

You may also use atom or binary keys:

```cl
> (ljson:get lfe-data '(|Phone Numbers| 1 Number))
#"20 60 30"
> (ljson:get lfe-data '(#"Phone Numbers" 1 #"Number"))
#"20 60 30"
```

Extract elements directly from JSON:

```cl
> (ljson:get json-data '("First Name") #(json))
#"\"J\\u00f3n\""
> (ljson:get json-data '("Address" "City") #(json))
#"\"T\\u00f3rshavn\""
> (ljson:get json-data '("Phone Numbers" 1 "Type") #(json))
#"\"home\""
```

## License 

Apache Version 2 License

Copyright © 2014-2015, Dreki Þórgísl

Copyright © 2015, arpunk

Copyright © 2015-2025, Duncan McGreggor <oubiwann@gmail.com>


<!-- Named page links below: /-->

[logo]: priv/images/jason-argonauts-small.png
[logo-large]: http://dropr.com/coenhamelink/15218/jason_and_the_argonauts/+?p=97582
[org]: https://github.com/lfex
[github]: https://github.com/lfex/ljson
[gitlab]: https://gitlab.com/lfex/ljson
[travis]: https://travis-ci.org/lfex/ljson
[travis badge]: https://img.shields.io/travis/lfex/ljson.svg
[lfe]: https://github.com/rvirding/lfe
[lfe badge]: https://img.shields.io/badge/lfe-1.3.0-blue.svg
[erlang badge]: https://img.shields.io/badge/erlang-17.5%20to%2022.0-blue.svg
[versions]: https://github.com/lfex/ljson/blob/master/.travis.yml
[github tags]: https://github.com/lfex/ljson/tags
[github tags badge]: https://img.shields.io/github/tag/lfex/ljson.svg
[github downloads]: https://img.shields.io/github/downloads/lfex/ljson/total.svg
[hex badge]: https://img.shields.io/hexpm/v/ljson.svg?maxAge=2592000
[hex package]: https://hex.pm/packages/ljson
[hex downloads]: https://img.shields.io/hexpm/dt/ljson.svg
