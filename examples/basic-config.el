;;; basic-config.el --- Basic TailwindCSS Emacs configuration example -*- lexical-binding: t; -*-

;; This file provides a minimal configuration example for using
;; TailwindCSS with Emacs.

;;; Commentary:

;; Copy this configuration to your ~/.emacs or ~/.emacs.d/init.el
;; and adjust paths as needed.

;;; Code:

;; ===== Basic Setup =====

;; Add TailwindCSS package to load path
(add-to-list 'load-path "~/.emacs.d/lisp/tailwindcss")

;; Load the package
(require 'tailwindcss)

;; ===== Enable in Relevant Modes =====

;; Enable TailwindCSS mode in HTML files
(add-hook 'html-mode-hook #'tailwindcss-mode)

;; Enable TailwindCSS mode in web-mode (if you use it)
;; (add-hook 'web-mode-hook #'tailwindcss-mode)

;; Enable TailwindCSS mode in JavaScript/TypeScript files (for JSX/TSX)
(add-hook 'js-mode-hook #'tailwindcss-mode)
(add-hook 'typescript-mode-hook #'tailwindcss-mode)

;; ===== Basic Customization =====

;; Enable class name completion
(setq tailwindcss-enable-class-completion t)

;; Set the TailwindCSS CLI path (adjust if needed)
(setq tailwindcss-cli-path "npx tailwindcss")

;; Set the configuration file name (adjust if you use TypeScript config)
(setq tailwindcss-config-file "tailwind.config.js")

;; ===== Optional: Key Bindings =====

;; Define convenient key bindings for common commands
(with-eval-after-load 'tailwindcss
  (define-key tailwindcss-mode-map (kbd "C-c t b") 'tailwindcss-build)
  (define-key tailwindcss-mode-map (kbd "C-c t l") 'tailwindcss-list-classes)
  (define-key tailwindcss-mode-map (kbd "C-c t v") 'tailwindcss-validate-buffer)
  (define-key tailwindcss-mode-map (kbd "C-c t s") 'tailwindcss-sort-classes-in-region)
  (define-key tailwindcss-mode-map (kbd "C-c t o") 'tailwindcss-open-config))

;;; basic-config.el ends here
