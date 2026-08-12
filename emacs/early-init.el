;;; Stealing a lot of startup optimizations from bbatsov and hlissner :]
;; Set persistent state directories based on XDG compliance
(setq no-littering-etc-directory
      (if (getenv "XDG_DATA_HOME")
	  (substitute-in-file-name "$XDG_DATA_HOME/emacs/")
	(expand-file-name "etc/" user-emacs-directory))
      no-littering-var-directory
      (if (getenv "XDG_CACHE_HOME")
	  (substitute-in-file-name "$XDG_CACHE_HOME/emacs/")
	(expand-file-name "var/" user-emacs-directory)))
(setq package-user-dir no-littering-var-directory)
(startup-redirect-eln-cache no-littering-var-directory)
;; Disable default package manager to make way for elpaca
(setq package-enable-at-startup nil)

;; Start sending debug messages sooner
(let ((debug (getenv-internal "DEBUG")))
  (when (and
	 (stringp debug)
	 (string= debug ""))
    (setq init-file-debug t
	  debug-on-error t))
  (setq debug-on-error init-file-debug
	jka-compr-verbose init-file-debug)
  ;; Suppress compiler warnings if debug is disabled
  (setq native-comp-async-report-warnings-errors init-file-debug
	native-comp-warning-on-missing-source init-file-debug))

;; Turn off garbage collection for early initialization
(setq gc-cons-percentage 1.0
      gc-cons-threshold most-positive-fixnum)
(when noninteractive (setq gc-cons-threshold (* 128 1024 1024))); 128MB

;; and then turn it back on once startup is finished
(add-hook 'emacs-startup-hook
	  (lambda ()
	    (setq gc-cons-threshold (* 32 1024 1024); 32MB
		  gc-cons-percentage 0.2)))

;; Read larger chunks from subprocesses
(setq read-process-output-max (* 64 1024))

;; I doubt I'll ever use Windows again but if I do, I'll be ready
(when (boundp 'w32-get-true-file-attributes)
  (setq w32-get-true-file-attributes nil    ; reduce IO ops
        w32-pipe-read-delay 0               ; faster IPC
        w32-pipe-buffer-size (* 64 1024)))  ; read more at a time (was 4K)

(let (realhome)
  (when (and (memq system-type '(cygwin windows-nt ms-dos))
             (null (getenv-internal "HOME"))
             (setq realhome (getenv "USERPROFILE")))
    (setenv "HOME" realhome)
    (setq abbreviated-home-dir nil)))

;; Don't try native compilation if it is not supported
(when (and
       (featurep 'native-compile)
       (not (native-comp-available-p)))
  (delq 'native-compile features))

;; Disable case insensitivity for major mode detection
(setq auto-mode-case-fold nil
      ad-redefinition-action 'accept)

;; Prevent unncessary frame sizing and startup screen initialization
(unless noninteractive
  (setq frame-inhibit-implied-resize t)
  ;; Don't want no toolbar, Don't want no menu either
  (push '(tool-bar-lines . 0) default-frame-alist)
  (setq tool-bar-mode nil)
  ;; (push '(menu-bar-lines . 0) default-frame-alist)
  ;; (setq menu-bar-mode nil)
  
  ;; I don't want the GNU screen or text in my scratch buffer on startup
  (setq inhibit-startup-screen t
	inhibit-startup-echo-area-message user-login-name
	initial-major-mode 'fundamental-mode
	initial-scratch-message nil
	tool-bar-mode nil)
  (advice-add #'tool-bar-setup :override #'ignore)
  (advice-add #'display-startup-echo-area-message :override #'ignore)
  (advice-add #'display-startup-screen :override #'ignore)
  
  ;; I don't want display flashes at startup, so just turn it off until initialization is done
  (unless init-file-debug
    (put 'mode-line-format 'initial-value (default-toplevel-value 'mode-line-format))
    (setq-default mode-line-format nil)
    (dolist (buf (buffer-list))
      (with-current-buffer buf (setq mode-line-format nil)))
    (setq-default inhibit-redisplay t
		  inhibit-message t)
    (defun startup--reset-display ()
      (remove-hook 'post-command-hook #'startup--reset-display)
      (setq-default inhibit-redisplay nil
		    inhibit-message nil))
    (add-hook 'post-command-hook #'startup--reset-display -100))

  (define-advice startup--load-user-init-file (:around (fn &rest args) undo-hacks 95)
    "Undo a bunch of hacky shit I stole from hlissner"
    (unwind-protect (apply fn args)
      (setq-default inhibit-message nil)
      (advice-remove #'tool-bar-setup #'ignore)
      (define-advice tool-bar-mode (:after (&rest _) setup)
	(advice-remove #'tool-bar-mode #'tool-bar-mode@setup)
	(tool-bar-setup))
      (unless (default-toplevel-value 'mode-line-format)
	(setq-default mode-line-format (get 'mode-line-format 'initial-value)))))
  ;; Remove command line options that are irrelevant to current operating system
  (unless (eq system-type 'darwin)
    (setq command-line-ns-option-alist nil))
  (unless (memq initial-window-system '(x pgtk))
    (setq command-line-x-option-alist nil))

  ;; Prevent type checking on already initialized defcustom variables
  (define-advice setopt--set (:around (fn &rest args) inhibit-load-symbol -90)
    (let ((custom-load-recursion t))
      (apply fn args))))

;;; early-init ends here
