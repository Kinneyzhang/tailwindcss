# TailwindCSS Emacs Lisp - Development Guide

## Overview

This document provides comprehensive guidance for developing and extending the TailwindCSS Emacs Lisp integration.

## Project Architecture

### File Structure

```
tailwindcss/
├── tailwindcss.el              # Main package implementation
├── elisp-tests/
│   └── tailwindcss-test.el     # Test suite
├── README-zh.md                # Chinese documentation
├── EMACS-LISP-README.md        # English documentation
└── DEVELOPMENT.md              # This file
```

### Module Organization

The `tailwindcss.el` file is organized into the following sections:

1. **Header and Metadata**: Package information and requirements
2. **Customization**: User-configurable variables and groups
3. **Variables**: Internal data structures (class lists, variants, etc.)
4. **Core Functions**: Parsing, validation, and utility functions
5. **Interactive Commands**: User-facing commands
6. **Mode Definitions**: Major and minor mode implementations
7. **Completion Support**: Integration with Emacs completion systems

## Core Components

### 1. Class Name Parsing

The parser breaks down TailwindCSS class names into their constituent parts:

```emacs-lisp
(tailwindcss-parse-class-name "md:hover:bg-blue-500")
;; => (:variants ("md" "hover") :utility "bg-blue-500")
```

**Implementation Details:**
- Uses string splitting on `:` delimiter
- Separates variants from the utility class
- Returns a property list for easy access

### 2. Class Name Validation

Validation ensures class names follow TailwindCSS conventions:

```emacs-lisp
(tailwindcss-validate-class-name "hover:bg-blue-500")
;; => t (valid)

(tailwindcss-validate-class-name "invalid:bg-blue-500")
;; => nil (invalid variant)
```

**Validation Rules:**
- All variants must be recognized (breakpoints, states, pseudo-classes, etc.)
- Utility class must be present
- Variant order is not enforced (TailwindCSS allows any order)

### 3. Class Extraction

Extracts class names from HTML-like content:

```emacs-lisp
(tailwindcss-extract-classes-from-buffer)
```

**Features:**
- Supports both `class=""` and `className=""` attributes
- Removes duplicates
- Returns a simple list of strings

### 4. Class Sorting

Organizes classes according to TailwindCSS recommended order:

```emacs-lisp
(tailwindcss-sort-classes '("text-lg" "bg-white" "flex" "mt-4"))
;; => ("flex" "mt-4" "text-lg" "bg-white")
```

**Sorting Categories (in order):**
1. Layout (block, flex, grid, hidden)
2. Flexbox (justify, items, content)
3. Grid (grid-cols, gap)
4. Spacing (margin, padding)
5. Sizing (width, height)
6. Typography (text, font)
7. Backgrounds
8. Borders
9. Effects (shadow, opacity)
10. Filters
11. Tables
12. Transitions
13. Transforms
14. Interactivity
15. SVG
16. Accessibility

## Development Workflow

### Setting Up Development Environment

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Kinneyzhang/tailwindcss.git
   cd tailwindcss
   ```

2. **Load the package in Emacs:**
   ```emacs-lisp
   (add-to-list 'load-path "/path/to/tailwindcss")
   (load-file "/path/to/tailwindcss/tailwindcss.el")
   ```

3. **Enable debug mode:**
   ```emacs-lisp
   (setq debug-on-error t)
   ```

### Running Tests

#### Using ERT (Emacs Lisp Regression Testing)

**Interactive:**
```
M-x load-file RET elisp-tests/tailwindcss-test.el RET
M-x ert RET t RET
```

**Batch Mode:**
```bash
emacs -batch -l ert \
  -l tailwindcss.el \
  -l elisp-tests/tailwindcss-test.el \
  -f ert-run-tests-batch-and-exit
```

**Run specific test:**
```
M-x ert RET tailwindcss-test-parse-simple-class RET
```

### Adding New Features

#### 1. Adding New Utility Classes

To add new utility classes to the completion list:

```emacs-lisp
(defvar tailwindcss-utilities-list
  '("container" "space-x" ...
    "my-new-utility"  ; Add here
    ))
```

Or dynamically:

```emacs-lisp
(add-to-list 'tailwindcss-utilities-list "my-new-utility")
```

#### 2. Adding New Variants

To support new variant types:

```emacs-lisp
(defvar tailwindcss-state-variants-list
  '("hover" "focus" ...
    "my-new-variant"  ; Add here
    ))
