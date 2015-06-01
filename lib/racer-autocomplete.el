;; FileName    : racer-autocomplete.el
;; Author      : ShuYu Wang <andelf@gmail.com>
;; Created     : Wed May 20 10:08:03 2015 by ShuYu Wang
;; Copyright   : Feather Workshop (c) 2015
;; Description : racer auto-complete source
;; Time-stamp: <2015-05-20 10:08:18 andelf>

;;; copy this to your load-path and add following to your ~/.emacs

;; (setq racer-cmd "/your/path/to/bin/racer")
;; (setq rust-srcpath "/your/path/to/rust/src")
;; (require 'racer-autocomplete)
;; (add-hook 'rust-mode-hook
;;           #'(lambda ()
;;             (add-to-list 'ac-sources 'ac-source-racer)
;;             ))

(defvar racer-cmd "/Users/wangshuyu/github/racer/target/release/racer")
(defvar rust-srcpath "/Users/wangshuyu/github/rust/src/")

;;; rust-mode no longer requires cl, so am putting it here for now (this file uses 'case')
(require 'cl)

(defvar racer-file-name)
(defvar racer-tmp-file-name)
(defvar racer-line-number)
(defvar racer-column-number)
(defvar racer-completion-results)
(defvar racer-start-pos)
(defvar racer-end-pos)

(defun racer-get-line-number ()
  ; for some reason if the current-column is 0, then the linenumber is off by 1
  (if (= (current-column) 0)
      (1+ (count-lines 1 (point)))
    (count-lines 1 (point))))

(defun racer--write-tmp-file (tmp-file-name)
  "Write the racer temporary file to `TMP-FILE-NAME'."
    (push-mark)
    (setq racer-file-name (buffer-file-name))
    (setq racer-tmp-file-name tmp-file-name)
    (setq racer-line-number (racer-get-line-number))
    (setq racer-column-number (current-column))
    (setq racer-completion-results `())
    (write-region nil nil tmp-file-name nil 0))

(defun racer--tempfilename ()
  (concat temporary-file-directory (file-name-nondirectory (buffer-file-name)) ".racertmp"))

(defun racer--candidates ()
  (setenv "RUST_SRC_PATH" rust-srcpath)
  (let ((tmpfilename (concat (buffer-file-name) ".racertmp")))
    (racer--write-tmp-file tmpfilename)
    (unwind-protect
        (progn
          (let ((completion-results (list))
                (lines (process-lines racer-cmd
                                      "complete"
                                      (number-to-string (count-lines 1 (point)))
                                      (number-to-string (current-column))
                                      tmpfilename)))
            (dolist (line lines)
              (when (string-match "^MATCH \\([^,]+\\),\\(.+\\)$" line)
                (let ((completion (match-string 1 line)))
                  (push completion completion-results))))
            completion-results))
      (delete-file tmpfilename))))

(defun racer--prefix ()
  (setenv "RUST_SRC_PATH" rust-srcpath)
  (let ((tmpfilename (concat (buffer-file-name) ".racertmp")))
    (racer--write-tmp-file tmpfilename)
    (unwind-protect
        (progn
          (let ((lines (process-lines racer-cmd
                                      "prefix"
                                      (number-to-string (count-lines 1 (point)))
                                      (number-to-string (current-column))
                                      tmpfilename)))

            (when (string-match "^PREFIX \\(.+\\),\\(.+\\),\\(.*\\)$" (nth 0 lines))
              (+ (- (point) (current-column))
                 (string-to-number (match-string 1 (nth 0 lines)))))))
      (delete-file tmpfilename))))

(ac-define-source racer
  '((candidates . racer--candidates)
    (prefix . racer--prefix)
    (requires . 0)
    (cache)
    (symbol . "R")))

(provide 'racer-autocomplete)
