;;; define the shortcut for compiling the c/cpp code
(defun aemon-c++-mode-hook()
  (define-key c-mode-base-map [(f7)] 'compile))

;;; add the shortcut to c-mode key maps
(add-hook 'c-mode-common-hook
	  (lambda () (define-key c-mode-base-map (kbd "<f7>") 'compile)))
(provide 'init-c-cpp)
