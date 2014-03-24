;;; -*-Emacs-Lisp-*-
;;; This file bootstrap the configuration, which is divided into 
;;; a number of other files.

(let ((minver 24))
	(unless (>= emacs-major-version minver)
		(error "Your Emacs is too old -- this config requires v%s or higher" minver)))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
;;;Measure startup time
(require 'init-benchmarking)

;;; init smex
(require 'init-smex)

;;; init c-cpp mode
(require 'init-c-cpp)

;;; init org mode
(require 'init-org)
