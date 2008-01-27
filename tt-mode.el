;; tt-mode.el --- Emacs major mode for editing Template Toolkit files
;;
;; Copyright (c) 2002 Dave Cross, all rights reserved.
;;
;; This file may be distributed under the same terms as GNU Emacs.
;;
;; $Id$
;;
;; This file adds simple font highlighting of TT directives when you are
;; editing Template Toolkit files.
;;
;; I usually give these files an extension of .tt and in order to automatically
;; invoke this mode for these files, I have the following in my .emacs file.
;;
;; (setq load-path
;;      (cons "/home/dave/xemacs" load-path))
;; (autoload 'tt-mode "tt-mode")
;; (setq auto-mode-alist
;;  (append '(("\\.tt$" . tt-mode))  auto-mode-alist ))
;;
;; Something similar may well work for you.
;;
;; Author: Dave Cross <dave@dave.org.uk>
;;
;;
;; $Log$
;; Revision 1.7  2005/09/28 06:33:28  dave
;; More fixes from Sam Vilain.
;;
;; Revision 1.6  2004/01/30 12:32:50  dave
;; Added (previously missing) FOR directive to list of keywords.
;; Added support for TT comments.
;; (Thanks to Sam Vilian for these fixes)
;;
;; Revision 1.5  2002/06/16 10:01:24  dave
;; A final fix to the [% ... %] regex. It now seems to to everything
;; I want :)
;;
;; Revision 1.4  2002/06/15 20:00:13  dave
;; Added list of TT keywords
;;
;; Revision 1.3  2002/06/15 15:08:03  dave
;; Added a bit more complexity to the regex
;;
;; Revision 1.2  2002/06/15 14:35:26  dave
;; Improved regex to match [% ... %]
;;
;; Revision 1.1.1.1  2002/06/15 13:51:56  dave
;; Initial Version
;;
;;

(require 'font-lock)

(defvar tt-mode-hook nil
  "List of functions to call when entering TT mode")

(defvar tt-keywords
  (concat "\\b\\(?:"
          (regexp-opt (list "GET" "CALL" "SET" "DEFAULT" "INSERT" "INCLUDE"
                            "BLOCK" "END" "PROCESS" "WRAPPER" "IF" "UNLESS"
                            "ELSIF" "ELSE" "SWITCH" "CASE" "FOR" "FOREACH"
                            "WHILE" "FILTER" "USE" "MACRO" "PERL" "RAWPERL"
                            "TRY" "THROW" "CATCH" "FINAL" "LAST" "RETURN"
                            "STOP" "CLEAR" "META" "TAGS"))
          "\\)\\b"))

(defvar tt-font-lock-keywords
   (list
    ;; Fontify [& ... &] expressions
    '("\\(\\[%[-+]?\\)\\(\\(.\\|\n\\)+?\\)\\([-+]?%\\]\\)"
      (1 font-lock-string-face t)
      (2 font-lock-variable-name-face t)
      (4 font-lock-string-face t))
    ;; Look for keywords within those expressions
    '("\\[% *\\(#.*?\\)%\\]"
      (1 font-lock-comment-face t))
    '("\\[% *\\([a-z_0-9]*\\) *%\\]"
      (1 font-lock-constant-face t))
    (list (concat
	   "\\(\\[%[-+]?\\|;\\)[ \n	]*\\("
	   tt-keywords
	   "\\)")
	  2 font-lock-keyword-face t)
    )
  "Expressions to font-lock in tt-mode.")

(defun tt-mode ()
  "Major mode for editing Template Toolkit files"
  (interactive)
  (kill-all-local-variables)
  (setq major-mode 'tt-mode)
  (setq mode-name "TT")
  (if (string-match "Xemacs" emacs-version)
      (progn
	(make-local-variable 'font-lock-keywords)
	(setq font-lock-keywords tt-font-lock-keywords))
    ;; Emacs
    (make-local-variable 'font-lock-defaults)
    (setq font-lock-defaults '(tt-font-lock-keywords nil t))
    )
  (font-lock-mode)
  (run-mode-hooks 'tt-mode-hook))

(provide 'tt-mode)

;; tt-mode.el ends here
