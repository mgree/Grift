(#lang typed)

(let ([ar : Int 300]
      [ac : Int 300]
      [br : Int 300]
      [bc : Int 300])
  (if (= ac br)
      (letrec ([create : (Int Int -> (GVect (GVect Int)))
                       (lambda (l1 l2)
                         (let ([x : (GVect (GVect Int))
                                  (gvector l1 (gvector l2 0))])
                           (begin
                             (repeat (i 0 l1)
                                     (let ([xi : (GVect Int) (gvector l2 0)])
                                       (begin
                                         (repeat (j 0 l2)
                                                 (gvector-set! xi j (+ j i)))
                                         (gvector-set! x i xi))))
                             x)))]
               [mult : ((GVect (GVect Int)) Int Int (GVect (GVect Int)) Int Int -> (GVect (GVect Int)))
                     (lambda (x x1 x2 y y1 y2)
                       (let ([r : (GVect (GVect Int)) (gvector ar (gvector bc 0))])
                         (begin
                           (repeat (i 0 x1)
                                   (let ([ri : (GVect Int) (gvector y2 0)])
                                     (begin
                                       (repeat (j 0 y2)
                                               (repeat (k 0 y1)
                                                       (gvector-set! ri j
                                                                     (+ (gvector-ref ri j)
                                                                        (* (gvector-ref (gvector-ref x i) k)
                                                                           (gvector-ref (gvector-ref y k) j))))))
                                       (gvector-set! r i ri))))
                           r)))])
        (let ([a : (GVect (GVect Int)) (create ar ac)]
              [b : (GVect (GVect Int)) (create br bc)]
              [bx : (GRef Int) (gbox 0)])
          (begin
            (timer-start)
            (gbox-set! bx (gvector-ref (gvector-ref (mult a ar ac b br bc) (- ar 1)) (- ac 1)))
            (timer-stop)
            (gunbox bx)
            (timer-report))))
      ()))