(use-package emacs
  :init
  (let ((user-custom-file (expand-file-name "lisp/custom.el" user-emacs-directory)))
    (unless (file-exists-p user-custom-file)
      (make-empty-file user-custom-file t))
    (setq custom-file user-custom-file))
  (load custom-file)
  (setq frame-title-format "%b - Emacs")
  :custom
  (display-line-numbers 'visual)
  (truncate-lines t)
  (icomplete-vertical-mode t)
  (electric-pair-mode t))

(provide 'config)
