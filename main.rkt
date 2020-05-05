#lang racket/base

(require racket/stream)

(provide
 fibs)

(define (fibs)
  (stream*
   1
   1
   (let ([s (fibs)])
     (for/stream ([x (in-stream s)]
                  [y (in-stream (stream-rest s))])
       (+ x y)))))

(module+ test
  (require rackcheck
           rackunit)

  (check-property
   (property ([n (gen:integer-in 3 100)])
     (define numbers (stream->list (stream-take (fibs) n)))
     (for ([n (cddr numbers)]
           [y (cdr numbers)]
           [x numbers])
       (check-eqv? (+ x y) n)))))
