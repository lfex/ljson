(defmodule ljson-tests
  (behaviour ltest-unit)
  ;; Note that `(export all)` is used here in order to make the test data
  ;; availale in the REPL.
  (export all))

(include-lib "ltest/include/ltest-macros.lfe")

;;; Support Functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun test-data ()
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

(defun test-json-data ()
  (ljson:encode (test-data)))

;;; Test Functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftest encode-atom
  (is-equal #"\"a\"" (ljson:encode 'a)))

(deftest encode-string
  (is-equal #b("[97]") (ljson:encode "a")))

(deftest encode-empty-string
  (is-equal #b(91 93) (ljson:encode "")))

(deftest encode-integer
  (is-equal #"1" (ljson:encode 1)))

(deftest encode-float
  (is-equal #"3.14" (ljson:encode 3.14)))

(deftest encode-simple-list
  (is-equal #b("[\"a\",\"b\",\"c\",42]") (ljson:encode '(a b c 42))))

(deftest encode-pairs
  ;;(is-equal #b("{\"a\":\"b\"}") (ljson:encode #(a b)))
  ;;(is-equal #b("{\"a\":[98]}") (ljson:encode #(a "b")))
  ;;(is-equal #b("{\"a\":\"b\"}") (ljson:encode #("a" b)))
  (is-equal #b("{\"c\":\"d\",\"a\":\"b\"}") (ljson:encode '#m(a b c d))))

(deftest encode-complex-list
  (is-equal
    #b("[\"a\",\"b\",[99],[\"d\",[\"e\",[\"f\",\"g\"]]],42,{\"h\":1,\"i\":2.4}]")
    (ljson:encode
      '(a b "c" (d (e (f g))) 42 #m(h 1 #"i" 2.4)))))

(deftest decode-atom
  (is-equal #"a" (ljson:decode #"\"a\"")))

(deftest decode-string
  (is-equal "a" (ljson:decode #b("[97]"))))

(deftest decode-empty-string
  (is-equal "" (ljson:decode #b(91 93))))

(deftest decode-integer
  (is-equal 1 (ljson:decode #"1")))

(deftest decode-float
  (is-equal 3.14 (ljson:decode #"3.14")))

(deftest decode-simple-list
  (is-equal '(#b(97) #b(98) #b(99) 42)
            (ljson:decode #b("[\"a\",\"b\",\"c\",42]"))))

(deftest decode-pairs
  (is-equal #M(#"a" #"b") (ljson:decode #b("{\"a\":\"b\"}")))
  (is-equal #M(#b(97) "b") (ljson:decode #b("{\"a\":[98]}")))
  (is-equal #M(#b(97) #b(98) #b(99) #b(100))
            (ljson:decode #"{\"a\":\"b\",\"c\":\"d\"}")))

(deftest decode-complex-list
  (is-equal
    '(#b(97)
      #b(98)
      "c"
      (#"d" (#"e" (#"f" #"g")))
      42
      #M(#"h" 1 #"i" 2.4))
    (ljson:decode
     #b("[\"a\",\"b\",[99],[\"d\",[\"e\",[\"f\",\"g\"]]],42,{\"h\": 1,\"i\": 2.4}]"))))
