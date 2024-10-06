
; содержимое psm для первичной модели Python на PSML
(psm-empty)

(psm-lan Python) ; Добавляем язык моделей Python-конструкций
(psm-clan Python) ; Делаем его текущим языком

(psm-atype variable (lisp symbol)) ; Определяем типы моделей лексических конструкций языка SL


(psm-atype int (lisp int))
(psm-atype bool * True False)











