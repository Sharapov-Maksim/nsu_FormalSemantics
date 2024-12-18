
; содержимое psm для первичной модели Python на PSML
(ontology Python) ; Добавляем язык моделей Python-конструкций
(current-ontology Python) ; Делаем его текущим языком

(model program :constructor program :arguments 
    (body (list statement)) ; list can be empty
) ; file_input in g4

(concept-by-value identifier symbol)
(concept-by-value int-atom (lisp int))
(concept-by-value bool-atom (True False))
(concept-by-union atom
    int-atom
    bool-atom
    |None|
    atom_subscriptable
)
(concept-by-union atom_subscriptable
    variable
    string
    tuple
    list
    dict
)

(concept-by-union statement simple_statements compound_statement)

(model simple_statements :constructor simple_stmts :arguments
    (stmts  (list simple_statement))
)
(concept-by-union simple_statement 
    assignment
    type_alias
    star_expressions
    return_stmt
    import_stmt
    raise_stmt
    pass
    del_stmt
    yield_stmt
    assert_stmt
    break
    continue
    global_stmt
    nonlocal_stmt
)
(concept-by-union compound_statement
    function_def
    if_stmt
    class_def
    with_stmt
    for_stmt
    try_stmt
    while_stmt
    match_stmt
)

;; SIMPLE STATEMENTS
;; =================

;; ASSIGNMENT
(concept-by-union assignment 
    simple_assignment
    augment_assignment  ; like '+='
)

(concept simple_assignment :constructor = :arguments
    assignment_target
    expression
)

(concept augment_assignment :constructor augassign :arguments
    assignment_target
    arith-op
    expression
)

