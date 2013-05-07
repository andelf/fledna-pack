;; User pack init file
;;
;; User this file to initiate the pack configuration.
;; See README for more information.

;; Load bindings config
(live-load-config-file "bindings.el")

(add-hook 'before-save-hook 'time-stamp)

;;; personalized
(setenv "PATH"
        (concat
         "/usr/local/bin" ":"
         (concat (live-pack-dir 'fledna-pack) "bin") ":"
         (getenv "PATH")))


(set-default-font "-apple-Monaco-medium-normal-normal-*-*-*-*-*-m-0-iso10646-1")


;; cursor not blink
(blink-cursor-mode -1)
;; Display time and battery
(setq display-time-day-and-date t)
(setq display-time-format "%m/%d %H:%M")
(setq display-time-24hr-format t)
(display-time)
(display-battery-mode t)


;;; temp
(global-set-key (kbd "C-x C-b") 'electric-buffer-list)
(global-set-key (kbd "<C-tab>") 'other-window)
;; make C-c C-c and C-c C-u work for comment/uncomment region in all modes
(global-set-key (kbd "C-c c") 'comment-region)
(global-set-key (kbd "C-c u") 'uncomment-region)

;;; fuck ido-xxx
(global-set-key (kbd "C-x C-f") 'find-file)
(global-set-key (kbd "M-/") 'dabbrev-expand)

;; linum mode
(setq linum-format
      (lambda (line)
        (propertize
         (format (let ((w (length (number-to-string
                                   (count-lines (point-min) (point-max))))))
                   (concat "%4d |")) line) 'face 'linum)))
(defun my-linum-on ()    ; linum should turn off in non-editor buffer
  (unless (or (minibufferp)
              (equal frame-title-format "Speedbar 1.0")
              (equal (string-match "\\*.*\\*" (buffer-name)) 0))
    (linum-mode 1)))
(define-globalized-minor-mode my-global-linum-mode linum-mode my-linum-on)
(my-global-linum-mode 1)


;;; golang
(add-to-list 'load-path "/usr/local/Cellar/go/1.0.3/misc/emacs")
(require 'go-mode-load)
;;; gocode
(add-to-list 'load-path "/usr/local/Cellar/go/1.0.3/src/pkg/github.com/nsf/gocode/emacs")
                                        ;(require 'go-autocomplete)
(require 'go-autocomplete)
(require 'auto-complete-config)

;;; erlang
(live-add-pack-lib "erlang-mode")
(require 'erlang-start)
(add-to-list 'auto-mode-alist '("\\.app\\.src$" . erlang-mode))
;; (add-to-list 'load-path "/Users/wangshuyu/Repos/distel/elisp")
;; (require 'distel)
;; (distel-setup)
(setq erlang-root-dir "/usr/local/Cellar/erlang/R16B/")
(setq erlang-man-root-dir "/usr/local/Cellar/erlang/R16B/share/man/")

;; prevent annoying hang-on-compile
(defvar inferior-erlang-prompt-timeout t)
;; default node name to emacs@localhost
(setq inferior-erlang-machine-options '("-sname" "emacs"))
;; tell distel to default to that node
(setq erl-nodename-cache
      (make-symbol
       (concat
        "emacs@"
        ;; Mac OS X uses "name.local" instead of "name", this should work
        ;; pretty much anywhere without having to muck with NetInfo
        ;; ... but I only tested it on Mac OS X.
        (car (split-string (shell-command-to-string "hostname"))))))

;;; erlang flymake
(require 'flymake)
(require 'erlang-flymake)


(live-add-pack-lib "nitrogen-mode")
(require 'nitrogen-mode)

(live-add-pack-lib "zotonic-tpl-mode")
(require 'zotonic-tpl-mode)

(require 'markdown-mode)
(add-to-list 'auto-mode-alist '("\\.md$" . gfm-mode))

(menu-bar-mode t)

; (live-add-pack-lib "haskell-mode")
(load "~/.live-packs/fledna-pack/lib/haskell-mode/haskell-site-file")
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)

;;; yasinppet
(setq yas-prompt-functions
      '(yas-dropdown-prompt yas-ido-prompt yas-x-prompt yas-completing-prompt yas-no-prompt))

(setq yas/root-directory (cons "~/.live-packs/fledna-pack/etc/snippets" yas/root-directory))

(mapc 'yas/load-directory yas/root-directory)

;;; golang
(require 'go-mode-load)
(require 'go-autocomplete)


;;; ac modes
(setq ac-modes (cons 'erlang-mode ac-modes))

;;; xcscope
(require 'xcscope)
