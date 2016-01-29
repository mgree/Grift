#lang typed/racket/base
(require "forms.rkt")
(provide (all-defined-out)
         (all-from-out "forms.rkt"))

#|-----------------------------------------------------------------------------+
| Language/Cast0 created by insert-implicit-casts                              |
+-----------------------------------------------------------------------------
| Description: At the begining of this section of the compiler all cast in the |
| ast are performed on known schml language types. But as the compiler imposes |
| the semantics of cast there become situations where a type is dependant on   |
| econtents of a variable. At this point casts are no longer able to be         |
| completely compiled into primitives. These casts require a sort of cast      |
| interpreter which is built later.                                            |
| In general this compiler tries to move as mainy casts into the primitive     |
| operations. Whatever casts are left at the end are then convert to           |
| applications of the cast interpreter function.
+-----------------------------------------------------------------------------|#

(define-type Cast-or-Coerce0-Lang
  (Prog (List String Natural Schml-Type) CoC0-Expr))

(define-type CoC0-Expr
  (Rec E (U ;; Non-Terminals
	  (Lambda Uid* E)
	  (Letrec CoC0-Bnd-Lam* E)
	  (Let CoC0-Bnd* E)
	  (App E (Listof E))
	  (Op Schml-Primitive (Listof E))
	  (If E E E)
	  (Cast E (Twosome Schml-Type Schml-Type Blame-Label))
          (Cast E (Coercion Schml-Coercion))
          (Begin CoC0-Expr* E)
          (Repeat Uid E E E)
          ;; Guarded effects
          (Gbox E)
          (Gunbox E)
          (Gbox-set! E E)
          (Gvector E E)
          (Gvector-set! E E E)
          (Gvector-ref E E)
	  ;; Terminals
	  (Var Uid)
	  (Quote Cast-Literal))))

(define-type CoC0-Expr* (Listof CoC0-Expr))
(define-type CoC0-Bnd   (Pairof Uid CoC0-Expr))
(define-type CoC0-Bnd*  (Listof CoC0-Bnd))
(define-type CoC0-Bnd-Lam (Pairof Uid (Lambda Uid* CoC0-Expr)))
(define-type CoC0-Bnd-Lam* (Listof CoC0-Bnd-Lam))