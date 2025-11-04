# TailwindCSS Emacs Integration - Quick Start Guide

[中文版](QUICKSTART-zh.md)

## 5-Minute Setup

### Step 1: Install the Package

Copy `tailwindcss.el` to your Emacs configuration directory:

```bash
cd ~/.emacs.d/lisp
git clone https://github.com/Kinneyzhang/tailwindcss.git
```

### Step 2: Configure Emacs

Add to your `~/.emacs` or `~/.emacs.d/init.el`:

```emacs-lisp
;; Add to load path
(add-to-list 'load-path "~/.emacs.d/lisp/tailwindcss")

;; Load TailwindCSS support
(require 'tailwindcss)

;; Enable in HTML and JavaScript files
(add-hook 'html-mode-hook 'tailwindcss-mode)
(add-hook 'js-mode-hook 'tailwindcss-mode)
(add-hook 'typescript-mode-hook 'tailwindcss-mode)
```

### Step 3: Restart Emacs or Reload Configuration

```
M-x eval-buffer
```

### Step 4: Test It!

Open an HTML file and try:

```
M-x tailwindcss-mode
```

You should see " TW" in the mode line.

## Common Use Cases

### Use Case 1: Auto-complete Class Names

1. Open an HTML file
2. Start typing a class name: `<div class="fl`
3. Press `M-TAB` or your completion key
4. Select from available completions

### Use Case 2: Sort Class Names

1. Select a region with class names:
   ```html
   <div class="text-lg bg-white p-4 flex items-center">
   ```

2. Run: `M-x tailwindcss-sort-classes-in-region`

3. Classes are reordered:
   ```html
   <div class="flex items-center p-4 text-lg bg-white">
   ```

### Use Case 3: Validate Classes

1. Open a file with TailwindCSS classes
2. Run: `M-x tailwindcss-validate-buffer`
3. See a list of any invalid class names

### Use Case 4: Build TailwindCSS

1. Make sure you have TailwindCSS installed in your project
2. Run: `M-x tailwindcss-build`
3. The build output appears in a compilation buffer

### Use Case 5: Quick Navigation to Config

1. From any file in your project
2. Run: `M-x tailwindcss-open-config`
3. The `tailwind.config.js` file opens

## Keyboard Shortcuts

Add these to your configuration for quick access:

```emacs-lisp
;; Define a prefix key for TailwindCSS commands
(global-set-key (kbd "C-c t") nil)  ; Clear any existing binding

;; TailwindCSS commands
(define-key global-map (kbd "C-c t b") 'tailwindcss-build)
(define-key global-map (kbd "C-c t i") 'tailwindcss-init)
(define-key global-map (kbd "C-c t l") 'tailwindcss-list-classes)
(define-key global-map (kbd "C-c t v") 'tailwindcss-validate-buffer)
(define-key global-map (kbd "C-c t s") 'tailwindcss-sort-classes-in-region)
(define-key global-map (kbd "C-c t o") 'tailwindcss-open-config)
(define-key global-map (kbd "C-c t m") 'tailwindcss-mode)
```

Now you can use:
- `C-c t b` - Build TailwindCSS
- `C-c t i` - Initialize TailwindCSS
- `C-c t l` - List classes in buffer
- `C-c t v` - Validate classes
- `C-c t s` - Sort selected classes
- `C-c t o` - Open config file
- `C-c t m` - Toggle TailwindCSS mode

## Integration with Popular Packages

### With Company Mode

```emacs-lisp
(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :config
  (setq company-idle-delay 0.1)
  (setq company-minimum-prefix-length 1))

;; TailwindCSS will automatically integrate with company
```

### With use-package

```emacs-lisp
(use-package tailwindcss
  :load-path "~/.emacs.d/lisp/tailwindcss"
  :hook ((html-mode . tailwindcss-mode)
         (web-mode . tailwindcss-mode)
         (js-jsx-mode . tailwindcss-mode)
         (typescript-mode . tailwindcss-mode)
         (tsx-ts-mode . tailwindcss-mode))
  :bind (:map tailwindcss-mode-map
              ("C-c C-t b" . tailwindcss-build)
              ("C-c C-t v" . tailwindcss-validate-buffer)
              ("C-c C-t s" . tailwindcss-sort-classes-in-region)))
```

### With web-mode

```emacs-lisp
(use-package web-mode
  :ensure t
  :mode ("\\.html\\'" "\\.jsx\\'" "\\.tsx\\'")
  :hook (web-mode . tailwindcss-mode)
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))
```

### With LSP Mode

```emacs-lisp
(use-package lsp-mode
  :ensure t
  :hook ((html-mode . lsp)
         (web-mode . lsp)
         (typescript-mode . lsp))
  :config
  (setq lsp-tailwindcss-add-on-mode t))

;; Use both LSP and tailwindcss-mode together
(add-hook 'html-mode-hook 'tailwindcss-mode)
```

