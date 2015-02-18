(use irc posix srfi-69 sandbox uri-common medea
     utils data-structures defstruct alist-lib)

(defstruct network name nickname altnicks realname version servers channels)

(define config-location
  (make-pathname
   (get-environment-variable "HOME") ".milton.json"))

(define (load-config f)
  (read-json
   (read-all f)))

(define config (load-config config-location))
;(define networks (alist-ref config 'networks))

(define (alist->network k v)
  (make-network name: k
                nickname: (alist-ref/default v 'nickname "milton9000")
                altnicks: (alist-ref/default v 'altnicks '("mlt9001" "mlt9002"))
                realname: (alist-ref/default v 'realname "John Smith")
                version:  (alist-ref/default v 'version "WeeChat 0.3.8 (Dec 17 2012)")
                servers:  (alist-ref/default v 'servers '("irc.freenode.net"))
                channels: (alist-ref/default v 'channels '("mlt9000"))))

(define (network->connection n)
  (irc:connection server: (vector-ref (network-servers n))
                  nick: (network-nickname n)
                  real-name: (network-realname n)))

(define (load-networks c)
  (alist-map (lambda (k v) (alist->network k v)) (alist-ref config 'networks)))

(define (load-connections c)
  (alist-map (lambda)))

(define networks (load-networks config))
