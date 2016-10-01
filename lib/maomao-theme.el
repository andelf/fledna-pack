(deftheme maomao "DOCSTRING for maomao")
  (custom-theme-set-faces 'maomao
   '(default ((t (:foreground "#bef4ea" :background "#282828" ))))
   '(cursor ((t (:background "#fdf4c1" ))))
   '(fringe ((t (:background "#282828" ))))
   '(mode-line ((t (:foreground "#282828" :background "#7c6f64" ))))
   '(region ((t (:background "#504945" ))))
   '(secondary-selection ((t (:background "#3e3834" ))))
   '(font-lock-builtin-face ((t (:foreground "#fe8019" ))))
   '(font-lock-comment-face ((t (:foreground "#988574" ))))
   '(font-lock-function-name-face ((t (:foreground "#0aea74" ))))
   '(font-lock-keyword-face ((t (:foreground "#fb00de" ))))
   '(font-lock-string-face ((t (:foreground "#36b0ca" ))))
   '(font-lock-type-face ((t (:foreground "#a4ff36" ))))
   '(font-lock-constant-face ((t (:foreground "#ffec00" ))))
   '(font-lock-variable-name-face ((t (:foreground "#00cde1" ))))
   '(minibuffer-prompt ((t (:foreground "#b8bb26" :bold t ))))
   '(font-lock-warning-face ((t (:foreground "red" :bold t ))))
   )

;;;###autoload
(and load-file-name
    (boundp 'custom-theme-load-path)
    (add-to-list 'custom-theme-load-path
                 (file-name-as-directory
                  (file-name-directory load-file-name))))
;; Automatically add this theme to the load path

(provide-theme 'maomao)
