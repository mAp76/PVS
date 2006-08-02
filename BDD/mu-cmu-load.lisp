(in-package :pvs)  

(eval-when (eval load)
  ;; (use-package :alien)
  (use-package :c-call))


;;;;;;;;;;;;;;;;;
;;;  Formula  ;;;
;;;;;;;;;;;;;;;;;

;;; Formula mu_mk_false_formula (void)
(alien:def-alien-routine mu_mk_false_formula unsigned-int)

;;; Formula mu_mk_true_formula (void)
(alien:def-alien-routine mu_mk_true_formula unsigned-int)

;;; Formula mu_mk_bool_var (char *name)
(alien:def-alien-routine mu_mk_bool_var unsigned-int
  (name c-string))

;;; Formula int mu_check_bool_var (char *var)
(alien:def-alien-routine mu_check_bool_var unsigned-int
  (var c-string))

;;; Formula mu_check_mk_bool_var
(alien:def-alien-routine mu_check_mk_bool_var unsigned-int
  (name c-string))

;;; Formula mu_mk_ite_formula (Formula cond, Formula then_part, Formula else_part)
(alien:def-alien-routine mu_mk_ite_formula unsigned-int
  (cond unsigned-int)
  (then_part unsigned-int)
  (else_part unsigned-int))

;;; Formula mu_mk_curry_application (Term R, LIST subs)
(alien:def-alien-routine mu_mk_curry_application unsigned-int
  (R unsigned-int)
  (subs unsigned-int))
  
;;; Formula mu_mk_application (Term R, LIST subs, int curried)
(alien:def-alien-routine mu_mk_application unsigned-int
			 (R unsigned-int)
			 (subs unsigned-int)
			 (curried unsigned-int))
(alien:def-alien-routine mu_mk_forall unsigned-int
			 (listvars unsigned-int)
			 (fml1 unsigned-int))
(alien:def-alien-routine mu_mk_exists unsigned-int
			 (listvars unsigned-int)
			 (fml1 unsigned-int))
(alien:def-alien-routine mu_mk_implies_formula unsigned-int
			 (fml1 unsigned-int)
			 (fml2 unsigned-int))
(alien:def-alien-routine mu_mk_equiv_formula unsigned-int
			 (fml1 unsigned-int)
			 (fml2 unsigned-int))
;; (alien:def-alien-routine mu_mk_xor_formula void);; (fml1 fml2)
(alien:def-alien-routine mu_mk_or_formula unsigned-int
			 (fml1 unsigned-int)
			 (fml2 unsigned-int))
(alien:def-alien-routine mu_mk_and_formula unsigned-int
			 (fml1 unsigned-int)
			 (fml2 unsigned-int))
(alien:def-alien-routine mu_mk_not_formula unsigned-int
			 (fml unsigned-int))
(alien:def-alien-routine mu_mk_cofactor unsigned-int
			 (fml1 unsigned-int)
			 (fml2 unsigned-int))

;;;;;;;;;;;;;;;
;;;  Term   ;;;
;;;;;;;;;;;;;;;
(alien:def-alien-routine mu_mk_abstraction unsigned-int
			 (vars unsigned-int)
			 (f1 unsigned-int))
;;; Term mu_mk_abstraction (LIST vars, Formula f1)
(alien:def-alien-routine mu_mk_l_fixed_point unsigned-int)
;;; Term mu_mk_fixed_point 
(alien:def-alien-routine mu_mk_g_fixed_point unsigned-int)
;;; Term mu_mk_g_fixed_point 
(alien:def-alien-routine mu_mk_reach unsigned-int
			 (Next unsigned-int)
			 (S0 unsigned-int)
			 (Inv unsigned-int))
;;; Term mu_mk_reach (Term Next, Term S0, Term Inv)
(alien:def-alien-routine mu_mk_rel_var_dcl unsigned-int
			 (char unsigned-int))
;;; Term mu_mk_rel_var_dcl (char *name) 
(alien:def-alien-routine mu_mk_rel_var_ unsigned-int
			 (name unsigned-int))
;;; Term  mu_mk_rel_var_ (R_Interpret Ip, char *name)
(alien:def-alien-routine mu_mk_true_term unsigned-int)
;;; Term  mu_mk_true_term (void)
(alien:def-alien-routine mu_mk_false_term unsigned-int)
;;; Term  mu_mk_false_term (void)
(alien:def-alien-routine mu_mk_not_term unsigned-int
			 (fml1 unsigned-int))
