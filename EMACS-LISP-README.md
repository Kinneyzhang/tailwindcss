# TailwindCSS Emacs Integration

English | [简体中文](README-zh.md)

## Introduction

This is an Emacs Lisp package that provides comprehensive TailwindCSS support for the Emacs editor. It offers a suite of tools and features to make working with TailwindCSS in Emacs more convenient and efficient.

## Features

- ✨ **Syntax Highlighting**: Provides syntax highlighting for TailwindCSS configuration files
- 🔍 **Class Validation**: Validates TailwindCSS class names in HTML/JSX files
- 📝 **Auto-completion**: Offers auto-completion for TailwindCSS utility classes
- 🔨 **CLI Integration**: Call TailwindCSS CLI tools directly from Emacs
- 📦 **Class Sorting**: Sort class names according to TailwindCSS recommended order
- 🎯 **Quick Navigation**: Quickly open and edit TailwindCSS configuration files

## Installation

### Method 1: Manual Installation

1. Download the `tailwindcss.el` file
2. Place it in your Emacs load path
3. Add to your Emacs configuration file (`~/.emacs` or `~/.emacs.d/init.el`):

```emacs-lisp
(add-to-list 'load-path "/path/to/tailwindcss")
(require 'tailwindcss)
```

### Method 2: Using use-package

If you use `use-package`:

```emacs-lisp
(use-package tailwindcss
  :load-path "/path/to/tailwindcss"
  :hook ((html-mode . tailwindcss-mode)
         (web-mode . tailwindcss-mode)
         (js-mode . tailwindcss-mode)
         (typescript-mode . tailwindcss-mode))
  :config
  (setq tailwindcss-enable-class-completion t))
```

### Method 3: Using straight.el

```emacs-lisp
(straight-use-package
 '(tailwindcss :type git :host github :repo "Kinneyzhang/tailwindcss"
               :files ("tailwindcss.el")))
```

## Basic Usage

### Enable TailwindCSS Mode

Enable `tailwindcss-mode` in supported file types (HTML, JSX, Vue, etc.):

```emacs-lisp
M-x tailwindcss-mode
```

Or automatically enable in your configuration:

```emacs-lisp
(add-hook 'html-mode-hook #'tailwindcss-mode)
(add-hook 'web-mode-hook #'tailwindcss-mode)
```

### Main Commands

#### 1. Initialize TailwindCSS Project

```
M-x tailwindcss-init
```

Initialize TailwindCSS configuration in the current project.

#### 2. Build TailwindCSS

```
M-x tailwindcss-build
```

Build CSS files using the TailwindCSS CLI.

#### 3. List Classes in Current Buffer

```
M-x tailwindcss-list-classes
```

Display all TailwindCSS classes used in the current file.

#### 4. Validate Class Names

```
M-x tailwindcss-validate-buffer
```

Check if all TailwindCSS class names in the current buffer are valid.

#### 5. Sort Class Names

Select a region containing TailwindCSS class names, then:

```
M-x tailwindcss-sort-classes-in-region
```

Class names will be reordered according to TailwindCSS recommended order.

#### 6. Open Configuration File

```
M-x tailwindcss-open-config
```

Quickly open the TailwindCSS configuration file in your project.

#### 7. Insert Utility Class

```
M-x tailwindcss-insert-utility-class
```

Select and insert a class name from the predefined utility class list.

## Configuration Options

### Customizable Variables

You can customize the behavior of TailwindCSS integration by setting these variables:

```emacs-lisp
;; Configuration file name (default: tailwind.config.js)
(setq tailwindcss-config-file "tailwind.config.js")

;; TailwindCSS CLI path (default: npx tailwindcss)
(setq tailwindcss-cli-path "npx tailwindcss")

;; Enable class name auto-completion (default: t)
(setq tailwindcss-enable-class-completion t)

;; Preflight CSS file path
(setq tailwindcss-preflight-css-path "preflight.css")
```

### Suggested Key Bindings

You can set up keyboard shortcuts for common commands:

```emacs-lisp
(define-key tailwindcss-mode-map (kbd "C-c t b") 'tailwindcss-build)
(define-key tailwindcss-mode-map (kbd "C-c t l") 'tailwindcss-list-classes)
(define-key tailwindcss-mode-map (kbd "C-c t v") 'tailwindcss-validate-buffer)
(define-key tailwindcss-mode-map (kbd "C-c t s") 'tailwindcss-sort-classes-in-region)
(define-key tailwindcss-mode-map (kbd "C-c t o") 'tailwindcss-open-config)
(define-key tailwindcss-mode-map (kbd "C-c t i") 'tailwindcss-insert-utility-class)
```

## Advanced Features

