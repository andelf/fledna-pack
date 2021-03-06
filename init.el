;; User pack init file
;;
;; User this file to initiate the pack configuration.
;; See README for more information.

;; Load bindings config
(live-load-config-file "bindings.el")
(setq user-mail-address "andelf@gmail.com")
(setq user-full-name "ShuYu Wang")
(setq user-id "20073034")
(setq user-login-name "andelf")

(add-hook 'before-save-hook 'time-stamp)

;;; max buffer menu name
(setq Buffer-menu-name-width 40)

;;; personalized
(setenv "PATH"
        (concat
         "/usr/local/bin" ":"
         (concat (live-pack-dir 'fledna-pack) "bin") ":"
         (getenv "PATH")))

;; (live-set-default-darwin-font "Tsentsiu Sans Mono HG-14")
(live-set-default-font "Monoid-14")
;; (live-set-default-font "Monaco-12")
;;(set-default-font "-apple-Monaco-medium-normal-normal-*-*-*-*-*-m-0-iso10646-1")
;;(set-frame-font "-*-Source Sans Pro-light-normal-normal-*-*-*-*-14-p-0-iso10646-1")
;;; pbcopy & pbpaste for Emacs
(when (and (eq system-type 'darwin) (not window-system))
  (defun copy-from-osx ()
    (shell-command-to-string "pbpaste"))
  (defun paste-to-osx (text &optional push)
    (let ((process-connection-type nil))
      (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
        (process-send-string proc text)
        (process-send-eof proc))))
  (setq interprogram-cut-function 'paste-to-osx)
  (setq interprogram-paste-function 'copy-from-osx)
  )

;;; fuck u for zone xxx
(setq live-disable-zone t)

;; cursor not blink
(blink-cursor-mode -1)
;; Display time and battery
(setq display-time-day-and-date t)
(setq display-time-format "%m/%d %H:%M")
(setq display-time-24hr-format t)
(display-time)
(if (eq system-type 'darwin)
    (setq ns-use-native-fullscreen t))
;; (or (eq system-type 'darwin)
;;     (display-battery-mode t))
(display-battery-mode -1)
;;; cursor big bay
(setq cursor-type '(bar . 10))

;;; temp
(global-set-key (kbd "C-x C-b") 'electric-buffer-list)
;;(global-set-key (kbd "<C-tab>") 'other-window)
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
;; (my-global-linum-mode 1)

;;; eshell

(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(add-hook 'term-mode-hook (lambda()
                            (setq yas-dont-activate t)
                            (setenv "TERM" "ansi")))
;;; rust
(live-load-config-file "rust-conf.el")

;;;
(live-load-config-file "compile-conf.el")

;;; golang
(add-to-list 'load-path "/usr/local/Cellar/go/1.2/misc/emacs")
(require 'go-mode-load)
;;; gocode
(add-to-list 'load-path "/usr/local/Cellar/go/1.2/src/pkg/github.com/nsf/gocode/emacs")
(require 'go-autocomplete)
(require 'auto-complete-config)

;;; erlang
(live-add-pack-lib "erlang-mode")
(require 'erlang-start)
(add-to-list 'auto-mode-alist '("\\.app\\.src$" . erlang-mode))

(when (eq system-type 'darwin)
  (setq erlang-root-dir "/usr/local/Cellar/erlang/R16B/")
  (setq erlang-man-root-dir "/usr/local/Cellar/erlang/R16B/share/man/")
  )

;;; swift
(defun swift-mode:indent-on-parentheses ()
  (when (and (equal mode-name "Swift")
             (eq (char-before) last-command-event)
             (char-syntax last-command-event)
             (= (char-syntax (char-before)) ?\{)
             t)
    (newline)
    (insert "}")
    (indent-according-to-mode)
    (backward-char)
    (newline)
    (indent-according-to-mode)))

;; (or (string= (string (char-before)) ")")
(defun my-swift-brace ()
  (interactive "*")
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

(add-to-list 'ac-dictionary-directories "~/.live-packs/fledna-pack/etc/ac-dict")
(require 'swift-mode)
(defun my-swift-mode-hook ()
  (add-to-list 'ac-sources 'ac-source-files-in-current-dir)
  (electric-pair-mode t)
  (electric-indent-mode t)
  ;; (add-hook 'post-self-insert-hook
          ;;;  'swift-mode:indent-on-parentheses)
  (local-set-key (kbd "{") 'my-swift-brace)
  (set (make-local-variable 'tab-width) 2)
  (set (make-local-variable 'swift-indent-offset) 2)
  (set (make-local-variable 'electric-indent-chars) '(?\n ?\: ?\{)))

(add-hook 'swift-mode-hook 'my-swift-mode-hook)


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
        (car (split-string
              (shell-command-to-string "hostname"))))))

;;; erlang flymake
(require 'flymake)
(require 'erlang-flymake)

(defun my-find-rebar-root ()
  (let ((dir (locate-dominating-file default-directory "rebar")))
    (or dir default-directory)))
(defun my-inferior-erlang-compile ()
  (interactive)
  (let ((default-directory (my-find-rebar-root)))
    (compile "./rebar compile")))

(defun my-erlang-mode-hook ()
  (local-set-key [f9] 'my-inferior-erlang-compile)
  (imenu-add-menubar-index))
(add-hook 'erlang-mode-hook 'my-erlang-mode-hook)


(live-add-pack-lib "nitrogen-mode")
(require 'nitrogen-mode)

(live-add-pack-lib "zotonic-tpl-mode")
(require 'zotonic-tpl-mode)

(live-add-pack-lib "gfm-mode")
(require 'gfm-mode)
(add-to-list 'auto-mode-alist '("\\.md$" . gfm-mode))

(menu-bar-mode t)

;;; haskell
;; (live-add-pack-lib "haskell-mode")
;; (require 'haskell-mode-autoloads)
;; (add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
;; ;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;; (add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;; ;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)

(add-hook 'haskell-mode-hook
  (lambda ()
    ;; Default indentation is usually 2 spaces, changing to 4.
    (set (make-local-variable 'tab-width) 2)
    ))

(add-hook 'js2-mode-hook
  (lambda ()
    ;; Default indentation is usually 2 spaces, changing to 4.
    (set (make-local-variable 'tab-width) 2)
    ))


(live-add-pack-lib "hamlet-mode")
(require 'hamlet-mode)
(add-hook 'html-mode-hook
  (lambda ()
    ;; Default indentation is usually 2 spaces, changing to 4.
    (set (make-local-variable 'sgml-basic-offset) 2)
    (set (make-local-variable 'tab-width) 2)
    ))

;;; lua-mode
(require 'lua-mode)

;;; yasinppet
(setq yas-prompt-functions
      '(yas-dropdown-prompt yas-ido-prompt yas-x-prompt yas-completing-prompt yas-no-prompt))
(setq yas/root-directory (cons "~/.live-packs/fledna-pack/etc/snippets" yas/root-directory))
(mapc 'yas/load-directory yas/root-directory)

;;; golang
(require 'go-mode-load)
(require 'go-autocomplete)
(add-hook 'go-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'gofmt-before-save)
            (setq tab-width 4)
            (setq indent-tabs-mode 1)))

;;; ess
(add-to-list 'load-path "/Users/wangshuyu/.live-packs/fledna-pack/lib/ess-14.09/lisp")
(load "ess-site")

;;; ac modes
(add-to-list 'ac-modes 'erlang-mode)
(add-to-list 'ac-modes 'rust-mode)
(add-to-list 'ac-modes 'go-mode)
(add-to-list 'ac-modes 'lua-mode)
(add-to-list 'ac-modes 'swift-mode)

(define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
;;(setq ac-auto-start 2)
(define-key ac-completing-map "\M-/" 'ac-stop)
(define-key ac-completing-map "\t" 'ac-complete)
;;; Ignore case if completion target string doesn't include upper characters
(setq ac-ignore-case 'smart)

;;(define-key ac-complete-mode-map "<return>"   'nil)
; (define-key ac-complete-mode-map "RET"        'nil)


;;; xcscope
(require 'xcscope)

(require 'elixir-mode)
(add-hook 'elixir-mode-hook
          (lambda ()
            (setq tab-width 2)
            (setq default-tab-width 2)))

;;; imenu
;;; C-x C-i

(setq org-startup-indented t)

;;; speedbar
;; (defconst my-speedbar-buffer-name "SPEEDBAR")
;; try this if you get "Wrong type argument: stringp, nil"
(speedbar -1)
(speedbar-add-supported-extension ".js")
(speedbar-add-supported-extension ".erl")
(speedbar-add-supported-extension ".dtl")
(speedbar-add-supported-extension ".rs")
(defconst my-speedbar-buffer-name " SPEEDBAR")
(defun my-speedbar-no-separate-frame ()
  (interactive)
  (when (not (buffer-live-p speedbar-buffer))
    (setq speedbar-buffer (get-buffer-create my-speedbar-buffer-name)
          speedbar-frame (selected-frame)
          dframe-attached-frame (selected-frame)
          speedbar-select-frame-method 'attached
          speedbar-verbosity-level 0
          speedbar-last-selected-file nil)
      (set-buffer speedbar-buffer)
      (speedbar-mode)
      (speedbar-reconfigure-keymaps)
      (speedbar-update-contents)
      (speedbar-set-timer 1)
      (make-local-hook 'kill-buffer-hook)
      (add-hook 'kill-buffer-hook
                (lambda () (when (eq (current-buffer) speedbar-buffer)
                             (setq speedbar-frame nil
                                   dframe-attached-frame nil
                                   speedbar-buffer nil)
                             (speedbar-set-timer nil)))))
  (set-window-buffer (selected-window)
                     (get-buffer my-speedbar-buffer-name)))

(global-set-key (kbd "C-x C-m") 'my-speedbar-no-separate-frame)

;;; set fill column
(setq-default fill-column 120)

(require 'rainbow-identifiers)
(add-hook 'prog-mode-hook 'rainbow-identifiers-mode)

;;; f7 to goto shell

(global-set-key [f7] 'eshell)

(require 'package)
(add-hook 'haskell-mode-hook 'haskell-indentation-mode)



(require 'pcre2el)
(pcre-mode t)

(when (window-system)
  (set-frame-height (selected-frame) 48)
  (set-frame-width (selected-frame) 120)
  (set-frame-position (selected-frame) 0 0))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(electric-pair-inhibit-predicate (quote electric-pair-conservative-inhibit))
 '(haskell-notify-p t)
 '(haskell-process-type (quote ghci))
 '(haskell-stylish-on-save t)
 '(haskell-tags-on-save t)
 '(sclang-auto-scroll-post-buffer t)
 '(sclang-eval-line-forward nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(diff-added ((t (:foreground "Green"))))
 '(diff-removed ((t (:foreground "Red"))))
 '(ediff-even-diff-A ((((class color) (background dark)) (:background "dark green"))))
 '(ediff-even-diff-B ((((class color) (background dark)) (:background "dark red"))))
 '(ediff-odd-diff-A ((((class color) (background dark)) (:background "dark green"))))
 '(ediff-odd-diff-B ((((class color) (background dark)) (:background "dark red"))))
 '(mumamo-background-chunk-major ((((class color) (background dark)) (:background "black"))))
 '(mumamo-background-chunk-submode1 ((((class color) (background dark)) (:background "black")))))
