<p align="center">
  <a href="https://tailwindcss.com" target="_blank">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/tailwindlabs/tailwindcss/HEAD/.github/logo-dark.svg">
      <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/tailwindlabs/tailwindcss/HEAD/.github/logo-light.svg">
      <img alt="Tailwind CSS" src="https://raw.githubusercontent.com/tailwindlabs/tailwindcss/HEAD/.github/logo-light.svg" width="350" height="70" style="max-width: 100%;">
    </picture>
  </a>
</p>

<p align="center">
  A utility-first CSS framework for rapidly building custom user interfaces.
</p>

<p align="center">
    <a href="https://github.com/tailwindlabs/tailwindcss/actions"><img src="https://img.shields.io/github/actions/workflow/status/tailwindlabs/tailwindcss/ci.yml?branch=next" alt="Build Status"></a>
    <a href="https://www.npmjs.com/package/tailwindcss"><img src="https://img.shields.io/npm/dt/tailwindcss.svg" alt="Total Downloads"></a>
    <a href="https://github.com/tailwindcss/tailwindcss/releases"><img src="https://img.shields.io/npm/v/tailwindcss.svg" alt="Latest Release"></a>
    <a href="https://github.com/tailwindcss/tailwindcss/blob/master/LICENSE"><img src="https://img.shields.io/npm/l/tailwindcss.svg" alt="License"></a>
</p>

---

## Emacs Lisp Integration

This repository includes a complete Emacs Lisp implementation for TailwindCSS integration! 🎉

### Features

- ✨ Syntax highlighting for TailwindCSS configuration files
- 🔍 Class name validation and completion
- 📝 Auto-completion for utility classes
- 🔨 CLI integration for building TailwindCSS
- 📦 Class sorting according to recommended order
- 🎯 Quick navigation to config files

### Quick Start

```emacs-lisp
;; Add to your ~/.emacs or ~/.emacs.d/init.el
(add-to-list 'load-path "/path/to/tailwindcss")
(require 'tailwindcss)

;; Enable in HTML and JavaScript files
(add-hook 'html-mode-hook 'tailwindcss-mode)
(add-hook 'js-mode-hook 'tailwindcss-mode)
```

### Documentation

- **English**: [EMACS-LISP-README.md](EMACS-LISP-README.md)
- **中文**: [README-zh.md](README-zh.md)
- **Quick Start**: [QUICKSTART.md](QUICKSTART.md)
- **Development**: [DEVELOPMENT.md](DEVELOPMENT.md)
- **Examples**: [examples/](examples/)

### Main Commands

- `M-x tailwindcss-mode` - Enable TailwindCSS mode
- `M-x tailwindcss-build` - Build TailwindCSS
- `M-x tailwindcss-list-classes` - List all classes in buffer
- `M-x tailwindcss-validate-buffer` - Validate class names
- `M-x tailwindcss-sort-classes-in-region` - Sort selected classes
- `M-x tailwindcss-open-config` - Open configuration file

---

## TailwindCSS Framework Documentation

For full TailwindCSS framework documentation, visit [tailwindcss.com](https://tailwindcss.com).

## Community

For help, discussion about best practices, or feature ideas:

[Discuss Tailwind CSS on GitHub](https://github.com/tailwindcss/tailwindcss/discussions)

## Contributing

If you're interested in contributing to Tailwind CSS, please read our [contributing docs](https://github.com/tailwindcss/tailwindcss/blob/next/.github/CONTRIBUTING.md) **before submitting a pull request**.
