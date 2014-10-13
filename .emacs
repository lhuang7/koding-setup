;; Load MELPA
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
  )

;; User Setting
(setq user-full-name "Lingpo Huang")
(setq user-mail-address "lingpo.huang@plowtech.net")

;; Setting Default Package
 (require 'cl)
(defvar ling/packages '(  auto-complete
                          autopair
                          ;; haskell
                          haskell-mode
			  shm
			  ;; theme
			  color-theme
			  ;; ghc-mod
			  ghc
			  company
			  company-ghc
                          ;; fly-make
			  flymake
			  flymake-easy
                          flymake-hlint
			  ;; helm
			  helm
			  helm-git-grep
			  helm-ls-git
			  popup
			  ;; rainbow
			  rainbow-delimiters
                          ;; git
                          magit
			  ;; markdown
                          markdown-mode
                          web-mode
			  ;; yaml
                          yaml-mode)
  "Default packages")

;; When Emacs boots, check to make sure all of the packages defined in abedra/packages are installed. If not, have ELPA take care of it.
(defun ling/packages-installed-p ()
  (loop for pkg in ling/packages
        when (not (package-installed-p pkg)) do (return nil)
        finally (return t)))

(unless (ling/packages-installed-p)
  (message "%s" "Refreshing package database...")
  (package-refresh-contents)
  (dolist (pkg ling/packages)
    (when (not (package-installed-p pkg))
      (package-install pkg))))


;; haskell module - Optionals
;; cabal install hasktags stylish-haskell present ghc-mod hlint hoogle structured-haskell-mode

;; skip straight to the scratch buffer.
(setq inhibit-splash-screen t
      initial-scratch-message nil)

;; Turn off the scroll bar, menu bar, and tool bar. There isn't really a reason to have them on.
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

;; Marking text
(delete-selection-mode t)
(transient-mark-mode t)
(setq x-select-enable-clipboard t)

;; Nobody likes to have to type out the full yes or no when Emacs asks. Which it does often. Make it one character.
(defalias 'yes-or-no-p 'y-or-n-p)

