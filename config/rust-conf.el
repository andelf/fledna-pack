;;; rust-mode
(require 'rust-mode)

(defun my-rust-newline-and-indent ()
  (interactive "*")
  (move-end-of-line 1)
  (delete-horizontal-space t)
  (unless (string= (string (char-before)) ";")
    (insert ";"))
  (newline)
  (indent-according-to-mode))

(defun my-rust-brace ()
  (interactive "*")
  (move-end-of-line 1)
  (if (or (string= (string (char-before)) "(")
          (nth 8 (syntax-ppss))
          (not (eolp)))
      (insert "{")

    (progn
      (when (not (string= (string (char-before)) " "))
        (insert " "))
      (let ((blink-matching-paren nil)
            (electric-pair-mode nil))
        (insert "{")
        (newline-and-indent)
        (newline-and-indent)
        (insert "}")
        (indent-according-to-mode)
        (previous-line)
        (indent-according-to-mode)))))

(defun ac-rust-action ()
  (let ((item (cdr ac-last-completion)))
    (when (stringp item)
      (insert "()")
      (backward-char))))

(defun ac-rust-prefix ()
  (or (ac-prefix-symbol)
       (let ((c (char-before)))
         (when (eq ?\. c)
           (point)))))


(ac-define-source rust
  '((candidates . (list "as_ref" "as_slice" "iter" "to_string" "println!" "print!" "vec!" "format!" "is_some" "is_empty" "is_none"))
    (action . ac-rust-action)
    (prefix . ac-rust-prefix)
    (requires . 0)
    (symbol . "m")))

;; (setq racer-cmd "/users/wangshuyu/Works/rust/racer/bin/racer")
;; (setq rust-srcpath "/Users/wangshuyu/Repos/rust/src")
(setq cargo-compilation-regexps
  (let ((file "\\([^ :\n].rs\\)")
        (start-line "\\([[:digit:]]+\\)")
        (start-col  "\\([[:digit:]]+\\)")
        (end-line   "\\([[:digit:]]+\\)")
        (end-col    "\\([[:digit:]]+\\)")
        (error-or-warning "\\(?:[Ee]rror\\|\\([Ww]arning\\)\\)"))
    (let ((re (concat "^" file ":" start-line ":" start-col
                      ": " end-line ":" end-col
                      " \\(?:[Ee]rror\\|\\([Ww]arning\\)|\\([Nn]ote\\)\\):")))
      (cons re '(1 (2 . 4) (3 . 5))))))


(setq racer-rust-src-path "/Users/wangshuyu/github/rust/src/")
(setq racer-cmd "/Users/wangshuyu/github/racer/target/release/racer")
(require 'racer-autocomplete)

;; (require 'racer-autocomplete)
(require 'compile)

(require 'flymake-rust)
(add-hook 'rust-mode-hook 'flymake-rust-load)

(add-hook 'rust-mode-hook
          #'(lambda ()
            (add-to-list 'ac-sources 'ac-source-files-in-current-dir)
            (electric-pair-mode t)
            (local-set-key (kbd "C-S-j") 'my-rust-newline-and-indent)
            (local-set-key (kbd "C-{") 'my-rust-brace)
            (local-set-key (kbd "M-RET") 'flymake-popup-current-error-menu)
            (electric-pair-mode t)
            (set (make-local-variable 'tab-width) 2)
            ;; (add-to-list 'ac-sources 'ac-source-rust)
            (make-local-variable 'compilation-error-regexp-alist)
            (add-to-list 'compilation-error-regexp-alist-alist
                         (cons 'cargo rustc-compilation-regexps))
            (setq compilation-error-regexp-alist (list 'cargo))
            (add-to-list 'ac-sources 'ac-source-racer)
            ;;(add-to-list 'compilation-error-regexp-alist rustc-compilation-regexps)
            ))


; (eval-after-load "rust-mode" '(require 'racer))