(alien:def-alien-routine mu_mk_and_term unsigned-int
			  (fml1 unsigned-int)
			  (fml2 unsigned-int))
(alien:def-alien-routine mu_mk_or_term unsigned-int
			  (fml1 unsigned-int)
			  (fml2 unsigned-int))
(alien:def-alien-routine mu_mk_equiv_term unsigned-int
			  (fml1 unsigned-int)
			  (fml2 unsigned-int))
(alien:def-alien-routine mu_mk_implies_term unsigned-int
			  (fml1 unsigned-int)
			  (fml2 unsigned-int))
;; (alien:def-alien-routine mu_mk_xor_term void) ;; (fml1 fml2)

;;(alien:def-alien-routine get_bdd_var_id void) ;; (int)
(alien:def-alien-routine get_mu_bool_var_name c-string
			  (bdd_idx unsigned-int))
;;;;;;;;;;;;;;;;;;;
;;;  Lists      ;;;
;;;;;;;;;;;;;;;;;;;
;; 

(alien:def-alien-routine append_cont unsigned-int
			 (p unsigned-int)
			 (list unsigned-int))
(alien:def-alien-routine empty_list unsigned-int)

;;;
;;; Flags

;; (alien:def-alien-routine set_mu_bdd_ordering void)
(alien:def-alien-routine set_mu_warnings void)
(alien:def-alien-routine set_mu_simplify_frontier void)
(alien:def-alien-routine set_mu_verbose void)
;; (alien:def-alien-routine set_mu_bdd_use_neg_edges void)

;;
;;
;; GC management: not needed, "modelcheck_formula" takes care of it.
;;

;;;;;;;;;;;;;;;;;;;
;;;  print      ;;;
;;;;;;;;;;;;;;;;;;;

(alien:def-alien-routine pvs_mu_print_formula void)
(alien:def-alien-routine pvs_mu_print_term void)

;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Main function   ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;

(alien:def-alien-routine mu_init void)
(alien:def-alien-routine mu_quit void)
(alien:def-alien-routine modelcheck_formula unsigned-int
			 (fml unsigned-int))

(defun run-musimp (ps fnums dynamic-ordering? irredundant? verbose?)
  (bdd_init)
  (mu_init)
  (let* ((init-real-time (get-internal-real-time))
	 (init-run-time (get-run-time))
	 (*bdd-initialized* t)
	 (*mu-verbose* verbose?)
	 (*pvs-bdd-hash* (make-pvs-hash-table))
	 (*bdd-pvs-hash* (make-hash-table))
	 (*pvs-bdd-inclusivity-formulas* nil)
	 (*bdd-counter* *bdd-counter*)
	 (*recognizer-forms-alist* nil)
         (*mu-subtype-list* nil)
         (*incl-excl-var-id-indx-pairs* nil)
	 (sforms (s-forms (current-goal ps)))
	 (selected-sforms (select-seq sforms fnums))
	 (remaining-sforms (delete-seq sforms fnums))
	 (pvs-formula (make-conjunction
			(mapcar #'(lambda (sf) (negate (formula sf)))
			  selected-sforms)))
	 (uniq-formula (uniquefy-bindings pvs-formula))
	 (mu-uniq-formula (convert-pvs-to-mu uniq-formula))
	 (mu-formula
	  (make-mu-restriction
	   mu-uniq-formula
	   (make-mu-conjunction
	    (loop for x in  *pvs-bdd-inclusivity-formulas*
		  when (null (freevars (car x)))
		  collect (cdr x)))))
	 (mu-output (run-pvsmu mu-formula dynamic-ordering?))
	 (sum-of-cubes (bdd_sum_of_cubes mu-output (if irredundant? 1 0)))
	 (list-of-conjuncts (mu-translate-from-bdd-list sum-of-cubes))
         (lit-list (mu-from-bdd-list-to-pvs-list list-of-conjuncts)))
    (mu_quit)
    (bdd_quit)
    (cond ((zerop bdd_interrupted)
	   (multiple-value-prog1
	    (mu-add-bdd-subgoals ps sforms lit-list remaining-sforms)
	    (format t
		"~%MU simplification took ~,2,-3f real, ~,2,-3f cpu seconds"
	      (realtime-since init-real-time) (runtime-since init-run-time))))
	  (t (format t "~%MU Simplifier interrupted")
	     (values 'X nil)))))