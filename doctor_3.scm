#lang scheme/base
(define (visit-doctor)
  (define (doctor-driver-loop name old-phrases)
    (define (reply user-response)
      ;(define (change-person phrase)
      ;  (many-replace '((i you) (I you) (me you) (am are) (my your) (you me) (You I) (are am) (your my)) phrase))

      (define (change-person pairs phrase)
        (many-replace pairs phrase))
      
      (define (qualifier)
        (pick-random '((you seem to think)
                       (you feel that)
                       (why do you believe)
                       (why do you say)
                       (what do you mean when say)
                       (You said)
                       (It's very interesting What can you say except)
                       (We are clearly in the right direction, if you said)))
      )

      (define (hedge)
        (pick-random '((please go on)
                       (many people have the same sorts of feelings)
                       (many of my patients have told me the same thing)
                       (please continue)
                       (can you say in more detail about your problem)
                       (Do you believe in what you said)
                       (We are on the right track)
                       (If you need anything, just ask)
                       (Make yourself at home)
                       (How long have you had these thoughts)
                       (If you could wave a magic wand what positive changes would you make happen in your life)))
      )

      (define (fifty-fifty)
        ( cond ((null? old-phrases) (random 2) )
               (else (random 3)))
      )
      ;(define (fifty-fifty) 1)
      
       (case (fifty-fifty)
         ( (0) (append (qualifier) (change-person '((i you) (I you) (me you) (am are) (my your) (you i) (You I) (are am) (your my)) user-response)))
         ( (2) (cond ((null? old-phrases) '(You haven't said anything before that))
               (else (append '(early you said that) (change-person '((i you) (I you) (me you) (am are) (my your) (you i) (You I) (are am) (your my)) (pick-random old-phrases))))))
         ( (1) (hedge))
         ( else '(Error)))
    )

    (define (unique-push element vector)
        (cond ((null? vector) ( cons element vector))
              (else (let ((curr-element (car vector)))
                      (cond ((equal? curr-element element) vector)
                            (else (cons curr-element (unique-push element (cdr vector))))
                      )
                    )
              )
        )
    )

    (newline)
    (print '**)
    (let ((user-response (read)))
      (cond ((equal? user-response '(goodbye))
             (printf "Goodbye, ~a!\n" name)
             (print '(see you next week))
             (print old-phrases)
             (newline))
            (else (print old-phrases)
                  (print (reply user-response))
                  ;standart push| old-phrases is a vector
                  ;(doctor-driver-loop name (cons user-response old-phrases)))))
                  ;unique push| old-phrases is a set
                  (doctor-driver-loop name (unique-push user-response old-phrases)))))
                  
  )

  (define (ask-patient-name)
    (begin
    (print '(NEXT!))
    (newline)
    (print '(Who are you?))
    (car (read))))

  (define name (ask-patient-name))
  (cond ((equal? name 'suppertime) (print '(Time to sleep)))
        (else (begin
                     (printf "Hello, ~a!\n" name)
                     (print '(what seems to be the trouble?))
                     (doctor-driver-loop name '())
                     (visit-doctor)
               )
        )
  )
)


(define (replace replacement-pairs word)
  (cond ((null? replacement-pairs) word)
        ((equal? (caar replacement-pairs) word) (cadar replacement-pairs))
        (else (replace (cdr replacement-pairs) word ) )
  )
)

(define (pick-random lst)
  ( cond ((null? lst) '())
         ( else (list-ref lst (random (length lst))))
  )
)

;New many-replace function
(define (many-replace replacement-pairs lst)
        (cond ((null? lst) '())
              (else (let ((current-word (car lst)))
                      ( cons (replace replacement-pairs current-word)  (many-replace replacement-pairs (cdr lst))))
              )
        )
)