## Example Workflow

### Starting a New Project

```bash
# Create new project
mkdir my-project && cd my-project

# Initialize npm and TailwindCSS
npm init -y
npm install -D tailwindcss

# Open project in Emacs
emacs .
```

In Emacs:

```
M-x tailwindcss-init
```

This creates a `tailwind.config.js` file.

### Working on an Existing Project

```bash
# Open your project
cd my-existing-project
emacs .
```

In Emacs:

```
# Open an HTML file
C-x C-f index.html

# Enable TailwindCSS mode
M-x tailwindcss-mode

# Start editing with completions!
```

### Building for Production

```
# Build TailwindCSS
M-x tailwindcss-build

# Or use custom build command
M-x compile RET npm run build:css
```

## Customization Examples

### Custom CLI Path

If TailwindCSS is installed globally or in a specific location:

```emacs-lisp
(setq tailwindcss-cli-path "/usr/local/bin/tailwindcss")
```

Or if using a custom npm script:

```emacs-lisp
(setq tailwindcss-cli-path "npm run tailwind")
```

### Custom Configuration File Name

If your config file has a different name:

```emacs-lisp
(setq tailwindcss-config-file "tailwind.config.ts")
```

### Disable Auto-completion

If you prefer manual completion:

```emacs-lisp
(setq tailwindcss-enable-class-completion nil)
```

### Add Custom Classes

Add your project-specific classes:

```emacs-lisp
(setq tailwindcss-utilities-list
      (append tailwindcss-utilities-list
              '("hero-section" "card-container" "custom-button")))
```

## Troubleshooting

### Problem: Mode not activating

**Solution:** Make sure the package is loaded:

```emacs-lisp
M-x load-file RET ~/.emacs.d/lisp/tailwindcss/tailwindcss.el RET
M-x tailwindcss-mode RET
```

### Problem: Completion not working

**Solution:** Check these settings:

```emacs-lisp
;; Ensure completion is enabled
(setq tailwindcss-enable-class-completion t)

;; Verify the mode is active
M-x describe-mode

;; Check completion functions
M-x describe-variable RET completion-at-point-functions RET
```

### Problem: Can't find config file

**Solution:** Verify the file exists and the name matches:

```emacs-lisp
;; Check current directory
M-x pwd

;; List files
M-x dired

;; Try finding manually
M-x tailwindcss-find-config-file
```

### Problem: Build command fails

**Solution:** Check TailwindCSS installation:

```bash
# In terminal
npm list tailwindcss

# Or try global installation
npm install -g tailwindcss
```

## Next Steps

- Read the [full documentation](EMACS-LISP-README.md)
- Check out [development guide](DEVELOPMENT.md)
- View [examples and recipes](EXAMPLES.md)
- Browse [API reference](EMACS-LISP-README.md#api-reference)

## Getting Help

- Check [Troubleshooting](EMACS-LISP-README.md#troubleshooting) section
- Search [existing issues](https://github.com/Kinneyzhang/tailwindcss/issues)
- Ask in [discussions](https://github.com/Kinneyzhang/tailwindcss/discussions)
- Read [TailwindCSS docs](https://tailwindcss.com/docs)

## Tips and Tricks

### Tip 1: Use with Snippets

Create a snippet for common patterns:

```emacs-lisp
;; With yasnippet
;; ~/.emacs.d/snippets/html-mode/tw-flex
# name: Flex container
# key: twflex
# --
<div class="flex items-center justify-$1">
  $0
</div>
```

### Tip 2: Project-specific Settings

Use `.dir-locals.el` in your project root:

```emacs-lisp
((html-mode . ((tailwindcss-cli-path . "npm run build:css")))
 (js-mode . ((tailwindcss-mode . t))))
```

### Tip 3: Combine with Multiple Modes

```emacs-lisp
(add-hook 'html-mode-hook
          (lambda ()
            (tailwindcss-mode 1)
            (electric-pair-mode 1)
            (auto-fill-mode 0)))
```

### Tip 4: Quick Class Insertion

Create a hydra for quick access:

```emacs-lisp
(defhydra hydra-tailwindcss (:color blue)
  "TailwindCSS"
  ("b" tailwindcss-build "build")
  ("v" tailwindcss-validate-buffer "validate")
  ("s" tailwindcss-sort-classes-in-region "sort")
  ("l" tailwindcss-list-classes "list")
  ("o" tailwindcss-open-config "open config")
  ("i" tailwindcss-insert-utility-class "insert")
  ("q" nil "quit"))

(global-set-key (kbd "C-c t") 'hydra-tailwindcss/body)
```

## Video Tutorial

(Coming soon - Watch this space for video tutorials!)

## Community

Join the community:
- Star the repo on [GitHub](https://github.com/Kinneyzhang/tailwindcss)
- Share your configs and tips
- Contribute improvements
- Help others in discussions

Happy coding with TailwindCSS and Emacs! 🎨✨
