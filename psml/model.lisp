
; содержимое psm для первичной модели Python на PSML
(ontology Python) ; Добавляем язык моделей Python-конструкций
(current-ontology Python) ; Делаем его текущим языком

(model program :constructor program :arguments 
    (body (list statement)) ; list can be empty
) ; file_input in g4

(concept-by-value identifier symbol)
(concept-by-value int-atom (lisp int))
(concept-by-value bool-atom (True False))
(concept-by-union object None object-with-id)
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
    augment_operation
    expression
)
(concept-by-value augment_operation (|+=|, |-=|, |*=|, |@=|, |/=|, |%=|, |&=|, ||=|, |^=|, |<<=|, |>>=|, |**=|, |//=|)) ; TODO syntax?

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
    (method identifier)
    :flatten (arguments (list expression))
)

(concept function_call :constructor function_call :arguments ; name(args...)
    (method identifier)
    :flatten (arguments (list expression))
)

;; COMPOUND STATEMENTS

(concept block :constructor block :arguments
    (list statement)
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

;(psm-utype class_member_decl * constructor_def method_def)
;(psm-type constructor constructor_def * (args (list name)) (body (list statement)))
;(psm-type method method_def * (name name) (args (list name)) (body (list statement)))

(concept if-statement :constructor if :arguments
    (condition boolean-expression) 
    (then block) 
    (:opt elif if-statement)
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



; Определяем типы моделей выражений языка
(psm-utype expression * arithmetic-expression boolean-expression)
; Арифметические выражения
(psm-utype arithmetic-expression * +expression -expression *expression /expression variable property-access-read)
(psm-type + +expression * (left arithmetic-expression) (right arithmetic-expression))
(psm-type - -expression * (left arithmetic-expression) (right arithmetic-expression))
(psm-type * *expression * (left arithmetic-expression) (right arithmetic-expression))
(psm-type / /expression * (left arithmetic-expression) (right arithmetic-expression))
; Булевские выражения
(psm-utype boolean-expression * not-expression and-expression or-expression equality inequality arithmetic-relation)
(psm-type not not-expression * (arg boolean-expression))
(psm-type and and-expression * (args (list boolean-expression)))
(psm-type or or-expression * (list args boolean-expression))
(psm-utype arithmetic-relation * <relation >relation <=relation >=relation !=relation)
(psm-type < <relation * (left arithmetic-expression) (right arithmetic-expression))
(psm-type > >relation * (left arithmetic-expression) (right arithmetic-expression))
(psm-type <= <=relation * (left arithmetic-expression) (right arithmetic-expression))
(psm-type >= >=relation * (left arithmetic-expression) (right arithmetic-expression))
(psm-type = equality * (left expression) (right expression))
(psm-type != inequality * (left expression) (right expression))
; выражение чтения из свойства:
(psm-type accr property-access-read * (object expression) (path (list expression)))
; вызов метода
(psm-type accw property-access-call * (object property-access-read) (args (list expression)))


; Типы моделей операторов языка
(psm-utype statement * class_decl if-statement block-statement while-statement for-statement variable-assignment property-access-write)
(psm-type while while-statement * (condition boolean-expression) (body statement))
(psm-type for for-statement * (iterator variable) (from expression) (to expression) (body statement)) 
(psm-type set variable-assignment * (variable variable) (expression arithmetic-expresssion))
; оператор присваивания значения в свойство:
(psm-type accw property-access-write * (object expression) (path (list expression)) (value expression))

