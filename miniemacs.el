;;; --- Configuración inicial ---
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Asegurar que use-package esté instalado
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)



;; linux
;; (use-package exec-path-from-shell
;;   :ensure t
;;   :config
;;   ;; Define aquí las variables adicionales que necesites copiar
;;   (dolist (var '("SSH_AUTH_SOCK" "SSH_AGENT_PID" "GPG_AGENT_INFO" "LANG" "LC_CTYPE"))
;;     (add-to-list 'exec-path-from-shell-variables var))
  ;; Inicializa el paquete solo si estás en entorno gráfico o en un daemon
  ;; (when (or (daemonp) (memq window-system '(mac ns x)))
  ;;   (exec-path-from-shell-initialize)))
;; linux


;; esto capaz va en windows
;; (when (eq system-type 'windows-nt)
;;   ;; Agregar carpetas al PATH interno de Emacs
;;   (add-to-list 'exec-path "C:/Program Files/Git/bin")
;;   (add-to-list 'exec-path "C:/tools/bin")
;;   ;; Sincronizar con la variable PATH del sistema operativo
;;   (setenv "PATH" (concat "C:\\Program Files\\Git\\bin;"
;;                          "C:\\tools\\bin;"
;;                          (getenv "PATH"))))
;; esto capaz va en windows



;;; --- ESTETICA INICIO ---

(use-package doom-themes
  :ensure t)



(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(menu-bar-mode -1)      ; Quita la barra de menú superior
(tool-bar-mode -1)      ; Quita la barra de iconos
(scroll-bar-mode -1)    ; Quita la barra de desplazamiento lateral
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode t)

(setq scroll-margin 6)
(setq scroll-conservatively 100)
(electric-pair-mode 1)

(setq vc-handled-backends '())


;; Configuración global para usar 4 espacios
(setq-default indent-tabs-mode nil) ; No usar caracteres de tabulación
(setq-default tab-width 4)          ; Definir el ancho de la tabulación
(setq-default c-basic-offset 4)     ; Indentación 4 slots
(setq-default python-indent-offset 4); Para Python

(setq-default truncate-lines t) ;; wrap


;;; ---- EVIL MODE inicio ---

(defun mi-copiar-path-con-cd ()
  "Copia la ruta del buffer actual al kill-ring precedida de 'cd '."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (if filename
        (let* ((dir (file-name-directory filename))
               (cd-path (concat "cd " (shell-quote-argument dir))))
          (kill-new cd-path)
          (message "Copiado: %s" cd-path))
      (message "Este buffer no está asociado a ningún archivo."))))


(setq evil-want-keybinding nil)
(use-package evil
  :init (evil-mode 1)
  :config
)

(use-package evil-leader
  :config
  (global-evil-leader-mode)
  (evil-leader/set-leader "SPC")
  (evil-leader/set-key
    ;; "ff" 'find-file
    ;;"f f"'ee-find
    ;;"f g"'grep-find
    ;; "f b"  (lambda() (interactive) (list-buffers)(delete-window))
     "f b"  'ibuffer
    "k"  'kill-buffer
    "w"  'save-buffer
    "m"  (lambda() (interactive) (math-preview-all)(org-display-inline-images))
    ","  (lambda() (interactive) (math-preview-clear-all)(org-remove-inline-images))


    ;; RANDOMIZER DE SKELETONS
    ;; "d" (lambda () 
    ;;     (interactive)
    ;;     (setq dashboard-startup-banner (my/dashboard-random-skeleton))
    ;;     (dashboard-refresh-buffer))
    ;; RANDOMIZER DE SKELETONS

    "d"  'dashboard-open
    ;;"e"  'dirvish
    ;;"e"   'ee-yazi
    "e"   'dired-jump
    "o c"  'calendar
    "c a"  'calc
    "g t"  'my-open-todo
    "b"  'switch-to-buffer
    "i"  'org-download-clipboard
    "g l"  'ee-lazygit

    ;;"SPC"  'org-toggle-checkbox
    "SPC"  'counsel-M-x

    "TAB"  'org-fold-hide-subtree
    "c d"  'mi-copiar-path-con-cd

    "h"  'counsel-esh-history
    "f g" 'counsel-rg
    "f f" 'counsel-fzf ;quiero probar un poco en vez de ee-find para ver que tan rapido es este, parece ir bien
    "f F" 'ee-find
    "c t" 'cambiar-tema
    "c f" 'counsel-fonts

    "f c" 'mi-counsel-fzf-config
    "v d" 'ee-visidata

    "p" 'find-file
    "f a" 'mi-counsel-fzf-all
    "f d" 'mi-counsel-fzf-dirs

    "s" (lambda (buffer)
                        (interactive "bBuffer: ")
                        (split-window-vertically)
                        (other-window 1)
                        (switch-to-buffer buffer))
    ;;"P" 'dired-preview-global-mode
  ))

(use-package evil-escape
  :config
  (setq-default evil-escape-key-sequence "jk")
  (evil-escape-mode 1))

(defun toggle-eshell ()
  "Alterna entre el buffer actual y Eshell."
  (interactive)
  (if (string= (buffer-name) "*eshell*")
      (switch-to-buffer (other-buffer (current-buffer) t))
    (eshell)))

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1)
  )
(use-package avy
  :ensure t
  :bind
  ;; 's' estilo flash (pides 1 o 2 caracteres y salta)
  (:map evil-normal-state-map
        ("s" . avy-goto-char-timer)
        ("S" . avy-goto-line))
  (:map evil-visual-state-map
        ("s" . avy-goto-char-timer)
        ("S" . avy-goto-line))
  (:map evil-operator-state-map
        ("s" . avy-goto-char-timer))
  :config
  ;; Hace que busque en todas las ventanas visibles de la pantalla (estilo Flash)
  (setq avy-all-windows t)
  ;; Muestra las letras/etiquetas al instante
  (setq avy-timeout-seconds 0.1)
  ;; Usar letras de la fila central del teclado para los saltos
  (setq avy-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

(defun my/accept-and-delete-other-windows ()
  "Acepta la selección actual del minibuffer y maximiza la ventana."
  (interactive)
  (if (active-minibuffer-window)
      (progn
        (exit-minibuffer)
        ;; Pequeño delay para permitir que Emacs cambie de buffer antes de borrar ventanas
        (run-at-time 0 nil #'delete-other-windows))
    (delete-other-windows)))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init)

  (evil-define-key 'normal 'global (kbd "J") (lambda () (interactive) (evil-next-line 6)))
  (evil-define-key 'normal 'global (kbd "K") (lambda () (interactive) (evil-previous-line 6)))

  (evil-define-key 'visual 'global (kbd "J") (lambda () (interactive) (evil-next-visual-line 6)))
  (evil-define-key 'visual 'global (kbd "K") (lambda () (interactive) (evil-previous-visual-line 6)))

  (evil-define-key 'normal 'global (kbd "M") 'other-window)
  
  ;;(evil-define-key 'normal 'global (kbd "C-f") 'delete-other-windows)
  (evil-define-key 'normal 'global (kbd "C-f") 'my/accept-and-delete-other-windows)
  ;; esto de abajo no esta mal eh, t de this o sino ponerlo en la terminal
  ;; (evil-define-key 'normal 'global (kbd "t") 'my/accept-and-delete-other-windows)

  ;; (evil-define-key 'normal 'global (kbd "TAB") 'previous-buffer)
  (evil-define-key 'normal 'global (kbd "TAB") (lambda () (interactive) (switch-to-buffer nil)))
  (evil-define-key 'normal 'global (kbd "/") 'swiper)

  (evil-define-key '(normal insert)'global (kbd "M-t") (lambda () (interactive) (toggle-eshell)))



  (evil-define-motion my-next-visual-line-6 (count)
    "Baja 6 líneas visuales."
    :type line
    (interactive "<c>")
    (evil-next-visual-line (or count 6)))

  (evil-define-motion my-prev-visual-line-6 (count)
    "Sube 6 líneas visuales."
    :type line
    (interactive "<c>")
    (evil-previous-visual-line (or count 6)))

  (evil-define-key '(normal visual motion) 'global
    "J" 'my-next-visual-line-6
    "K" 'my-prev-visual-line-6)


  (evil-define-key 'visual evil-surround-mode-map "Z" 'evil-surround-region)
  (evil-define-key 'visual evil-surround-mode-map "S" nil)

  ;; (evil-define-key 'normal evil-surround-mode-map "zc" 'evil-surround-change) es medio una pija esto
  ;; (evil-define-key 'normal evil-surround-mode-map "cs" nil)



  ;; este es un buen combo
  ;; este es un buen combo
  (defun my-compile-history ()
    (interactive)
    (ivy-read "Compile command: "
              (delete-dups compile-history)
              :action (lambda (cmd)
                        (compile cmd))))

  (evil-define-key 'normal 'global (kbd "T") #'my-compile-history)

  (evil-define-key 'normal 'global (kbd "t") 'compile)


  (evil-define-key 'normal 'global (kbd "C-n")
    (lambda ()
      (interactive)
      (when (= (count-windows) 2)
        (other-window 1)
        (forward-line 1)
        (condition-case nil
            (execute-kbd-macro (kbd "RET"))
          (error
           (other-window -1))))))


  (evil-define-key 'normal 'global (kbd "C-p")
    (lambda ()
      (interactive)
      (when (= (count-windows) 2)
        (other-window 1)
        (forward-line -1)
        (condition-case nil
            (execute-kbd-macro (kbd "RET"))
          (error
           (other-window -1))))))
  ;; este es un buen combo
  ;; este es un buen combo
  ;; igual parece ser mejor usar ivy y simplemente usar M para ir switcheando, pero si grepeas esta opcion no esta mal
  ;; y si queres ir en dired a files mp4 o algo asi podes usar ivy y luego dar enter y n n n n n n n n 


  )

;; Evitar que evil-escape actúe dentro de ibuffer
(with-eval-after-load 'evil-escape
  (add-to-list 'evil-escape-inhibit-functions
               (lambda () (derived-mode-p 'ibuffer-mode))))

;;; ---- EVIL MODE end ---



; --- DASHBOARD INICIO---

;; (with-eval-after-load 'ibuffer
;;   (dolist (regexp '("\\*dashboard\\*"
;;                     "\\*Messages\\*"
;;                     "\\*Compile-Log\\*"))
;;     (add-to-list 'ibuffer-never-show-predicates regexp)))
;; ta medio bug esto 
;; ta medio bug esto 

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)

  (setq dashboard-footer-messages '(
"good morning"
))

  (setq default-directory "~/")

  (setq dashboard-items '(
                          
                          ))
  ;; Configuración visual
  ;;(setq dashboard-startup-banner 'logo) ;; Puedes usar 'logo, 'official, o el path a una imagen
  ;;(setq dashboard-items '((recents  . 5)
                          ;; (projects . 5)
                          ;; (bookmarks . 5)))
  ;; Para que los iconos se vean bien (requiere all-the-icons)
  (setq dashboard-display-icons-p t)
  (setq dashboard-icon-type 'nerd-icons) ;; Asegúrate de tener instalado nerd-icons
  ; Ocultar barra de herramientas/menú si el dashboard está activo
  (setq dashboard-center-content t)
  (setq dashboard-vertically-center-content t)
  )


; --- DASHBOARD END ----



;; ; -- DIRED INICIO --- 



(setq dired-recursive-copies 'always)
(setq dired-recursive-deletes 'always)

(setq delete-by-moving-to-trash t)

(use-package dired-x
  :ensure nil
  :config
  (setq dired-omit-files (concat dired-omit-files "\\|^\\..+$"))
  )

(use-package dired-ranger
  :ensure t
         )

(with-eval-after-load 'dired
  (setq dired-listing-switches "-alh --group-directories-first")
  (evil-define-key 'normal dired-mode-map

    (kbd "q") 'kill-current-buffer

    (kbd "h") 'dired-up-directory

    (kbd "l") 'dired-find-alternate-file
    (kbd "o") 'dired-find-alternate-file

    (kbd "J") (lambda () (interactive) (dired-next-line 5))
    (kbd "K") (lambda () (interactive) (dired-previous-line 5))
    (kbd ".") 'dired-omit-mode
    (kbd "W") 'wdired-change-to-wdired-mode


    (kbd "M") 'other-window

    (kbd "Y") 'dired-do-copy
    (kbd "y") 'dired-ranger-copy
    (kbd "X") 'dired-ranger-move
    (kbd "p") 'dired-ranger-paste

    (kbd "t") 'compile

    (kbd "P") 'media-thumbnail-dired-mode

    (kbd "I") (lambda () 
                (interactive) 
                (image-dired default-directory))

    (kbd "c") nil
    (kbd "c a") 'my/dired-copy-files-as-uri-list

    (kbd "a") 'find-file
    )
  )

(add-hook 'dired-mode-hook
          (lambda ()
            (dired-omit-mode 1)
	    ;; (dired-hide-details-mode)
	    )) 

(setq dired-kill-when-opening-new-dired-buffer t)

(evil-define-key 'normal wdired-mode-map
    (kbd "W") 'wdired-finish-edit    ; Guarda los cambios y sale de wdired
    (kbd "Q") 'wdired-abort-changes)  ; Descarta los cambios y sale de wdired


(add-hook 'dired-mode-hook #'hl-line-mode)


;; ; -- DIRED FINAL --- 


;; ---- PDF ------------
(use-package pdf-tools
  :ensure t
  :mode ("\\.pdf\\'" . pdf-view-mode) ; Que todos los PDF abran con esto
  :config
  ;; Inicializa el servidor de poppler
  (pdf-tools-install)

  ;; Comportamiento por defecto
  (setq-default pdf-view-display-size 'fit-page)
  (setq pdf-view-resize-factor 1.1)

  (add-hook 'pdf-view-mode-hook
            (lambda ()
              (pdf-view-midnight-minor-mode 1) 
              (display-line-numbers-mode -1)   
              (blink-cursor-mode -1)           
              (auto-revert-mode 1)))           


  (with-eval-after-load 'evil
    (evil-define-key 'normal pdf-view-mode-map
      ;; Navegación básica suave (1 línea)
      "h" 'pdf-view-scroll-left
      "l" 'pdf-view-scroll-right
      
      ;; Navegación rápida (6 líneas)
      "j" (lambda () (interactive) (pdf-view-next-line-or-next-page 4))
      "k" (lambda () (interactive) (pdf-view-previous-line-or-previous-page 4))

      "J" (lambda () (interactive) (pdf-view-next-line-or-next-page 10))
      "K" (lambda () (interactive) (pdf-view-previous-line-or-previous-page 10))

      "d" (lambda () (interactive) (pdf-view-next-line-or-next-page 20))
      "u" (lambda () (interactive) (pdf-view-previous-line-or-previous-page 20))
      
      ;; Saltos de página
      (kbd "C-f") 'pdf-view-next-page
      (kbd "C-b") 'pdf-view-previous-page
      (kbd "g g") 'pdf-view-first-page

      (kbd "D") 'pdf-view-next-page
      (kbd "U") 'pdf-view-previous-page

      "G" 'pdf-view-last-page

      (kbd "g p") 'pdf-view-goto-page

      ;; Zoom y Ajustes
      "a" 'pdf-view-fit-page-to-window
      "s" 'pdf-view-fit-width-to-window
      "+" 'pdf-view-enlarge
      "=" 'pdf-view-enlarge
      "-" 'pdf-view-shrink
      "0" 'pdf-view-scale-reset


      ;; Utilidades de Zathura
      "i" 'pdf-view-midnight-minor-mode  ; Toggle para invertir colores
      "r" 'pdf-view-revert-buffer        ; Forzar recarga
      "/" 'isearch-forward
      "n" 'isearch-repeat-forward
      "N" 'isearch-repeat-backward
      "i" 'pdf-view-midnight-minor-mode  ; Toggle para invertir colores
      )
    )
)            ; Búsqueda de texto incremental
;; ---- PDF END------------




;; -------------------LSP---------------------
;; Habilitar Corfu globalmente
(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)                  ;; Autocompletado mientras escribes
  (corfu-auto-prefix 2)           ;; Mostrar sugerencias a partir de 2 letras
  (corfu-auto-delay 0.01) ;; <--- Ponlo en 0.0 para respuesta inmediata
  (corfu-echo-delay 0.01) ;; <--- Elimina el delay del texto de ayuda
  :init
  (global-corfu-mode 1))

;; Eglot viene incluido en Emacs 29 o superior
(use-package eglot
:hook ((c++-mode . eglot-ensure)
       (python-mode . eglot-ensure)
       )
  :config
  )

(with-eval-after-load 'eglot
  (evil-define-key 'normal eglot-mode-map (kbd "K") (lambda () (interactive) (evil-previous-line 6))))

(setq eldoc-idle-delay 6) ; Retrasa la consulta de eldoc (por defecto es muy bajo)
(setq eldoc-echo-area-use-multiline-p nil)
(setq eglot-autoshutdown t)           ; Apagar el servidor cuando no se use el archivo

(setq lsp-ui-doc-enable nil)
(setq lsp-ui-doc-show-with-cursor nil)
(setq lsp-ui-doc-show-with-mouse nil)
(setq lsp-headerline-breadcrumb-enable nil)
(setq eldoc-echo-area-use-multiline-p nil)


;- python enviroment
(use-package pyvenv
  :ensure t
  :config
  (pyvenv-mode 1))
;- python enviroment (tenes que indicar el .venv especificamente sino no funciona el pyvenv-activate)
(with-eval-after-load 'pyvenv
  (add-hook 'pyvenv-post-activate-hooks
            (lambda ()
              ;; Cuando activas un venv, reiniciamos eglot 
              ;; para que reconozca el nuevo entorno
              (when (eglot-managed-p)
                (eglot-reconnect (eglot-current-server))))))

;; # Crear el entorno
;; ```
;; python3 -m venv .venv
;; ```
;; # Activar el entorno
;; ```
;; source .venv/bin/activate
;; ```
;; # Librerias
;; ```
;; pip install --upgrade pip
;; pip install magpylib numpy pandas matplotlib scipy
;; ```

;; -------------------LSP END---------------------


;; -------------------  ESHELL  ---------------------
(with-eval-after-load 'evil
  (add-hook 'eshell-mode-hook
            (lambda ()
              (evil-define-key 'insert eshell-mode-map (kbd "RET") 'eshell-send-input)
            )
  )
)
(add-hook 'eshell-mode-hook
          (lambda ()
            (compilation-shell-minor-mode 1)))

(setq eshell-prompt-function
      (lambda ()
        (concat
         ;; Muestra el path actual en una línea
         "\n"
         (abbreviate-file-name (eshell/pwd))
         ;; Añade un salto de línea y el símbolo del prompt
         " $ \n")))



;; -------------------  ESHELL  END ---------------------



;============IVY================

;;(setq evil-want-minibuffer t) ver capaz esot q onda

(use-package ivy
  :ensure t
  :diminish
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (setq ivy-initial-inputs-alist nil)
  )

(use-package counsel
  :ensure t
  :after ivy
  :config
  (counsel-mode 1))

(use-package swiper
  :ensure t
  :after (ivy evil)
  :bind (
         ("C-s" . swiper)
         )
  :config
  (defun mi-swiper-corregir-direccion (&rest _)
    "Fuerza a que la búsqueda posterior a Swiper sea hacia adelante."
    (setq isearch-forward t))
  (advice-add 'swiper :after #'mi-swiper-corregir-direccion))

(use-package ivy-rich
  :ensure t
  :after ivy
  :config
  (ivy-rich-mode 1))

(with-eval-after-load 'ivy
  (define-key ivy-minibuffer-map (kbd "C-j") 'ivy-next-line)
  (define-key ivy-minibuffer-map (kbd "C-k") 'ivy-previous-line)
  (define-key ivy-switch-buffer-map (kbd "C-j") 'ivy-next-line)
  (define-key ivy-switch-buffer-map (kbd "C-k") 'ivy-previous-line)
  (define-key ivy-reverse-i-search-map (kbd "C-k") 'ivy-previous-line)
  (define-key ivy-reverse-i-search-map (kbd "C-k") 'ivy-previous-line)
  (define-key ivy-reverse-i-search-map (kbd "C-l") 'ivy-done)
  (define-key ivy-switch-buffer-map (kbd "C-l") 'ivy-done)
  (define-key ivy-minibuffer-map (kbd "C-l") 'ivy-done)
  ;; no uso esto uso los de abajo pero los C-k killean bufers de ivy asi que mejor tenerlo


  (define-key ivy-minibuffer-map (kbd "J") 'ivy-next-line)
  (define-key ivy-minibuffer-map (kbd "K") 'ivy-previous-line)
  (define-key ivy-switch-buffer-map (kbd "J") 'ivy-next-line)
  (define-key ivy-switch-buffer-map (kbd "K") 'ivy-previous-line)
  (define-key ivy-reverse-i-search-map (kbd "K") 'ivy-previous-line)
  (define-key ivy-reverse-i-search-map (kbd "K") 'ivy-previous-line)
  (define-key ivy-reverse-i-search-map (kbd "RET") 'ivy-done)
  (define-key ivy-switch-buffer-map (kbd "RET") 'ivy-done)
  (define-key ivy-minibuffer-map (kbd "RET") 'ivy-done)
  (define-key ivy-reverse-i-search-map (kbd "L") 'ivy-done)
  (define-key ivy-switch-buffer-map (kbd "L") 'ivy-done)
  (define-key ivy-minibuffer-map (kbd "L") 'ivy-done)
  (define-key ivy-reverse-i-search-map (kbd "M")'other-window )
  (define-key ivy-switch-buffer-map (kbd "M")'other-window )
  (define-key ivy-minibuffer-map (kbd "M")'other-window )


  )

(setq ivy-re-builders-alist
      '((t . ivy--regex-ignore-order)))




;============IVY================

;; ====================BARRA DE ESTADO==================

(use-package nerd-icons
)

(use-package mood-line
  :config
  (mood-line-mode)
  :custom
  (mood-line-glyph-alist mood-line-glyphs-fira-code)
  )

(defun my/shrink-path (file-path)
  "Trunca carpetas intermedias a 1 letra, pero mantiene la carpeta padre y el archivo completos."
  (if (or (null file-path) (string-empty-p file-path))
      ""
    (let* ((proj (when (fboundp 'project-current) (project-current)))
           (root (when proj (expand-file-name (project-root proj))))
           (rel-path (if root
                         (file-relative-name file-path root)
                       (abbreviate-file-name file-path)))
           (parts (split-string rel-path "/" t)))
      (cond
       ((<= (length parts) 2) rel-path) ; Si hay 1 o 2 elementos, mostrar tal cual
       (t
        (let* ((filename (car (last parts)))
               (parent-dir (nth (- (length parts) 2) parts))
               (leading-dirs (butlast parts 2))
               (truncated-leading
                (mapconcat (lambda (dir)
                             (if (string-prefix-p "." dir)
                                 (substring dir 0 (min 2 (length dir)))
                               (substring dir 0 1)))
                           leading-dirs "/")))
          (concat truncated-leading "/" parent-dir "/" filename)))))))

(defun my/macro-recording-status ()
  "Devuelve un indicador visual si se está grabando una macro de Emacs o Evil."
  (cond
   (defining-kbd-macro " --[REC MACRO]--")
   (t "")))

(setq mood-line-format
      (mood-line-defformat
       :left
       (
        ((let* ((has-file (buffer-file-name))
                (path (cond
                       ;; 1. Archivo físico en disco
                       (has-file 
                        (my/shrink-path has-file))
                       ;; 2. Eshell, Dired o carpetas
                       (default-directory 
                        (concat "" (my/shrink-path default-directory) ""))
                       ;; 3. Dashboard o buffers especiales
                       (t (buffer-name)))))
           ;; Solo pintar de naranja si TIENE archivo Y está modificado
           (if (and has-file (buffer-modified-p))
               (propertize path 'face '(:foreground "orange" :weight bold))
             path)) . "")
        ((my/macro-recording-status) . " "))
       :right
       (
        (format-time-string "  %I:%M %p "))))

;; ====================BARRA DE ESTADO=================



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(media-thumbnail avy evil-surround mood-line year-1984-theme dired-ranger ivy-prescient nerd-icons ivy-rich counsel ivy wolfram pyvenv doom-themes image-mode org-download yasnippets calfw-component evil-leader evil-escape dirvish))
 '(warning-suppress-types '((comp))))



