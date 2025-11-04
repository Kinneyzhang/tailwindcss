;;; advanced-config.el --- Advanced TailwindCSS Emacs configuration example -*- lexical-binding: t; -*-

;; This file provides an advanced configuration example with integration
;; of other popular Emacs packages.

;;; Commentary:

;; This configuration shows how to integrate TailwindCSS with:
;; - use-package
;; - Company mode
;; - LSP mode
;; - web-mode
;; - flycheck

;;; Code:

;; ===== use-package Configuration =====

(use-package tailwindcss
  :load-path "~/.emacs.d/lisp/tailwindcss"
  
  ;; Auto-enable in these modes
  :hook ((html-mode . tailwindcss-mode)
         (web-mode . tailwindcss-mode)
         (js-mode . tailwindcss-mode)
         (js-jsx-mode . tailwindcss-mode)
         (typescript-mode . tailwindcss-mode)
         (tsx-ts-mode . tailwindcss-mode)
         (vue-mode . tailwindcss-mode))
  
  ;; Key bindings
  :bind (:map tailwindcss-mode-map
              ("C-c C-t b" . tailwindcss-build)
              ("C-c C-t i" . tailwindcss-init)
              ("C-c C-t l" . tailwindcss-list-classes)
              ("C-c C-t v" . tailwindcss-validate-buffer)
              ("C-c C-t s" . tailwindcss-sort-classes-in-region)
              ("C-c C-t o" . tailwindcss-open-config)
              ("C-c C-t c" . tailwindcss-insert-utility-class))
  
  ;; Configuration
  :config
  (setq tailwindcss-enable-class-completion t)
  (setq tailwindcss-cli-path "npx tailwindcss")
  
  ;; Add custom utilities if needed
  (setq tailwindcss-utilities-list
        (append tailwindcss-utilities-list
                '("custom-class" "another-custom")))
  
  ;; Add custom colors
  (setq tailwindcss-colors-list
        (append tailwindcss-colors-list
                '("brand-primary" "brand-secondary"))))

;; ===== Company Mode Integration =====

(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :config
  ;; Optimize for TailwindCSS
  (setq company-minimum-prefix-length 1)
  (setq company-idle-delay 0.1)
  (setq company-tooltip-align-annotations t)
  
  ;; Key bindings
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-active-map (kbd "C-d") 'company-show-doc-buffer))

;; ===== Web Mode Integration =====

(use-package web-mode
  :ensure t
  :mode ("\\.html\\'"
         "\\.jsx\\'"
         "\\.tsx\\'"
         "\\.vue\\'")
  :hook (web-mode . tailwindcss-mode)
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-enable-auto-closing t)
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-enable-current-element-highlight t))

;; ===== LSP Mode Integration =====

(use-package lsp-mode
  :ensure t
  :hook ((html-mode . lsp-deferred)
         (web-mode . lsp-deferred)
         (js-mode . lsp-deferred)
         (typescript-mode . lsp-deferred))
  :commands (lsp lsp-deferred)
  :config
  ;; Enable TailwindCSS language server
  (setq lsp-tailwindcss-add-on-mode t)
  
  ;; Performance tuning
  (setq lsp-idle-delay 0.5)
  (setq lsp-log-io nil)
  
  ;; UI improvements
  (setq lsp-headerline-breadcrumb-enable t)
  (setq lsp-modeline-diagnostics-enable t))

;; ===== LSP UI =====

(use-package lsp-ui
  :ensure t
  :after lsp-mode
  :config
  (setq lsp-ui-doc-enable t)
  (setq lsp-ui-doc-position 'at-point)
  (setq lsp-ui-sideline-enable t)
  (setq lsp-ui-sideline-show-hover t))

;; ===== Flycheck Integration =====

(use-package flycheck
  :ensure t
  :hook (after-init . global-flycheck-mode)
  :config
  ;; Customize checkers if needed
  (setq flycheck-check-syntax-automatically '(save mode-enabled)))

;; ===== Project Management =====

(use-package projectile
  :ensure t
  :config
  (projectile-mode +1)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

;; ===== Snippet Support =====

(use-package yasnippet
  :ensure t
  :hook (prog-mode . yas-minor-mode)
  :config
  (yas-reload-all)
  
  ;; Example TailwindCSS snippet
  (add-to-list 'yas-snippet-dirs "~/.emacs.d/snippets"))

;; ===== Custom Functions =====

;; Function to quickly insert common TailwindCSS patterns
(defun my-tailwind-insert-flex-center ()
  "Insert a flex container with center alignment."
  (interactive)
  (insert "flex items-center justify-center"))

(defun my-tailwind-insert-responsive-text ()
  "Insert responsive text classes."
  (interactive)
  (insert "text-sm md:text-base lg:text-lg"))

;; Bind custom functions
(with-eval-after-load 'tailwindcss
  (define-key tailwindcss-mode-map (kbd "C-c C-t f") 'my-tailwind-insert-flex-center)
  (define-key tailwindcss-mode-map (kbd "C-c C-t r") 'my-tailwind-insert-responsive-text))

;; ===== Hydra for Quick Access =====

(use-package hydra
  :ensure t
  :config
  (defhydra hydra-tailwindcss (:color blue :hint nil)
    "
TailwindCSS Commands
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
_b_: Build       _l_: List classes    _f_: Flex center
_i_: Init        _v_: Validate        _r_: Responsive text
_s_: Sort        _o_: Open config     _c_: Insert class
_q_: Quit
"
    ("b" tailwindcss-build)
    ("i" tailwindcss-init)
    ("l" tailwindcss-list-classes)
    ("v" tailwindcss-validate-buffer)
    ("s" tailwindcss-sort-classes-in-region)
    ("o" tailwindcss-open-config)
    ("c" tailwindcss-insert-utility-class)
    ("f" my-tailwind-insert-flex-center)
    ("r" my-tailwind-insert-responsive-text)
    ("q" nil))
  
  (global-set-key (kbd "C-c t") 'hydra-tailwindcss/body))

;; ===== Directory Local Variables =====

;; Create .dir-locals.el in your project root with content like:
;; ((html-mode . ((tailwindcss-cli-path . "npm run build:css")))
;;  (js-mode . ((eval . (tailwindcss-mode 1)))))

;; ===== Performance Optimizations =====

;; For large projects, consider these optimizations:
(setq gc-cons-threshold (* 100 1024 1024)) ; 100 MB
(setq read-process-output-max (* 1024 1024)) ; 1 MB

;; ===== Additional Utilities =====

;; Auto-format on save (optional)
(defun my-tailwind-format-on-save ()
  "Format TailwindCSS classes on save."
  (when (and (boundp 'tailwindcss-mode) tailwindcss-mode)
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "class\\(?:Name\\)?=[\"']\\([^\"']+\\)[\"']" nil t)
        (let* ((start (match-beginning 1))
               (end (match-end 1))
               (classes (split-string (match-string 1)))
               (sorted (tailwindcss-sort-classes classes)))
          (delete-region start end)
          (goto-char start)
          (insert (tailwindcss-format-class-list sorted)))))))

;; Uncomment to enable auto-format on save
;; (add-hook 'before-save-hook 'my-tailwind-format-on-save)

;;; advanced-config.el ends here
