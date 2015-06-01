(global-set-key (kbd "C-c C-k") 'smart-compile)
(global-set-key (kbd "<f5>") 'smart-compile)

;;; compilation
(setq compilation-scroll-output nil)
(setq compilation-auto-jump-to-first-error nil)
(setq compilation-auto-jump-to-first-error t)

(require 'smart-compile)
(add-to-list 'smart-compile-alist '(rust-mode  . "cargo build"))
(add-to-list 'smart-compile-alist '("Cargo.toml" . "cargo build"))
