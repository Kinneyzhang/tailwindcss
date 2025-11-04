;;; tailwindcss.el --- TailwindCSS integration for Emacs -*- lexical-binding: t; -*-

;; Copyright (C) 2025

;; Author: TailwindCSS Contributors
;; Version: 4.1.16
;; Package-Requires: ((emacs "26.1"))
;; Keywords: tailwindcss, css, web, convenience
;; URL: https://github.com/Kinneyzhang/tailwindcss

;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the MIT License.

;;; Commentary:

;; This package provides TailwindCSS integration for Emacs, including:
;; - Syntax highlighting for TailwindCSS configuration files
;; - Utility functions for working with TailwindCSS classes
;; - Class name completion and validation helpers
;; - Support for TailwindCSS v4.x features

;;; Code:

(require 'cl-lib)
(require 'json)

;;; Customization

(defgroup tailwindcss nil
  "TailwindCSS integration for Emacs."
  :group 'web
  :prefix "tailwindcss-")

(defcustom tailwindcss-config-file "tailwind.config.js"
  "The name of the TailwindCSS configuration file."
  :type 'string
  :group 'tailwindcss)

(defcustom tailwindcss-cli-path "npx tailwindcss"
  "Path to the TailwindCSS CLI executable."
  :type 'string
  :group 'tailwindcss)

(defcustom tailwindcss-enable-class-completion t
  "Enable class name completion in HTML and related modes."
  :type 'boolean
  :group 'tailwindcss)

(defcustom tailwindcss-preflight-css-path "preflight.css"
  "Path to the TailwindCSS preflight CSS file."
  :type 'string
  :group 'tailwindcss)

;;; Variables

(defvar tailwindcss-utilities-list
  '("container" "space-x" "space-y" "space-x-reverse" "space-y-reverse"
    "divide-x" "divide-y" "divide-x-reverse" "divide-y-reverse"
    "sr-only" "not-sr-only" "forced-color-adjust-auto" "forced-color-adjust-none")
  "List of TailwindCSS utility classes.")

(defvar tailwindcss-colors-list
  '("slate" "gray" "zinc" "neutral" "stone" "red" "orange" "amber" "yellow"
    "lime" "green" "emerald" "teal" "cyan" "sky" "blue" "indigo" "violet"
    "purple" "fuchsia" "pink" "rose" "black" "white" "transparent" "current"
    "inherit")
  "List of TailwindCSS color names.")

(defvar tailwindcss-breakpoints-list
  '("sm" "md" "lg" "xl" "2xl")
  "List of TailwindCSS breakpoint prefixes.")

(defvar tailwindcss-state-variants-list
  '("hover" "focus" "active" "focus-within" "focus-visible" "visited"
    "target" "first" "last" "only" "odd" "even" "first-of-type"
    "last-of-type" "only-of-type" "empty" "disabled" "enabled"
    "checked" "indeterminate" "default" "required" "valid" "invalid"
    "in-range" "out-of-range" "placeholder-shown" "autofill" "read-only")
  "List of TailwindCSS state variant prefixes.")

(defvar tailwindcss-pseudo-class-variants-list
  '("before" "after" "first-letter" "first-line" "marker" "selection"
    "file" "backdrop" "placeholder")
  "List of TailwindCSS pseudo-class variant prefixes.")

(defvar tailwindcss-responsive-variants-list
  '("portrait" "landscape" "motion-safe" "motion-reduce" "dark" "light"
    "contrast-more" "contrast-less" "print")
  "List of TailwindCSS responsive variant prefixes.")

;;; Core Functions

(defun tailwindcss-find-config-file ()
  "Find the TailwindCSS configuration file in the project.
Searches for multiple common config file names."
  (let ((config-names (if (listp tailwindcss-config-file)
                          tailwindcss-config-file
                        (list tailwindcss-config-file
                              "tailwind.config.js"
                              "tailwind.config.ts"
                              "tailwind.config.cjs"
                              "tailwind.config.mjs"))))
    (cl-some (lambda (name)
               (let ((config-file (locate-dominating-file default-directory name)))
                 (when config-file
                   (expand-file-name name config-file))))
             config-names)))

(defun tailwindcss-parse-class-name (class-name)
  "Parse a TailwindCSS CLASS-NAME into its components.
Returns a plist with :variant, :prefix, :utility, and :value."
  (let ((parts (split-string class-name ":")))
    (if (> (length parts) 1)
        (list :variants (butlast parts)
              :utility (car (last parts)))
      (list :variants nil
            :utility class-name))))

(defun tailwindcss-is-valid-variant-p (variant)
  "Check if VARIANT is a valid TailwindCSS variant."
  (or (member variant tailwindcss-breakpoints-list)
      (member variant tailwindcss-state-variants-list)
      (member variant tailwindcss-pseudo-class-variants-list)
      (member variant tailwindcss-responsive-variants-list)))

(defun tailwindcss-validate-class-name (class-name)
  "Validate if CLASS-NAME is a valid TailwindCSS class.
Returns t if valid, nil otherwise."
  (let* ((parsed (tailwindcss-parse-class-name class-name))
         (variants (plist-get parsed :variants))
         (utility (plist-get parsed :utility)))
    (and utility
         (or (null variants)
             (cl-every #'tailwindcss-is-valid-variant-p variants)))))

(defun tailwindcss-extract-classes-from-buffer ()
  "Extract all TailwindCSS class names from the current buffer."
  (save-excursion
    (goto-char (point-min))
    (let ((classes '()))
      (while (re-search-forward "class\\(?:Name\\)?=[\"']\\([^\"']+\\)[\"']" nil t)
        (let ((class-string (match-string 1)))
          (dolist (class (split-string class-string))
            (when (> (length class) 0)
              (push class classes)))))
      (delete-dups (nreverse classes)))))

(defun tailwindcss-format-class-list (classes)
  "Format a list of CLASSES for display or output."
  (mapconcat #'identity classes " "))

(defun tailwindcss-sort-classes (classes)
  "Sort CLASSES according to TailwindCSS recommended order.
This is a simplified sorting by category."
  (let ((layout '())
        (flexbox '())
        (grid '())
        (spacing '())
        (sizing '())
        (typography '())
        (backgrounds '())
        (borders '())
        (effects '())
        (filters '())
        (tables '())
        (transitions '())
        (transforms '())
        (interactivity '())
        (svg '())
        (accessibility '())
        (other '()))
    (dolist (class classes)
      (cond
       ((string-match-p "^\\(block\\|inline\\|flex\\|grid\\|hidden\\)" class)
        (push class layout))
       ((string-match-p "^\\(flex-\\|justify-\\|items-\\|content-\\|self-\\)" class)
        (push class flexbox))
       ((string-match-p "^\\(grid-\\|gap-\\|col-\\|row-\\)" class)
        (push class grid))
       ((string-match-p "^\\([mp][trblxy]?-\\|space-\\)" class)
        (push class spacing))
       ((string-match-p "^\\([wh]-\\|min-\\|max-\\)" class)
        (push class sizing))
       ((string-match-p "^\\(text-\\|font-\\|leading-\\|tracking-\\|align-\\)" class)
        (push class typography))
       ((string-match-p "^\\(bg-\\)" class)
        (push class backgrounds))
       ((string-match-p "^\\(border\\|rounded\\|divide-\\)" class)
        (push class borders))
       ((string-match-p "^\\(shadow\\|opacity-\\)" class)
        (push class effects))
       ((string-match-p "^\\(blur\\|brightness\\|contrast\\|grayscale\\)" class)
        (push class filters))
       ((string-match-p "^\\(table\\|border-collapse\\)" class)
        (push class tables))
       ((string-match-p "^\\(transition\\|duration\\|ease\\|delay\\|animate\\)" class)
        (push class transitions))
       ((string-match-p "^\\(scale\\|rotate\\|translate\\|skew\\|transform\\)" class)
        (push class transforms))
       ((string-match-p "^\\(cursor-\\|pointer-events\\|resize\\|select-\\|appearance-\\)" class)
        (push class interactivity))
       ((string-match-p "^\\(fill-\\|stroke-\\)" class)
        (push class svg))
       ((string-match-p "^\\(sr-only\\|not-sr-only\\)" class)
        (push class accessibility))
       (t (push class other))))
    (append (nreverse layout) (nreverse flexbox) (nreverse grid)
            (nreverse spacing) (nreverse sizing) (nreverse typography)
            (nreverse backgrounds) (nreverse borders) (nreverse effects)
            (nreverse filters) (nreverse tables) (nreverse transitions)
            (nreverse transforms) (nreverse interactivity) (nreverse svg)
            (nreverse accessibility) (nreverse other))))

;;; Interactive Commands

;;;###autoload
(defun tailwindcss-build ()
  "Build TailwindCSS using the CLI."
  (interactive)
  (let ((config (tailwindcss-find-config-file)))
    (if config
        (compile (format "%s build" tailwindcss-cli-path))
      (user-error "TailwindCSS config file not found"))))

;;;###autoload
(defun tailwindcss-init ()
  "Initialize a new TailwindCSS project."
  (interactive)
  (compile (format "%s init" tailwindcss-cli-path)))

;;;###autoload
(defun tailwindcss-list-classes ()
  "List all TailwindCSS classes found in the current buffer."
  (interactive)
  (let ((classes (tailwindcss-extract-classes-from-buffer)))
    (if classes
        (with-output-to-temp-buffer "*TailwindCSS Classes*"
          (princ (format "Found %d classes:\n\n" (length classes)))
          (dolist (class (sort classes #'string<))
            (princ (format "%s\n" class))))
      (message "No TailwindCSS classes found in buffer"))))

;;;###autoload
(defun tailwindcss-sort-classes-in-region (start end)
  "Sort TailwindCSS classes in the region from START to END."
  (interactive "r")
  (let* ((text (buffer-substring-no-properties start end))
         (classes (split-string text))
         (sorted (tailwindcss-sort-classes classes)))
    (delete-region start end)
    (insert (tailwindcss-format-class-list sorted))))

;;;###autoload
(defun tailwindcss-validate-buffer ()
  "Validate all TailwindCSS classes in the current buffer."
  (interactive)
  (let ((classes (tailwindcss-extract-classes-from-buffer))
        (invalid '()))
    (dolist (class classes)
      (unless (tailwindcss-validate-class-name class)
        (push class invalid)))
    (if invalid
        (with-output-to-temp-buffer "*TailwindCSS Validation*"
          (princ (format "Found %d invalid classes:\n\n" (length invalid)))
          (dolist (class (sort invalid #'string<))
            (princ (format "%s\n" class))))
      (message "All classes are valid!"))))

;;;###autoload
(defun tailwindcss-insert-utility-class (class)
  "Insert a TailwindCSS utility CLASS at point."
  (interactive
   (list (completing-read "Utility class: "
                         tailwindcss-utilities-list
                         nil nil)))
  (insert class))

;;;###autoload
(defun tailwindcss-open-config ()
  "Open the TailwindCSS configuration file."
  (interactive)
  (let ((config (tailwindcss-find-config-file)))
    (if config
        (find-file config)
      (user-error "TailwindCSS config file not found"))))

;;; Mode Definition

;;;###autoload
(define-derived-mode tailwindcss-config-mode js-mode "TailwindCSS-Config"
  "Major mode for editing TailwindCSS configuration files."
  :group 'tailwindcss
  (setq-local comment-start "// ")
  (setq-local comment-end "")
  (font-lock-add-keywords
   nil
   '(("\\<\\(theme\\|extend\\|content\\|plugins\\|darkMode\\)\\>" . font-lock-keyword-face)
     ("\\<\\(colors\\|spacing\\|fontFamily\\|fontSize\\|fontWeight\\)\\>" . font-lock-builtin-face))))

;;;###autoload
(add-to-list 'auto-mode-alist '("tailwind\\.config\\.js\\'" . tailwindcss-config-mode))
;;;###autoload
(add-to-list 'auto-mode-alist '("tailwind\\.config\\.ts\\'" . tailwindcss-config-mode))

;;; Completion Support

(defun tailwindcss-completion-at-point ()
  "Provide completion for TailwindCSS class names at point."
  (when tailwindcss-enable-class-completion
    (let ((bounds (bounds-of-thing-at-point 'symbol)))
      (when bounds
        (list (car bounds)
              (cdr bounds)
              tailwindcss-utilities-list
              :annotation-function
              (lambda (_) " <tailwindcss>")
              :company-doc-buffer
              (lambda (candidate)
                (with-current-buffer (get-buffer-create "*tailwindcss-doc*")
                  (erase-buffer)
                  (insert (format "TailwindCSS utility class: %s" candidate))
                  (current-buffer))))))))

;;;###autoload
(defun tailwindcss-setup-completion ()
  "Set up completion for TailwindCSS in the current buffer."
  (add-hook 'completion-at-point-functions
            #'tailwindcss-completion-at-point nil t))

;;; Minor Mode

;;;###autoload
(define-minor-mode tailwindcss-mode
  "Minor mode for TailwindCSS integration."
  :lighter " TW"
  :group 'tailwindcss
  (if tailwindcss-mode
      (tailwindcss-setup-completion)
    (remove-hook 'completion-at-point-functions
                 #'tailwindcss-completion-at-point t)))

;;; Utility Functions for Development

(defun tailwindcss-get-version ()
  "Get the TailwindCSS version from package.json."
  (let ((package-json (locate-dominating-file default-directory "package.json")))
    (when package-json
      (with-temp-buffer
        (insert-file-contents (expand-file-name "package.json" package-json))
        (goto-char (point-min))
        (when (re-search-forward "\"tailwindcss\":\\s-*\"\\([^\"]+\\)\"" nil t)
          (match-string 1))))))

(defun tailwindcss-generate-class-list ()
  "Generate a list of all available TailwindCSS classes.
This is a helper function for development and can be extended."
  (let ((classes '()))
    ;; Add utility classes
    (dolist (util tailwindcss-utilities-list)
      (push util classes))
    ;; Add color variants
    (dolist (color tailwindcss-colors-list)
      (dolist (prefix '("text-" "bg-" "border-"))
        (push (concat prefix color) classes)))
    ;; Return sorted unique list
    (sort (delete-dups classes) #'string<)))

;;; Footer

(provide 'tailwindcss)

;;; tailwindcss.el ends here
