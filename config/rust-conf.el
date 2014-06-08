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
  '((candidates . (list "to_str" "as_ref" "as_slice" "iter" "to_string" "println!" "print!" "vec!" "format!" "is_some" "is_empty" "is_none"))
    (action . ac-rust-action)
    (prefix . ac-rust-prefix)
    (requires . 0)
    (symbol . "m")))

;; (setq racer-cmd "/users/wangshuyu/Works/rust/racer/bin/racer")
;; (setq rust-srcpath "/Users/wangshuyu/Repos/rust/src")

;; (require 'racer-autocomplete)
(add-hook 'rust-mode-hook
          #'(lambda ()
            ;; Default indentation is usually 2 spaces, changing to 4.
            (add-to-list 'ac-sources 'ac-source-files-in-current-dir)
            (electric-pair-mode t)
            (local-set-key (kbd "C-S-j") 'my-rust-newline-and-indent)
            (electric-pair-mode t)
            (add-to-list 'ac-sources 'ac-source-rust)
            ;(add-to-list 'ac-sources 'ac-source-racer)
            ))