### Class Name Parsing

`tailwindcss.el` provides powerful class name parsing capabilities:

```emacs-lisp
;; Parse class name
(tailwindcss-parse-class-name "hover:bg-blue-500")
;; => (:variants ("hover") :utility "bg-blue-500")

;; Validate class name
(tailwindcss-validate-class-name "hover:bg-blue-500")
;; => t

;; Extract all classes from buffer
(tailwindcss-extract-classes-from-buffer)
;; => ("flex" "items-center" "justify-between" "bg-white" ...)
```

### Class Sorting

The class sorting feature organizes class names in the following order:

1. Layout
2. Flexbox
3. Grid
4. Spacing
5. Sizing
6. Typography
7. Backgrounds
8. Borders
9. Effects
10. Filters
11. Tables
12. Transitions
13. Transforms
14. Interactivity
15. SVG
16. Accessibility

### Configuration File Mode

`tailwindcss.el` provides a dedicated major mode for TailwindCSS configuration files:

- Automatic syntax highlighting
- Keyword recognition
- Smart comments

Configuration files automatically use `tailwindcss-config-mode`:
- `tailwind.config.js`
- `tailwind.config.ts`

## Integration with Other Packages

### Company Mode

If you use `company-mode` for code completion:

```emacs-lisp
(use-package company
  :ensure t
  :hook (tailwindcss-mode . company-mode))
```

### LSP Mode

Use with `lsp-mode` and `lsp-tailwindcss`:

```emacs-lisp
(use-package lsp-mode
  :ensure t
  :hook ((html-mode . lsp)
         (web-mode . lsp)
         (js-mode . lsp))
  :config
  (setq lsp-tailwindcss-add-on-mode t))
```

### Web Mode

Use in `web-mode`:

```emacs-lisp
(use-package web-mode
  :ensure t
  :mode "\\.html\\'"
  :hook (web-mode . tailwindcss-mode))
```

## Development Guide

### Project Structure

```
tailwindcss/
├── tailwindcss.el          # Main implementation file
├── README-zh.md            # Chinese documentation
├── EMACS-LISP-README.md    # English documentation
└── tests/
    └── tailwindcss-test.el # Test file
```

### Extending Functionality

You can extend `tailwindcss.el` in the following ways:

#### Add Custom Utility Classes

```emacs-lisp
(setq tailwindcss-utilities-list
      (append tailwindcss-utilities-list
              '("my-custom-class" "another-custom-class")))
```

#### Add Custom Colors

```emacs-lisp
(setq tailwindcss-colors-list
      (append tailwindcss-colors-list
              '("brand-primary" "brand-secondary")))
```

#### Custom Validation Rules

You can override the `tailwindcss-validate-class-name` function to implement custom validation logic:

```emacs-lisp
(defun my-tailwindcss-validate (class-name)
  "Custom TailwindCSS class name validation."
  (or (tailwindcss-validate-class-name class-name)
      ;; Add your custom validation logic
      (string-match-p "^custom-" class-name)))
```

### Writing Tests

Write tests using ERT (Emacs Lisp Regression Testing):

```emacs-lisp
(require 'ert)
(require 'tailwindcss)

(ert-deftest test-tailwindcss-parse-class-name ()
  "Test class name parsing functionality."
  (let ((result (tailwindcss-parse-class-name "hover:bg-blue-500")))
    (should (equal (plist-get result :variants) '("hover")))
    (should (equal (plist-get result :utility) "bg-blue-500"))))
```

Run tests:

```
M-x ert RET t RET
```

### Contributing

Contributions are welcome! Please follow these steps:

1. Fork this repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

#### Code Style

- Use `lexical-binding: t`
- Follow Emacs Lisp coding conventions
- Add docstrings to public functions
- Use `;;;###autoload` to mark autoloaded functions
- Keep code clean and readable

## Troubleshooting

### Auto-completion Not Working

Ensure `tailwindcss-enable-class-completion` is set to `t`:

```emacs-lisp
(setq tailwindcss-enable-class-completion t)
```

And `tailwindcss-mode` is enabled:

```
M-x tailwindcss-mode
```

### Configuration File Not Found

Make sure your project root contains a `tailwind.config.js` or `tailwind.config.ts` file.

You can also customize the configuration file name:

```emacs-lisp
(setq tailwindcss-config-file "my-tailwind.config.js")
```

### CLI Commands Failing

Check if `tailwindcss-cli-path` is set correctly:

```emacs-lisp
(setq tailwindcss-cli-path "npx tailwindcss")
```

Or use the full path:

```emacs-lisp
(setq tailwindcss-cli-path "/usr/local/bin/tailwindcss")
```

