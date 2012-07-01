;;; ant-mode.el --- Mode for Ant build files
;; Copyright (C) 2012 Tony Graham

;; Author: Tony Graham <tkg@menteith.com>
;; Contributors: tarsius (Jonas Bernoulli)
;; Created: 12 May 2012
;; Keywords: languages, Ant, xml

;;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

;;; Commentary:

;; This package provides major mode `ant-mode'
;; for editing Ant build files.

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; imenu stuff

(defun ant-sort-alist (alist)
  "Sort an alist."
  (sort
   alist
   (lambda (a b) (string< (car a) (car b)))))

(defun ant-imenu-create-index-function ()
  "Create an alist of elements, etc. suitable for use with `imenu'."
  (interactive)
  (let ((target-alist '())
	(mode-alist '())
	(key-alist '())
	(attribute-set-alist '())
	(name-alist '())
	(function-alist '()))
    (goto-char (point-min))
    (while
	(re-search-forward
	 "^\\s-*<target\\(\\s-+\\)" nil t)
      ;; Go to the beginning of the whitespace after the element name
      (goto-char (match-beginning 1))
      ;; Match on either single-quoted or double-quoted attribute value.
      ;; The expression that doesn't match will have return nil for
      ;; `match-beginning' and `match-end'.
      ;; Don't move point because the 'mode' attribute may be before
      ;; the 'match' attribute.
      (if (save-excursion
	    (re-search-forward
	     "name\\s-*=\\s-*\\(\"\\([^\"]*\\)\"\\|'\\([^']*\\)'\\)"
	     (save-excursion
	       (save-match-data
		 (re-search-forward "<\\|>" nil t)))
	     t))
	  (let* ((pattern (buffer-substring-no-properties
			   ;; Rely on the pattern that didn't match
			   ;; returning nil and on `or' evaluating the
			   ;; second form when the first returns nil.
			   (or
			    (match-beginning 2)
			    (match-beginning 3))
			   (or
			    (match-end 2)
			    (match-end 3))))
		 (pattern-position (or
				    (match-beginning 2)
				    (match-beginning 3))))
	      (setq target-alist
		    (cons (cons pattern pattern-position)
			  target-alist)))))
    (append
     (ant-sort-alist target-alist))))


;;;###autoload
(define-derived-mode ant-mode nxml-mode "Ant"
  "Major mode for editing Ant build files."
  (setq rng-schema-locating-files
	(add-to-list 'rng-schema-locating-files
		     (locate-file "ant-schemas.xml" load-path)))
  (rng-auto-set-schema)
  (speedbar-add-supported-extension (list "build.*\\.xml"))
  (setq imenu-create-index-function 'ant-imenu-create-index-function)
  (setq imenu-extract-index-name-function 'ant-imenu-create-index-function)
  (imenu-add-to-menubar "Ant")
  (make-local-variable 'tab-width)
  (setq tab-width 8))

(provide 'ant-mode)
;;; ant-mode.el ends here