;(concept-by-value augment_operation (|+=|, |-=|, |*=|, |@=|, |/=|, |%=|, |&=|, ||=|, |^=|, |<<=|, |>>=|, |**=|, |//=|)) ; TODO syntax?

(concept return_statement :constructor return :arguments
    (expr expression)
)
(concept raise_statement :constructor raise :arguments
    (expr expression)
)
(concept global_stmt :constructor global :arguments
    (name variable)
)
(concept nonlocal_stmt :constructor nonlocal :arguments
    (name variable)
)
(concept yield_stmt :constructor yield)
(concept break_stmt :constructor break)
(concept continue_stmt :constructor continue)
(concept-by-union import_stmt
    import_name
    import_from
)
(concept import_name :constructor import :arguments
    (package :flatten (list identifier))
)
(concept import_from :constructor import_from :arguments
    (package :flatten (list identifier))
    (name identifier)
)

(concept-by-union assignment_target
    variable
    subscript_primary_by_name
)

(concept subscript_primary_by_name ; a.name, a["name"], a[idx]
    (object subscript_primary)
    (attr identifier) ; indexes are also names
)

(concept-by-union subscript_primary
    subscript_primary_by_name
    subscript_primary_method_call
    atom_subscriptable
)

(concept subscript_primary_method_call :constructor subscript_method_call :arguments ; a.name(args...)
    (object subscript_primary)
    (name identifier)
    :flatten (arguments (list expression))
)

(concept function_call :constructor function_call :arguments ; name(args...)
    (name identifier)
    :flatten (arguments (list expression))
)

;; COMPOUND STATEMENTS

(concept block :constructor block :arguments
    (statements (list statement))
)

(concept class_def :constructor class :arguments ; TODO type params, arguments?
    (name identifier)
    (body block)
)

(concept function_def :constructor func :arguments ; TODO type params
    (name identifier)
    (args (list identifier)) ; TODO defaults?
    (body block)
)

(concept if-statement :constructor if :arguments
    (condition boolean-expression) 
    (then block) 
    (:opt else block) ; TODO optional syntax? 
)

(concept while_statement :constructor while_stmt :arguments
    (condition boolean-expression) 
    (body block)
)

(concept for_statement :constructor for_stmt :arguments
    (var variable)
    (range expression) 
    (body block)
)

(concept with_statement :constructor with_stmt :arguments ; with open('file_path', 'w') as file:
    (items (lsit as_statement))
    (body block)
)

(concept as_statement :constructor as_stmt :arguments
    (val expression)
    (var variable)
)

(concept try_statement :constructor try_stmt :arguments
    (body block)
    (:opt except (list except_block))
    (:opt finally block)
)

(concept except_block :constructor except_block :arguments
    (:opt exception as_statement)
    (body block)
)

(concept-by-union expression
    atom
    subscript_primary
    boolean-expression
    boolean-negation-expression
    comparison-expression
    arith-expression
)

(concept boolean-negation-expression :constructor boolean-negation-expression :arguments
    (arg expression)
)
(concept-by-value bool-op |or| |and| |xor|)
(concept boolean-expression :constructor boolean-expression :arguments
    (left expression)
    (op bool-op)
    (right expression)
)
(concept-by-value cmp-op |>| |<| |<=| |>=| |==| |!=|)
(concept comparison-expression :constructor comparison-expression :arguments
    (left expression)
    (op cmp-op)
    (right expression)
)
(concept-by-value arith-op |+| |-| |*| |@| |/| |%| |&| ||| |^| |<<| |>>| |**| |//|)
(concept arith-expression :constructor arith-expression :arguments
    (left expression)
    (op arith-op)
    (right expression)
)



;; SEMANTIC ENTITIES
(concept module : constructor module :arguments (id nat))
(concept-by-union object None object-with-id)
(concept object-with-id :constructor object-with-id :arguments (id nat))
(concept-by-union type class builtin_type)
(concept-by-value builtin_type bool str int float complex)
(concept class :constructor class :arguments (id nat))


(concept local-context :constructor local-context :arguments
    (local-variable-value (map name value))
    (local-variable-type (map name type))
    (object-type (map object class))
    (object-value (map object object-value))
    (classes (map name class))
    (class-static-field-value (map class (map name static-field-value)))
    (class-declaration (map class class-declaration))
    (class-interface (map class interface))
)
(concept-by-value object-value (map name instance-field-value))
(concept-by-union instance-field-value int-value double-value bool-value object)
(concept-by-union static-field-value int-value double-value bool-value object)

(concept global-context :constructor global-context :arguments
    (module (map name package))
    (package-value package (map name package-element))
    (object-counter nat)
    (class-counter nat)
)
(concept-by-union package-element module class object)


; OPERATIONAL SEMANTICS for Python

;;;; Concept `instance in state`
(concept instance-in-state
    :constructor instance-in-state
    :arguments (instance instance) (state state))

;; Simple statements
;;; Assignments
(transformation opsem :concept simple_assignment -
    (nil
        (to-state 'expression)
        (opsem (aget i 'expression) lc gc))
    (expression 
        (setq t (aget i 'assignment_target))
        (setq val (aget lc 'value))
        (if (is-instance t variable)
            (progn
                (aset lc local-variable-value t val)
                (go-to-state final))
            (progn ; t is subscript_primary_by_name
                (to-state object-assignment val)
                (opsem (aget t 'object) lc gc)
            ) 
        )
        )
    (object-assignment val
        (setq obj (aget lc 'value))
        (aset lc object-value obj val)
        (go-to-state final)
    ))

; (concept-by-value augment_operation (|+=|, |-=|, |*=|, |@=|, |/=|, |%=|, |&=|, ||=|, |^=|, |<<=|, |>>=|, |**=|, |//=|)) ; TODO syntax?
(transformation opsem :concept augment_assignment -
    (nil
        (to-state 'expression)
        (opsem (aget i 'expression) lc gc))
    (expression
        (setq t (aget i 'assignment_target))
        (setq val (aget lc 'value))
        (if (is-instance t variable)
            (progn
                (setq val2 (aget lc local-variable-value t val))
                (to-state 'operation_eval val2 val1))
            (progn ; t is subscript_primary_by_name
                (to-state 'object_get val)
                (opsem (aget t 'object) lc gc)) 
        ))
    (object_get val1
        (setq obj (aget lc 'value))
        (setq val2 (aget lc object-value obj))
        (to-state 'operation_eval val2 val1)
    )
    (operation_eval left right
        (setq op (aget i 'arith-op))
        (aset lc 'value (arith-expr-eval op left right))
        (go-to-state 'assignment)
    )
    (assignment 
        (setq t (aget i 'assignment_target))
        (setq val (aget lc 'value))
        (if (is-instance t variable)
            (progn
                (aset lc local-variable-value t val)
                (go-to-state final))
            (progn ; t is subscript_primary_by_name
                (to-state object-assignment val)
                (opsem (aget t 'object) lc gc)
            )
        )
    )
    (object_assignment val
        (setq obj (aget lc 'value))
        (aset lc object-value obj val)
        (go-to-state final)
    ))

(transformation opsem :model block -
    (nil
       (goto-to-state element 0 (length (aget i 'statements))))
    ((element j n)
        (if (< j n)
            (progn (set-to 'element (+ j 1) n)
            (opsem (aget i 'statements j) lc gc))
            (go-to-state final))))

(transformation opsem :concept break_stmt -
    (nil
        (go-to-state propagation (next-instance lc)))
    ((propagation j)
        (if (or
                (is-instance-of j 'match_stmt)
                (is-instance-of j 'while_stmt)
                (is-instance-of j 'for_stmt))
            (go-to-state final)
            (go-to-state propagation (next-instance lc))
        )
    ))

(transformation opsem :concept continue_stmt -
    (nil
        (go-to-state propagation (next-instance lc)))
    ((propagation j)
        (if (is-instance-of j 'while_stmt)
            (opsem j 'condition) ; TODO validate when opsem for loops finished
            (if (is-instance-of j 'for_stmt)
                (fatal_error "Operation \"continue\" in for-loop is unsupported") ; TODO support for loops, it requires iterators opsem
                (go-to-state propagation (next-instance lc))
            )
        )
    ))

;; TODO return_statement, raise_statement, global_stmt, nonlocal_stmt, yield_stmt, 
;; TODO import_name, import_from, subscript_primary_method_call, function_call

;; COMPOUND STATEMENTS

(transformation opsem :concept if-statement -
    (nil
        (to-state 'condition)
        (opsem (aget i 'condition) lc gc))
    (condition
        (if (equal (aget-d lc 'value) true)
            (opsem (aget i 'then) lc gc)
            (if (equals (aget i 'else) nil) ; else block is optional 
                (go-to-state final) 
                (opsem (aget i 'else) lc gc)))))

(transformation opsem :concept while_stmt -
    (nil
        (to-state 'condition)
        (opsem (aget i 'condition) lc gc))
    (condition
        (if (equal (aget-d lc 'value) true)
            (progn
                (to-state 'body)
                (opsem (aget i 'body) lc gc))
            (go-to-state final)))
    (body
        (to-state 'condition)
        (opsem (aget i 'condition) lc gc)))

;; TODO for_stmt, with_statement


;;; Expressions
(transformation opsem :concept bool-expression -
    (nil 
        (to-state 'arg1)
        (opsem (aget i 'left) lc gc))
    (arg1
        (to-state 'arg2 (aget lc 'value))
        (opsem (aget i 'right) lc gc))
    ((arg2 v1)
        (setq v2 (aget lc 'value))
        (setq op (aget i 'bool-op))
        (if (equal (op |or|))
            (aset lc 'value (python-or v1 v2))
            (if equal (op |and|)
                (aset lc 'value (python-and v1 v2))
                (aset lc 'value (python-xor v1 v2))
            )
        )
        (go-to-state final)))

(transformation opsem :concept bool-negation-expression -
    (nil 
        (to-state 'arg)
        (opsem (aget i 'left) lc gc))
    ((arg)
        (setq ar (aget lc 'value))
        (aset lc 'value (python-not ar))
        (go-to-state final)))

(defun python-or (a b)
    (if (equal a True)
        True
        (if (equal b True)
            True
            False
        )    
    )
)
(defun python-and (a b)
    (if (equal a False)
        False
        (if (equal b False)
            False
            True
        )    
    )
)
(defun python-xor (a b)
    (if (equal a b)
        False
        True
    )
)
(defun python-not (a)
    (if (equal a True)
        False
        True
    )
)

; (concept-by-value cmp-op |>| |<| |<=| |>=| |==| |!=|)
(transformation opsem :concept comparison-expression -
    (nil 
        (to-state 'arg1)
        (opsem (aget i 'left) lc gc))
    (arg1
        (to-state 'arg2 (aget lc 'value))
        (opsem (aget i 'right) lc gc))
    ((arg2 v1)
        (setq v2 (aget lc 'value))
        (setq op (aget i 'op))
        (if (equal (op |>|))
            (aset lc 'value (> v1 v2))
            (if (equal (op |<|))
                (aset lc 'value (< v1 v2))
                (if (equal (op |<=|))
                    (aset lc 'value (<= v1 v2))
                    (if (equal (op |>=|))
                        (aset lc 'value (>= v1 v2))
                        (if (equal (op |==|))
                            (aset lc 'value (equal v1 v2))
                            (if (equal (op |!=|))
                                (aset lc 'value (not (equal v1 v2)))
                                (aset lc 'value nil)
        ))))))
        (go-to-state final)))

(transformation opsem :concept arith-expression -
    (nil 
        (to-state 'arg1)
        (opsem (aget i 'left) lc gc))
    (arg1
        (to-state 'arg2 (aget lc 'value))
        (opsem (aget i 'right) lc gc))
    ((arg2 v1)
        (setq v2 (aget lc 'value))
        (setq op (aget i 'op))
        (aset lc 'value (arith-expr-eval op v1 v2))
        (go-to-state final)
    ))

; (concept-by-value arith-op |+|, |-|, |*|, |@|, |/|, |%|, |&|, |||, |^|, |<<|, |>>|, |**|, |//|)
(transformation
    arith-expr-eval
    :arguments op left right
    :concept nil
    :instance nil
    :local-context lc
    :global-context gc
    (prog
        ; TODO obtain types of left and right
        ; if bool, convert them to int, otherwise - fatal

        (if (equal (op |+|))
            (return (+ left right))
            (if (equal (op |-|))
                (return (- left right))
                (if (equal (op |*|))
                    (return (* left right))
                    (if (equal (op |/|)) ; TODO division by zero
                        (if (equal right 0)
                            (fatal_error "Division by zero")
                            (return (/ left right)))
                        (if (equal (op |**|))
                            (return (expt left right))
                            (if (equal (op |<<|))
                                (return (ash left right))
                                (if (equal (op |>>|))
                                    (return (ash left (- right)))
                                    (if (equal (op |||))
                                        (return (bit-or left right))
                                        (if (equal (op |&|))
                                            (return (bit-and left right))
                                            (if (equal (op |^|))
                                                (return (bit-xor left right))
                                                (if (equal (op |%|))
                                                    (return (mod left right))
                                                    (return nil) ; other are unsupported for now                             
        )))))))))))
    ))

(transformation
    bool2int
    :arguments x
    :concept nil
    :instance nil
    :local-context lc
    :global-context gc
    (if (equal x True)
        (return 1)
        (if (equal x False)
            (return 0)
            (fatal_error "bool2int: converting non-boolean value")
        )
    )
)


(transformation opsem :concept function_call -
    (nil 
        (goto-to-state argument-evaluation 0
            (length (aget i 'arguments)) nil))
    ((argument-evaluation j n argval)
        (if
            (not (equal argval nil))
            (rcons (aget lc 'value) argval))
        (if (< j n)
            (progn (set-to 'element (+ j 1) n)
                (opsem (aget i 'arguments j) lc gc))
            (go-to-state 'call argval)))
    (call
        (apply-lambda (find-static-method (aget i 'name) n) argval)))

(transformation
    fatal_error
    :arguments msg
    :concept nil
    :instance nil
    :local-context lc
    :global-context gc
    (nil
        (go-to-state propagation (next-instance lc)))
    ((propagation j)
        (if (equal j nil)
            (progn
                (print ("Fatal error: "))
                (write msg)
            )
            (go-to-state propagation (next-instance lc))
        )
    )
)

; TODO add type checks, forbid (1 + true)

