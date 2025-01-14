-module(ljson).
-export([
  decode/1, decode/2, decode/3,
  encode/1, encode/2
]).

-if(?OTP_RELEASE >= 27).
-define(DECODE, json:decode).
-define(ENCODE, json:encode).
-else.
-define(DECODE, jsx:decode).
-define(ENCODE, jsx:encode).
-endif.

decode(Json) ->
    ?DECODE(Json).

%% Only workds in Erlang 26 and below
decode(Json, Opts) ->
    ?DECODE(Json, Opts).

%% Only works in Erlang 27+
decode(JsonBinary, Acc, Decoders) ->
    ?DECODE(JsonBinary, Acc, Decoders).

encode(Term) ->
    R = ?ENCODE(Term),
    if is_list(R) ->
            iolist_to_binary(R);
       true ->
            R
    end.

%% Second arg is Encoder for Erlang 27+ and Opts for 26 and below
encode(Term, EncoderOrOpts) ->
    R = ?ENCODE(Term, EncoderOrOpts),
    if is_list(R) ->
            iolist_to_binary(R);
       true ->
            R
    end.
