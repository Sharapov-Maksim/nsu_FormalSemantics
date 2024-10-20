
; содержимое psm для первичной модели Python на PSML
(psm-empty)

(psm-lan Python) ; Добавляем язык моделей Python-конструкций
(psm-clan Python) ; Делаем его текущим языком

(psm-atype variable (lisp symbol)) ; Определяем типы моделей лексических конструкций языка

; Определяем типы моделей лексических конструкций языка
(psm-atype int * (lisp int))
(psm-atype bool * True False)


(psm-type class class_decl * ((name name) (body (class_member_decl))))
(psm-utype class_member_decl * constructor_def method_def)
(psm-type constructor constructor_def * (args (list name)) (body (list statement)))
(psm-type method method_def * (args (list name)) (body (list statement)))



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


; Типы моделей операторов языка
(psm-utype statement * class_decl if-statement block-statement while-statement for-statement variable-assignment property-access-write)
(psm-type if if-statement * (condition boolean-expression) (then statement) (opt else statement))
(psm-type block block-statement * (flatten statement-list (list statement)))
(psm-type while while-statement * (condition boolean-expression) (body statement))
(psm-type for for-statement * (iterator variable) (from expression) (to expression) (body statement)) 
(psm-type set variable-assignment * (variable variable) (expression arithmetic-expresssion))
; оператор присваивания значения в свойство:
(psm-type accw property-access-write * (object expression) (path (list expression)) (value expression))
; вызов метода
(psm-type accw property-access-call * (object property-access-read) (name name) (args (list expression)))


(psm-type program program * (name symbol) (body (list statement)))


