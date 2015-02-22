#lang racket
(require irc)
(require toml)
(require racket/async-channel)
(require rackjure)

(define config {'host "irc.hypeirc.net" 
  'port 6667
  'nickname "milton"
  'username "milton"
  'realname "Miltone"})

(define (connect c)
  (irc-connect ('host c) ('port c) ('nickname c) ('username c) ('realname c)))

(define-values 
  (connection ready) 
  (connect config))

(irc-join-channel connection "#jarvis-test")

(printf "About to start read-loop~n")

(define print-thread 
  (thread 
    (lambda () 
      (let loop ()
        (define message (async-channel-get (irc-connection-incoming connection)))
        (printf "~a\n" (irc-message-content message))
        (loop)))))
(printf "something after thread\n")

(thread-wait print-thread)