```

#### 3. Extending the Sorting Function

To add a new sorting category:

```emacs-lisp
(defun tailwindcss-sort-classes (classes)
  "Sort CLASSES according to TailwindCSS recommended order."
  (let ((layout '())
        (my-category '())  ; Add new category
        (other '()))
    (dolist (class classes)
      (cond
       ;; Existing conditions...
       ((string-match-p "^my-pattern" class)
        (push class my-category))  ; Sort into new category
       (t (push class other))))
    (append (nreverse layout)
            (nreverse my-category)  ; Add to sort order
            (nreverse other))))
```

#### 4. Adding New Commands

To add a new interactive command:

```emacs-lisp
;;;###autoload
(defun tailwindcss-my-new-command ()
  "Description of what this command does."
  (interactive)
  ;; Implementation
  (message "Command executed"))
```

The `;;;###autoload` cookie ensures the command is available after package installation.

### Writing Tests

#### Test Structure

Each test should:
1. Have a descriptive name prefixed with `tailwindcss-test-`
2. Include a docstring explaining what it tests
3. Use `should` or `should-not` assertions
4. Be independent (not rely on other tests)

#### Example Test

```emacs-lisp
(ert-deftest tailwindcss-test-my-feature ()
  "Test my new feature."
  (let ((result (my-function "input")))
    (should (equal result "expected-output"))))
```

#### Test Patterns

**Testing parsing:**
```emacs-lisp
(ert-deftest tailwindcss-test-parse-new-syntax ()
  "Test parsing new syntax."
  (let ((result (tailwindcss-parse-class-name "new:syntax")))
    (should (equal (plist-get result :variants) '("new")))
    (should (equal (plist-get result :utility) "syntax"))))
```

**Testing with buffers:**
```emacs-lisp
(ert-deftest tailwindcss-test-buffer-operation ()
  "Test operation on buffer content."
  (with-temp-buffer
    (insert "test content")
    (let ((result (my-buffer-function)))
      (should (equal result "expected")))))
```

**Testing validation:**
```emacs-lisp
(ert-deftest tailwindcss-test-validate-new-pattern ()
  "Test validation of new pattern."
  (should (tailwindcss-validate-class-name "valid-class"))
  (should-not (tailwindcss-validate-class-name "invalid-class")))
```

## Code Style Guidelines

### Naming Conventions

- **Functions**: Use `tailwindcss-` prefix
- **Variables**: Use `tailwindcss-` prefix
- **Private functions**: Use `tailwindcss--` prefix (double dash)
- **Interactive commands**: Clear, action-oriented names

### Documentation

**Function docstrings:**
```emacs-lisp
(defun tailwindcss-my-function (arg1 arg2)
  "Brief description of what the function does.

ARG1 is description of first argument.
ARG2 is description of second argument.

Returns description of return value.

Example:
  (tailwindcss-my-function \"value1\" \"value2\")
  => result"
  ;; Implementation
  )
```

**Variable docstrings:**
```emacs-lisp
(defvar tailwindcss-my-variable "default"
  "Description of what this variable controls.
Can be set to different values for different behavior.")
```

### Code Organization

- Keep functions focused and single-purpose
- Use meaningful variable names
- Add comments for complex logic
- Keep line length under 100 characters
- Use proper indentation (2 spaces)

### Emacs Lisp Best Practices

1. **Use lexical binding:**
   ```emacs-lisp
   ;;; file.el --- Description -*- lexical-binding: t; -*-
   ```

2. **Prefer `cl-lib` functions:**
   ```emacs-lisp
   (require 'cl-lib)
   (cl-some #'predicate list)
   (cl-every #'predicate list)
   ```

3. **Use `with-temp-buffer` for temporary operations:**
   ```emacs-lisp
   (with-temp-buffer
     (insert "content")
     (do-something))
   ```

4. **Save excursion for buffer operations:**
   ```emacs-lisp
   (save-excursion
     (goto-char (point-min))
     (do-something))
   ```

5. **Use `let` for local bindings:**
   ```emacs-lisp
   (let ((var1 value1)
         (var2 value2))
     (use-vars))
   ```

## Integration with Emacs Ecosystem

### Company Mode Integration

```emacs-lisp
(defun tailwindcss-company-backend (command &optional arg &rest ignored)
  "Company backend for TailwindCSS."
  (interactive (list 'interactive))
  (cl-case command
    (interactive (company-begin-backend 'tailwindcss-company-backend))
    (prefix (and (tailwindcss-mode)
                 (company-grab-symbol)))
    (candidates (tailwindcss-completion-candidates arg))
    (annotation (format " <%s>" "tw"))
    (doc-buffer (tailwindcss-doc-buffer arg))))
```

### LSP Integration

```emacs-lisp
(defun tailwindcss-lsp-setup ()
  "Set up LSP integration for TailwindCSS."
  (when (and (boundp 'lsp-mode)
             (fboundp 'lsp-register-client))
    (lsp-register-client
     (make-lsp-client :new-connection (lsp-stdio-connection "tailwindcss-language-server")
                      :major-modes '(html-mode web-mode)
                      :server-id 'tailwindcss-ls))))
```

### Flycheck Integration

```emacs-lisp
(flycheck-define-checker tailwindcss
  "A TailwindCSS syntax checker."
  :command ("tailwindcss-checker" source)
  :error-patterns
  ((error line-start (file-name) ":" line ":" column ": error: " (message) line-end))
  :modes (html-mode web-mode))
```

## Debugging

### Common Issues and Solutions

**Issue: Completion not working**
```emacs-lisp
;; Check if completion is enabled
(describe-variable 'tailwindcss-enable-class-completion)

;; Verify hook is added
(describe-variable 'completion-at-point-functions)
```

**Issue: Classes not being extracted**
```emacs-lisp
;; Test regex manually
(with-temp-buffer
  (insert "<div class=\"flex\">")
  (goto-char (point-min))
  (re-search-forward "class\\(?:Name\\)?=[\"']\\([^\"']+\\)[\"']" nil t)
  (match-string 1))
```

**Issue: Sorting not working as expected**
```emacs-lisp
;; Test sorting function
(tailwindcss-sort-classes '("text-lg" "bg-white" "flex" "mt-4"))

;; Enable debug messages
(setq tailwindcss-debug t)
```

### Using edebug

To debug a function:

1. Position cursor on function definition
2. `M-x edebug-defun`
3. Call the function
4. Step through with:
   - `SPC` - step through
   - `n` - next
   - `c` - continue
   - `q` - quit

## Performance Considerations

### Optimization Tips

1. **Cache configuration file location:**
   ```emacs-lisp
   (defvar tailwindcss--config-file-cache nil)
   
   (defun tailwindcss-find-config-file ()
     (or tailwindcss--config-file-cache
         (setq tailwindcss--config-file-cache
               (locate-dominating-file default-directory 
                                       tailwindcss-config-file))))
   ```

2. **Use hash tables for large datasets:**
   ```emacs-lisp
   (defvar tailwindcss--class-hash (make-hash-table :test 'equal))
   
   (dolist (class tailwindcss-utilities-list)
     (puthash class t tailwindcss--class-hash))
   ```

3. **Lazy load heavy features:**
   ```emacs-lisp
   (autoload 'tailwindcss-advanced-feature "tailwindcss-advanced")
   ```

## Release Process

### Version Numbering

Follow Semantic Versioning (SemVer):
- MAJOR: Breaking changes
- MINOR: New features (backward compatible)
- PATCH: Bug fixes

### Checklist for Release

- [ ] Update version number in `tailwindcss.el`
- [ ] Update CHANGELOG.md
- [ ] Run all tests
- [ ] Update documentation
- [ ] Tag release in git
- [ ] Update package archives (MELPA, etc.)

### Creating a Release

```bash
# Update version
emacs tailwindcss.el  # Edit version string

# Run tests
emacs -batch -l ert -l tailwindcss.el -l elisp-tests/tailwindcss-test.el -f ert-run-tests-batch-and-exit

# Commit and tag
git add .
git commit -m "Release version X.Y.Z"
git tag -a vX.Y.Z -m "Version X.Y.Z"
git push origin main --tags
```

## Contributing

### Pull Request Process

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Update documentation
7. Submit pull request

### Code Review Criteria

- Code follows style guidelines
- Tests are included and passing
- Documentation is updated
- No breaking changes (or clearly documented)
- Performance impact is considered

## Resources

### Emacs Lisp Resources

- [GNU Emacs Lisp Reference Manual](https://www.gnu.org/software/emacs/manual/html_node/elisp/)
- [Emacs Wiki](https://www.emacswiki.org)
- [Writing GNU Emacs Extensions](https://www.oreilly.com/library/view/writing-gnu-emacs/9781565922617/)

### TailwindCSS Resources

- [TailwindCSS Documentation](https://tailwindcss.com/docs)
- [TailwindCSS GitHub](https://github.com/tailwindlabs/tailwindcss)
- [TailwindCSS Discussions](https://github.com/tailwindlabs/tailwindcss/discussions)

### Testing Resources

- [ERT Manual](https://www.gnu.org/software/emacs/manual/html_node/ert/)
- [Testing Emacs Lisp Code](https://www.emacswiki.org/emacs/UnitTesting)

## Future Enhancements

Potential areas for improvement:

1. **Full TailwindCSS v4 support**: Support for all new v4 features
2. **LSP integration**: Tighter integration with TailwindCSS language server
3. **Live preview**: Real-time preview of class effects
4. **Configuration parser**: Parse and understand config files
5. **Custom plugin support**: Load and use custom TailwindCSS plugins
6. **Documentation lookup**: Quick access to TailwindCSS docs
7. **Class suggestions**: Intelligent suggestions based on context
8. **Refactoring tools**: Bulk rename/update classes

## License

This project is licensed under the MIT License. See LICENSE file for details.

## Contact

For questions or support:
- GitHub Issues: [https://github.com/Kinneyzhang/tailwindcss/issues](https://github.com/Kinneyzhang/tailwindcss/issues)
- Discussions: [https://github.com/Kinneyzhang/tailwindcss/discussions](https://github.com/Kinneyzhang/tailwindcss/discussions)
