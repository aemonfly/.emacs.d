;;add the smex package.
(require 'smex)
(smex-initialize)

;;key binding
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;;this your old M-x keys
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

(provide 'init-smex)