;; Miscellaneous key binding stuff that doesn't fit anywhere else.
;; (global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-;") 'comment-or-uncomment-region)
;; (global-set-key (kbd "M-/") 'hippie-expand)
;; (global-set-key (kbd "C-+") 'text-scale-increase)
;; (global-set-key (kbd "C--") 'text-scale-decrease)
;; (global-set-key (kbd "C-c C-k") 'compile)
(global-set-key (kbd "C-x g") 'magit-status)

;; Temporary file management
(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;; auto-pair
(require 'autopair)

;; Turn on auto complete.
(require 'auto-complete-config)
(ac-config-default)

;; This re-indents, untabifies, and cleans up whitespace. 
(defun untabify-buffer ()
  (interactive)
  (untabify (point-min) (point-max)))

(defun indent-buffer ()
  (interactive)
  (indent-region (point-min) (point-max)))

(defun cleanup-buffer ()
  "Perform a bunch of operations on the whitespace content of a buffer."
  (interactive)
  (indent-buffer)
  (untabify-buffer)
  (delete-trailing-whitespace))

(defun cleanup-region (beg end)
  "Remove tmux artifacts from region."
  (interactive "r")
  (dolist (re '("\\\\│\·*\n" "\W*│\·*"))
    (replace-regexp re "" nil beg end)))

(global-set-key (kbd "C-x M-t") 'cleanup-region)
(global-set-key (kbd "C-c n") 'cleanup-buffer)

;; The built-in Emacs spell checker. Turn off the welcome flag because it is annoying and breaks on quite a few systems. Specify the location of the spell check program so it loads properly.
(setq flyspell-issue-welcome-flag nil)
(if (eq system-type 'darwin)
    (setq-default ispell-program-name "/usr/local/bin/aspell")
  (setq-default ispell-program-name "/usr/bin/aspell"))
(setq-default ispell-list-command "list")

;; Web-mode
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.js?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.css?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.xml?\\'" . web-mode))

;; Yaml Mode
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))

;; MarkDown Mode
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.mdown$" . markdown-mode))
(add-hook 'markdown-mode-hook
          (lambda ()
            (visual-line-mode t)
            (writegood-mode t)
            (flyspell-mode t)))
(setq markdown-command "pandoc --smart -f markdown -t html")


;; Haskell Mode
(setq-default indicate-empty-lines t)
(when (not indicate-empty-lines)
  (toggle-indicate-empty-lines))



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;Inf haskell
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)

(custom-set-variables
  '(haskell-process-suggest-remove-import-lines t)
  '(haskell-process-auto-import-loaded-modules t)
  '(haskell-process-log t))

(custom-set-variables
  '(haskell-process-type 'cabal-repl))

(custom-set-variables
  '(haskell-tags-on-save t))

(define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-or-reload)
(define-key haskell-mode-map (kbd "C-`") 'haskell-interactive-bring)
(define-key haskell-mode-map (kbd "C-c C-t") 'haskell-process-do-type)
(define-key haskell-mode-map (kbd "C-c C-i") 'haskell-process-do-info)
(define-key haskell-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
(define-key haskell-mode-map (kbd "C-c C-k") 'haskell-interactive-mode-clear)
(define-key haskell-mode-map (kbd "C-c c") 'haskell-process-cabal)
(define-key haskell-mode-map (kbd "SPC") 'haskell-mode-contextual-space)


;; Helm
(setq initial-scratch-message (concat initial-scratch-message
";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n\
;; This Emacs is Powered by \`HELM' using\n\
;; emacs program \"$EMACS\".\n\
;; This is a minimal \`helm' configuration to discover \`helm' or debug it.\n\
;; You can retrieve this minimal configuration in \"$TMP\" \n\
;; Some originals emacs commands have been replaced by own \`helm' commands:\n\n\
;; - \`find-file'(C-x C-f)           =>\`helm-find-files'\n\
;; - \`occur'(M-s o)                 =>\`helm-occur'\n\
;; - \`list-buffers'(C-x C-b)        =>\`helm-buffers-list'\n\
;; - \`completion-at-point'(M-tab)   =>\`helm-lisp-completion-at-point'[1]\n\
;; - \`dabbrev-expand'(M-/)          =>\`helm-dabbrev'\n\n\
;; Some others native emacs commands are \"helmized\" by \`helm-mode'.\n\
;; [1] Coming with emacs-24.4 \`completion-at-point' is \"helmized\" by \`helm-mode'\n\
;; which provide helm completion in many other places like \`shell-mode'.\n\
;; You will find embeded help for most helm commands with \`C-c ?'.\n\
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n\n"))

(setq default-frame-alist '((vertical-scroll-bars . nil)
                            (tool-bar-lines . 0)
                            (menu-bar-lines . 1)
                            (fullscreen . nil)))
(blink-cursor-mode -1)
(add-to-list 'load-path (expand-file-name "$LOADPATH"))
(require 'helm-config)
(helm-mode 1)
(define-key global-map [remap find-file] 'helm-find-files)
(define-key global-map [remap occur] 'helm-occur)
(define-key global-map [remap list-buffers] 'helm-buffers-list)
(define-key global-map [remap dabbrev-expand] 'helm-dabbrev)
(unless (boundp 'completion-in-region-function)
  (define-key lisp-interaction-mode-map [remap completion-at-point] 'helm-lisp-completion-at-point)
  (define-key emacs-lisp-mode-map       [remap completion-at-point] 'helm-lisp-completion-at-point))
(add-hook 'kill-emacs-hook #'(lambda () (and (file-exists-p "$TMP") (delete-file "$TMP"))))

(require 'helm-ls-git)
(global-set-key (kbd "C-x C-u") 'helm-ls-git-ls)
(global-set-key (kbd "C-x C-i") 'helm-git-grep)

;; Cabal Path
(setenv "PATH" (concat "~/.cabal/bin:" (getenv "PATH")))
(add-to-list 'exec-path "~/.cabal/bin")

;; ghc mod
(autoload 'ghc-init "ghc" nil t)
(autoload 'ghc-debug "ghc" nil t)
(add-hook 'haskell-mode-hook (lambda () (ghc-init)))

;; ghc-company
(require 'company)
(add-hook 'haskell-mode-hook 'company-mode)

(add-to-list 'company-backends 'company-ghc)
(custom-set-variables '(company-ghc-show-info t))

;; Structured-haskell mode
;; (require 'shm)
;; (add-hook 'haskell-mode-hook 'structured-haskell-mode)

;; Basic Indentation mode
(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

;; Rainbow Delimiters
(require 'rainbow-delimiters)
(global-rainbow-delimiters-mode)

;; haskell stylish mode
(setq haskell-stylish-on-save t)

;; Themes
;; Dark-laptop
(require 'color-theme)
(color-theme-initialize)
(color-theme-dark-laptop)

;; Terminal Theme
(if window-system
    ()
  (load-theme 'wombat t))

;; Full Screen Setting
(custom-set-variables
 '(initial-frame-alist (quote ((fullscreen . maximized)))))

;; ERC Setting
(require 'erc)

(setq erc-user-full-name "Lingpo Huang"
      erc-part-reason-various-alist '(("^$" "Leaving"))
      erc-quit-reason-various-alist '(("^$" "Leaving"))
      erc-quit-reason 'erc-part-reason-various
      erc-part-reason 'erc-quit-reason-various)

(add-hook 'erc-mode-hook (lambda () (auto-fill-mode 0)))
(add-hook 'erc-insert-post-hook 'erc-save-buffer-in-logs)

;; Track channel activity in mode-line
(require 'erc-track)
(erc-track-mode t)
(setq erc-track-exclude-types '("JOIN" "NICK" "PART" "QUIT" "MODE"
                                "324" "329" "332" "333" "353" "477"))
(setq erc-hide-list '("JOIN" "PART" "QUIT" "NICK")) ;; stuff to hide!

;;;; Note: erc-join is not needed with ircrelay
(require 'erc-join)
(erc-autojoin-mode t)
(setq erc-autojoin-channels-alist
       '((".*\\.freenode." "#haskell" "#plowtech")
         (".*\\ircrelay.com")
         )
       )

;; Highlight some keywords
(require 'erc-match)
(setq erc-keywords '("keywords" "to" "highlight" "username"))

;; enable an input history
(require 'erc-ring)
(erc-ring-mode t)

;; wrap long lines
(require 'erc-fill)
(erc-fill-mode t)

;; detect netsplits
(require 'erc-netsplit)
(erc-netsplit-mode t)

;; spellcheck, requires local aspell
(erc-spelling-mode t)

;; Truncate buffers so they don't hog core
(setq erc-max-buffer-size 40000) ;; chars to keep in buffer
(defvar erc-insert-post-hook)
(add-hook 'erc-insert-post-hook 'erc-truncate-buffer)
(setq erc-truncate-buffer-on-save t)

;; kill buffers when leaving
(setq erc-kill-buffer-on-part t)

;; keep input at bottom
(erc-scrolltobottom-mode t)

;; flymake
(require 'flymake-hlint) ;; not needed if installed via package
(add-hook 'haskell-mode-hook 'flymake-hlint-load)
(require 'flymake-easy)





