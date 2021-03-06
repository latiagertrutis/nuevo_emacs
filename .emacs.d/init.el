;;*****************************instalacion de cosas *****************************

(require 'package) ;; You might already have this line
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (url (concat (if no-ssl "http" "https") "://melpa.org/packages/")))
  (add-to-list 'package-archives (cons "melpa" url) t))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

(unless (featurep 'use-package)
  (package-refresh-contents)
  (package-install 'use-package)
  )

(use-package ample-theme
  :defer t
  :ensure t)

(use-package autopair
  :ensure t)

(use-package undo-tree
  :ensure t)

(use-package ws-butler
  :ensure t)

(use-package smart-tabs-mode
  :ensure t)

(use-package rainbow-delimiters
  :ensure t)

(use-package flycheck
  :ensure t)

(use-package magit
  :ensure t)

(use-package iedit
  :ensure t)

(use-package helm
  :ensure t)

(use-package auto-complete
  :ensure t)

(use-package highlight-parentheses
  :ensure t)

(use-package highlight-numbers
  :ensure t)

(use-package color-identifiers-mode
  :ensure t)

(use-package eshell-prompt-extras
  :ensure t)

(use-package helm-swoop
  :ensure t)

(use-package anaconda-mode
  :ensure t)

(use-package jedi
  :ensure t)

(use-package exec-path-from-shell
  :ensure t)

(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 3)
  )

(use-package company-irony
  :ensure t
  :config
  (require 'company)
  (add-to-list 'company-backends 'company-irony)
  )

(use-package irony
  :ensure t
  :config
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
  )

(use-package avy
  :ensure t)
(global-set-key (kbd "C-:") 'avy-goto-char)

;;*****************************configuracion de cosas instaladas*****************************

;;tema
(load-theme 'ample t)

;;autopair
(require 'autopair)
(autopair-global-mode) ;; to enable in all buffers

;;undotree
(require 'undo-tree)
(global-undo-tree-mode)

;;borrar espacios al final
(require 'ws-butler)
(add-hook 'prog-mode-hook 'ws-butler-mode)

;;tabulaciones buenas
(require 'smart-tabs-mode)
(smart-tabs-insinuate 'c 'c++ 'java 'javascript 'cperl 'python 'ruby 'nxml)

;;delimitadorers de colores
(require 'rainbow-delimiters)
(add-hook 'foo-mode-hook #'rainbow-delimiters-mode)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;;flycheck
(global-flycheck-mode)
(add-hook 'after-init-hook #'global-flycheck-mode)
(add-to-list 'display-buffer-alist
             `(,(rx bos "*Flycheck errors*" eos)
			   (display-buffer-reuse-window
				display-buffer-in-side-window)
			   (side            . bottom)
			   (reusable-frames . visible)
			   (window-height   . 0.10)))

;;magit
(require 'magit)
(global-set-key (kbd "C-x g") 'magit-status)

;;renombrar variables
(require 'iedit)

;;helm
(require 'helm-config)
(setq helm-split-window-in-side-p t)
(global-set-key (kbd "C-x b") 'helm-buffers-list)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(define-key helm-map "\t" 'helm-execute-persistent-action)

;;autocompletado
(require 'auto-complete)
(ac-config-default)

;;resaltar parentesis
(require 'highlight-parentheses)
(add-hook 'highlight-parentheses-mode-hook
		  '(lambda ()
             (setq autopair-handle-action-fns
                   (append
					(if autopair-handle-action-fns
						autopair-handle-action-fns
					  '(autopair-default-handle-action))
					'((lambda (action pair pos-before)
						(hl-paren-color-update)))))))
(define-globalized-minor-mode global-highlight-parentheses-mode
  highlight-parentheses-mode
  (lambda ()
    (highlight-parentheses-mode t)))
(global-highlight-parentheses-mode t)

;;resaltar numeros
(require 'highlight-numbers)
(add-hook 'prog-mode-hook 'highlight-numbers-mode)

;;resaltar variables
(require 'color-identifiers-mode)
(add-hook 'after-init-hook 'global-color-identifiers-mode)

;;mejor eshell
(require 'eshell-prompt-extras)

;;helm swoop
(require 'helm-swoop)
(global-set-key (kbd "M-i") 'helm-swoop)
(setq helm-swoop-split-with-multiple-windows t)

;;anaconda-mode
(require 'anaconda-mode)
(add-hook 'python-mode-hook 'anaconda-mode)

;;jedi
(require 'jedi)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)

;;exec-path-from-shell
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;;company
(with-eval-after-load 'company
  (add-hook 'c++-mode-hook 'company-mode)
  (add-hook 'c-mode-hook 'company-mode)
  )

;;****************************************configuracion personal**************************************************

;;indentacion
(setq c-default-style "linux"
	  c-basic-offset 4)

;;cursor barra
(setq-default cursor-type 'bar)

;;hacer que una tabulacion sean 4 espacios
(setq-default tab-width 4)

;;poner una tabulacion con la puta tecla de tab
(defun my-insert-tab-char ()
  "Insert a tab char. (ASCII 9, \t)"
  (interactive)
  (insert "\t"))
(global-set-key (kbd "TAB") 'my-insert-tab-char) ; same as Ctrl+i

;;numero de linea
(add-hook 'prog-mode-hook 'linum-mode)
(add-hook 'text-mode-hook 'linum-mode)

;;copiar linea entera
(defun copy-line (arg)
  "Copy lines (as many as prefix argument) in the kill ring.
      Ease of use features:
      - Move to start of next line.
      - Appends the copy on sequential calls.
      - Use newline as last char even on the last line of the buffer.
      - If region is active, copy its lines."
  (interactive "p")
  (let ((beg (line-beginning-position))
		(end (line-end-position arg)))
	(when mark-active
	  (if (> (point) (mark))
		  (setq beg (save-excursion (goto-char (mark)) (line-beginning-position)))
		(setq end (save-excursion (goto-char (mark)) (line-end-position)))))
	(if (eq last-command 'copy-line)
		(kill-append (buffer-substring beg end) (< end beg))
	  (kill-ring-save beg end)))
  (kill-append "\n" nil)
  (beginning-of-line (or (and arg (1+ arg)) 2))
  (if (and arg (not (= 1 arg))) (message "%d lines copied" arg)))
(global-set-key (kbd "C-c c") 'copy-line)

;;borrar caracter con backspace
(global-set-key [backspace] 'delete-backward-char)

;;moverse al principio y final de linea con home y end
(global-set-key [home] 'move-beginning-of-line)
(global-set-key [end] 'move-end-of-line)

(global-set-key [f5] 'revert-buffer)

;;archivos recientes al inicio
;;(init-open-recentf)
(desktop-save-mode 1)

;;cosas de la 42
;;header
(load "~/.emacs.d/plugins/header/list.el")
(load "~/.emacs.d/plugins/header/string.el")
(load "~/.emacs.d/plugins/header/comments.el")
(load "~/.emacs.d/plugins/header/header.el")

;;multieshell
;;(load "~/.emacs.d/plugins/multi-eshell.el")
(defun eshell-new()
  (interactive)
  (eshell 'N))

;;matar una linea entera
(defun quick-cut-line ()
  "Cut the whole line that point is on.  Consecutive calls to this command append each line to the kill-ring."
  (interactive)
  (let ((beg (line-beginning-position 1))
		(end (line-beginning-position 2)))
    (if (eq last-command 'quick-cut-line)
		(kill-append (buffer-substring beg end) (< end beg))
      (kill-new (buffer-substring beg end)))
    (delete-region beg end))
  (beginning-of-line 1)
  (setq this-command 'quick-cut-line))
(global-set-key (kbd "C-k") 'quick-cut-line)

;;sin toolbar
(tool-bar-mode -1)
(menu-bar-mode -1)

;;marcar una palabra
(defun my-mark-current-word (&optional arg allow-extend)
  "Put point at beginning of current word, set mark at end."
  (interactive "p\np")
  (setq arg (if arg arg 1))
  (if (and allow-extend
           (or (and (eq last-command this-command) (mark t))
               (region-active-p)))
      (set-mark
       (save-excursion
         (when (< (mark) (point))
           (setq arg (- arg)))
         (goto-char (mark))
         (forward-word arg)
         (point)))
    (let ((wbounds (bounds-of-thing-at-point 'word)))
      (unless (consp wbounds)
        (error "No word at point"))
      (if (>= arg 0)
          (goto-char (car wbounds))
        (goto-char (cdr wbounds)))
      (push-mark (save-excursion
                   (forward-word arg)
                   (point)))
      (activate-mark))))
(global-set-key (kbd "C-f") 'my-mark-current-word)

;;para ver columnas
(setq column-number-mode t)

;;font size
(set-face-attribute 'default nil :height 100)

;;indectar todo el buffer
(defun indent-buffer ()
  (interactive)
  (save-excursion
	(indent-region (point-min) (point-max) nil)))
(global-set-key (kbd "C-c i") 'indent-buffer)

;;moverse entre ventanas
(global-set-key (kbd "M-<up>") 'windmove-up)
(global-set-key (kbd "M-<down>") 'windmove-down)
(global-set-key (kbd "M-<left>") 'windmove-left)
(global-set-key (kbd "M-<right>") 'windmove-right)
(global-set-key (kbd "C-M-<up>") 'beginning-of-defun)
(global-set-key (kbd "C-M-<down>") 'end-of-defun)

;;guardar backups en carpeta
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
	  backup-by-copying t    ; Don't delink hardlinks
	  version-control t      ; Use version numbers on backups
	  delete-old-versions t  ; Automatically delete excess backups
	  kept-new-versions 20   ; how many of the newest versions to keep
	  kept-old-versions 5    ; and how many of the old
	  )

;;sin scrollbar
(scroll-bar-mode -1)

;;resaltar linea
(global-hl-line-mode +1)
(set-face-background 'hl-line "#111111")

;;append to path
;;(setenv "PATH" (concat (getenv "PATH") ":" (expand-file-name "/Users/mrodrigu/.brew/bin/")))

;;renombrar un archivo
(defun rename-file-and-buffer ()
  "Rename the current buffer and file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (message "Buffer is not visiting a file!")
      (let ((new-name (read-file-name "New name: " filename)))
        (cond
         ((vc-backend filename) (vc-rename-file filename new-name))
         (t
          (rename-file filename new-name t)
          (set-visited-file-name new-name t t)))))))
(global-set-key (kbd "C-c r")  'rename-file-and-buffer)

;;borrar archivo y buffer
(defun delete-file-and-buffer ()
  "Kill the current buffer and deletes the file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (when filename
      (if (vc-backend filename)
          (vc-delete-file filename)
        (progn
          (delete-file filename)
          (message "Deleted file %s" filename)
          (kill-buffer))))))

;;abrir un archivo en ventana diferente
(defun open-file-new-window ()
  (interactive)
  (split-window-right)
  (other-window 1)
  (helm-find-files nil)
  )
(global-set-key (kbd "C-c f")  'open-file-new-window)

;;updatear todos los buffers no modificados
(defun revert-all-buffers ()
  "Revert all non-modified buffers associated with a file.
This is to update existing buffers after a Git pull of their underlying files."
  (interactive)
  (save-current-buffer
    (mapc (lambda (b)
            (set-buffer b)
            (unless (or (null (buffer-file-name)) (buffer-modified-p))
              (revert-buffer t t)
              (message "Reverted %s\n" (buffer-file-name))))
          (buffer-list))))

(provide 'init)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#504545" "#ad8572" "#a9df90" "#aaca86" "#91a0b3" "#ab85a3" "#afcfef" "#bdbdb3"])
 '(custom-safe-themes
   (quote
	("36ca8f60565af20ef4f30783aa16a26d96c02df7b4e54e9900a5138fb33808da" "c9ddf33b383e74dac7690255dd2c3dfa1961a8e8a1d20e401c6572febef61045" "bf798e9e8ff00d4bf2512597f36e5a135ce48e477ce88a0764cfb5d8104e8163" default)))
 '(flycheck-clang-include-path (quote ("../includes/" "../../includes/")))
 '(flycheck-gcc-include-path (quote ("../includes/")))
 '(package-selected-packages
   (quote
	(ws-butler use-package undo-tree smart-tabs-mode rainbow-delimiters magit jedi iedit highlight-parentheses highlight-numbers helm-swoop flycheck eshell-prompt-extras color-identifiers-mode autopair anaconda-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'narrow-to-region 'disabled nil)
