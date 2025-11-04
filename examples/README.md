# TailwindCSS Emacs Integration - Examples

This directory contains example configurations and usage demonstrations for the TailwindCSS Emacs integration.

## Files

### Configuration Examples

#### `basic-config.el`
A minimal configuration suitable for getting started quickly. Includes:
- Basic package loading
- Mode hooks for HTML, JavaScript, and TypeScript
- Simple customization settings
- Essential key bindings

**Use this if:** You want a simple setup with minimal dependencies.

#### `advanced-config.el`
A comprehensive configuration showing integration with popular Emacs packages. Includes:
- `use-package` configuration
- Integration with Company mode (code completion)
- LSP mode support
- web-mode integration
- Flycheck support
- Hydra menu for quick command access
- Custom helper functions
- Performance optimizations

**Use this if:** You want full-featured IDE-like experience with TailwindCSS.

### Usage Examples

#### `usage-examples.html`
An HTML file demonstrating various TailwindCSS patterns that work well with the Emacs integration. Includes examples of:
- Flex and Grid layouts
- Forms and inputs
- Responsive navigation
- State variants (hover, focus, active)
- Dark mode support
- Animations and transitions
- Responsive typography
- Complex layouts

**Use this to:** Practice using TailwindCSS commands in Emacs and see real-world patterns.

## How to Use

### Using the Configuration Files

1. **Copy the configuration you want to use:**
   ```bash
   cp examples/basic-config.el ~/.emacs.d/init-tailwindcss.el
   ```

2. **Load it in your main Emacs configuration:**
   ```emacs-lisp
   ;; In ~/.emacs or ~/.emacs.d/init.el
   (load-file "~/.emacs.d/init-tailwindcss.el")
   ```

3. **Or include it directly:**
   ```emacs-lisp
   ;; Copy the contents of basic-config.el or advanced-config.el
   ;; into your main configuration file
   ```

### Using the Example HTML File

1. **Open the file in Emacs:**
   ```bash
   emacs examples/usage-examples.html
   ```

2. **Enable TailwindCSS mode:**
   ```
   M-x tailwindcss-mode
   ```

3. **Try the commands:**
   - List classes: `M-x tailwindcss-list-classes`
   - Validate: `M-x tailwindcss-validate-buffer`
   - Sort classes: Select a class attribute, then `M-x tailwindcss-sort-classes-in-region`

## Customization Tips

### Adding Project-Specific Settings

Create a `.dir-locals.el` file in your project root:

```emacs-lisp
((html-mode . ((tailwindcss-cli-path . "npm run build:css")))
 (web-mode . ((tailwindcss-mode . t)
              (eval . (setq-local tailwindcss-config-file "tailwind.config.ts")))))
```

### Custom Snippets

Create TailwindCSS snippets for yasnippet:

**File: `~/.emacs.d/snippets/html-mode/tw-flex`**
```
# -*- mode: snippet -*-
# name: Flex container
# key: flex
# --
<div class="flex items-center justify-${1:between} ${2:gap-4}">
  $0
</div>
```

**File: `~/.emacs.d/snippets/html-mode/tw-card`**
```
# -*- mode: snippet -*-
# name: Card component
# key: card
# --
<div class="bg-white rounded-lg shadow-${1:md} p-${2:6}">
  <h3 class="text-${3:xl} font-${4:bold} mb-4">${5:Title}</h3>
  <p class="text-gray-600">$0</p>
</div>
```

### Custom Key Bindings

Add to your configuration:

```emacs-lisp
;; Quick access to common patterns
(defun my-tw-insert-container ()
  "Insert a container div."
  (interactive)
  (insert "<div class=\"container mx-auto px-4\">\n  \n</div>")
  (forward-line -1)
  (indent-according-to-mode))

(define-key tailwindcss-mode-map (kbd "C-c i c") 'my-tw-insert-container)
```

### Project Templates

Create a template for new projects:

```bash
# Create template directory
mkdir -p ~/.emacs.d/templates/tailwind-project

# Add files
touch ~/.emacs.d/templates/tailwind-project/index.html
touch ~/.emacs.d/templates/tailwind-project/tailwind.config.js
touch ~/.emacs.d/templates/tailwind-project/.dir-locals.el
```

Then use projectile or another project manager to create projects from the template.

## Common Workflows

### Starting a New Component

1. Open your HTML/JSX file
2. Enable TailwindCSS mode: `M-x tailwindcss-mode`
3. Use completion to add classes: Start typing and press `M-TAB`
4. Validate classes: `M-x tailwindcss-validate-buffer`
5. Sort classes if needed: Select and `M-x tailwindcss-sort-classes-in-region`

### Refactoring Classes

1. Use `query-replace` to change class names: `M-%`
2. Validate after changes: `M-x tailwindcss-validate-buffer`
3. Review all classes: `M-x tailwindcss-list-classes`

### Building for Production

1. Open any file in your project
2. Run: `M-x tailwindcss-build`
3. Watch the compilation buffer for results
4. If errors occur, the compilation buffer will show details

## Integration Examples

### With Org Mode

Use TailwindCSS in Org mode HTML exports:

```emacs-lisp
(add-hook 'org-mode-hook
          (lambda ()
            (when (string-suffix-p ".org" buffer-file-name)
              (tailwindcss-mode 1))))
```

### With Multiple Projects

Use directory-local variables:

**Project A: `.dir-locals.el`**
```emacs-lisp
((nil . ((eval . (setq-local tailwindcss-cli-path "npm run dev:css")))))
```

**Project B: `.dir-locals.el`**
```emacs-lisp
((nil . ((eval . (setq-local tailwindcss-cli-path "yarn build:css")))))
```

### With Docker

If your TailwindCSS is in Docker:

```emacs-lisp
(setq tailwindcss-cli-path "docker-compose exec web npx tailwindcss")
```

## Troubleshooting

### Classes Not Completing

Check:
1. `tailwindcss-mode` is enabled
2. `tailwindcss-enable-class-completion` is `t`
3. `completion-at-point-functions` includes `tailwindcss-completion-at-point`

### Validation False Positives

If custom classes are marked as invalid:

```emacs-lisp
;; Add to your configuration
(setq tailwindcss-utilities-list
      (append tailwindcss-utilities-list
              '("your-custom-class")))
```

### Build Not Working

Ensure:
1. TailwindCSS is installed in your project
2. `tailwindcss-cli-path` points to the correct executable
3. You're in a directory with a `tailwind.config.js` file

## Additional Resources

- [Main Documentation](../EMACS-LISP-README.md)
- [Development Guide](../DEVELOPMENT.md)
- [Quick Start](../QUICKSTART.md)
- [Chinese Documentation](../README-zh.md)

## Contributing Examples

Have a great configuration or workflow? Please contribute!

1. Create your example file
2. Add documentation
3. Submit a pull request

Examples we'd love to see:
- React/Vue/Svelte specific configurations
- Integration with other Emacs packages
- Custom utility functions
- Workflow automations
- Theme-specific setups

## License

These examples are provided under the same MIT license as the main project.