## Example Configuration

Here's a complete Emacs configuration example:

```emacs-lisp
;; Load TailwindCSS support
(use-package tailwindcss
  :load-path "~/.emacs.d/lisp/tailwindcss"
  :hook ((html-mode . tailwindcss-mode)
         (web-mode . tailwindcss-mode)
         (js-mode . tailwindcss-mode)
         (typescript-mode . tailwindcss-mode)
         (vue-mode . tailwindcss-mode))
  :config
  ;; Configuration options
  (setq tailwindcss-enable-class-completion t)
  (setq tailwindcss-cli-path "npx tailwindcss")
  
  ;; Key bindings
  (define-key tailwindcss-mode-map (kbd "C-c t b") 'tailwindcss-build)
  (define-key tailwindcss-mode-map (kbd "C-c t l") 'tailwindcss-list-classes)
  (define-key tailwindcss-mode-map (kbd "C-c t v") 'tailwindcss-validate-buffer)
  (define-key tailwindcss-mode-map (kbd "C-c t s") 'tailwindcss-sort-classes-in-region)
  (define-key tailwindcss-mode-map (kbd "C-c t o") 'tailwindcss-open-config)
  (define-key tailwindcss-mode-map (kbd "C-c t i") 'tailwindcss-insert-utility-class))

;; Integration with Company
(use-package company
  :ensure t
  :hook (tailwindcss-mode . company-mode)
  :config
  (setq company-minimum-prefix-length 1)
  (setq company-idle-delay 0.1))

;; Integration with LSP (optional)
(use-package lsp-mode
  :ensure t
  :hook ((html-mode . lsp)
         (web-mode . lsp))
  :commands lsp)
```

## Performance Optimization

For large projects, you may need to adjust some settings to improve performance:

```emacs-lisp
;; Disable real-time validation for some buffers
(setq tailwindcss-auto-validate nil)

;; Increase completion delay
(setq company-idle-delay 0.3)

;; Limit number of completion candidates
(setq company-minimum-prefix-length 3)
```

## API Reference

### Functions

#### `tailwindcss-find-config-file`

Find the TailwindCSS configuration file in the project.

**Returns:** Path to the configuration file or nil if not found.

#### `tailwindcss-parse-class-name (class-name)`

Parse a TailwindCSS class name into its components.

**Arguments:**
- `class-name`: String - The class name to parse

**Returns:** Plist with `:variants` and `:utility` keys.

**Example:**
```emacs-lisp
(tailwindcss-parse-class-name "md:hover:bg-blue-500")
;; => (:variants ("md" "hover") :utility "bg-blue-500")
```

#### `tailwindcss-validate-class-name (class-name)`

Validate if a class name is a valid TailwindCSS class.

**Arguments:**
- `class-name`: String - The class name to validate

**Returns:** t if valid, nil otherwise.

#### `tailwindcss-extract-classes-from-buffer`

Extract all TailwindCSS class names from the current buffer.

**Returns:** List of class name strings.

#### `tailwindcss-sort-classes (classes)`

Sort classes according to TailwindCSS recommended order.

**Arguments:**
- `classes`: List of strings - Class names to sort

**Returns:** Sorted list of class names.

### Variables

#### `tailwindcss-utilities-list`

List of TailwindCSS utility classes.

**Type:** List of strings

#### `tailwindcss-colors-list`

List of TailwindCSS color names.

**Type:** List of strings

#### `tailwindcss-breakpoints-list`

List of TailwindCSS breakpoint prefixes.

**Type:** List of strings

#### `tailwindcss-state-variants-list`

List of TailwindCSS state variant prefixes.

**Type:** List of strings

### Interactive Commands

All interactive commands are listed in the [Main Commands](#main-commands) section.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

- The TailwindCSS team for creating an excellent CSS framework
- The Emacs community for continuous support and contributions

## Related Links

- [TailwindCSS Official Website](https://tailwindcss.com)
- [TailwindCSS GitHub](https://github.com/tailwindlabs/tailwindcss)
- [Emacs Wiki](https://www.emacswiki.org)
- [GNU Emacs](https://www.gnu.org/software/emacs/)

## Version History

### v4.1.16 (Current Version)

- Initial release
- Support for TailwindCSS v4.x
- Basic class name completion and validation
- TailwindCSS CLI integration
- Configuration file syntax highlighting

## Feedback and Support

If you encounter any issues or have suggestions:

- Submit an [Issue](https://github.com/Kinneyzhang/tailwindcss/issues) on GitHub
- Email the project maintainers
- Join [GitHub Discussions](https://github.com/Kinneyzhang/tailwindcss/discussions)

Thank you for using TailwindCSS Emacs Integration!
