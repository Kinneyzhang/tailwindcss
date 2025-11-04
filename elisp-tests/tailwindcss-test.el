;;; tailwindcss-test.el --- Tests for tailwindcss.el -*- lexical-binding: t; -*-

;; Copyright (C) 2025

;; This file is not part of GNU Emacs.

;;; Commentary:

;; Tests for the TailwindCSS Emacs integration package.
;; Run with: emacs -batch -l ert -l tailwindcss.el -l tailwindcss-test.el -f ert-run-tests-batch-and-exit

;;; Code:

(require 'ert)
(require 'tailwindcss)

;;; Tests for Class Name Parsing

(ert-deftest tailwindcss-test-parse-simple-class ()
  "Test parsing a simple class name without variants."
  (let ((result (tailwindcss-parse-class-name "bg-blue-500")))
    (should (equal (plist-get result :variants) nil))
    (should (equal (plist-get result :utility) "bg-blue-500"))))

(ert-deftest tailwindcss-test-parse-class-with-variant ()
  "Test parsing a class name with a single variant."
  (let ((result (tailwindcss-parse-class-name "hover:bg-blue-500")))
    (should (equal (plist-get result :variants) '("hover")))
    (should (equal (plist-get result :utility) "bg-blue-500"))))

(ert-deftest tailwindcss-test-parse-class-with-multiple-variants ()
  "Test parsing a class name with multiple variants."
  (let ((result (tailwindcss-parse-class-name "md:hover:bg-blue-500")))
    (should (equal (plist-get result :variants) '("md" "hover")))
    (should (equal (plist-get result :utility) "bg-blue-500"))))

(ert-deftest tailwindcss-test-parse-class-with-negative-value ()
  "Test parsing a class name with negative value."
  (let ((result (tailwindcss-parse-class-name "-mt-4")))
    (should (equal (plist-get result :variants) nil))
    (should (equal (plist-get result :utility) "-mt-4"))))

(ert-deftest tailwindcss-test-parse-arbitrary-value ()
  "Test parsing a class name with arbitrary value."
  (let ((result (tailwindcss-parse-class-name "bg-[#1da1f2]")))
    (should (equal (plist-get result :variants) nil))
    (should (equal (plist-get result :utility) "bg-[#1da1f2]"))))

;;; Tests for Class Name Validation

(ert-deftest tailwindcss-test-validate-simple-class ()
  "Test validating a simple utility class."
  (should (tailwindcss-validate-class-name "container")))

(ert-deftest tailwindcss-test-validate-class-with-valid-variant ()
  "Test validating a class with valid variant."
  (should (tailwindcss-validate-class-name "hover:text-blue-500")))

(ert-deftest tailwindcss-test-validate-class-with-invalid-variant ()
  "Test validating a class with invalid variant."
  (should-not (tailwindcss-validate-class-name "invalid-variant:text-blue-500")))

(ert-deftest tailwindcss-test-validate-responsive-variant ()
  "Test validating responsive variants."
  (should (tailwindcss-validate-class-name "md:flex"))
  (should (tailwindcss-validate-class-name "lg:grid"))
  (should (tailwindcss-validate-class-name "xl:hidden")))

(ert-deftest tailwindcss-test-validate-state-variant ()
  "Test validating state variants."
  (should (tailwindcss-validate-class-name "focus:ring-2"))
  (should (tailwindcss-validate-class-name "active:bg-blue-700"))
  (should (tailwindcss-validate-class-name "disabled:opacity-50")))

(ert-deftest tailwindcss-test-validate-pseudo-class-variant ()
  "Test validating pseudo-class variants."
  (should (tailwindcss-validate-class-name "before:content-['']"))
  (should (tailwindcss-validate-class-name "after:block")))

(ert-deftest tailwindcss-test-validate-dark-mode ()
  "Test validating dark mode variant."
  (should (tailwindcss-validate-class-name "dark:bg-gray-800")))

;;; Tests for Class Extraction

(ert-deftest tailwindcss-test-extract-classes-from-html ()
  "Test extracting classes from HTML-like content."
  (with-temp-buffer
    (insert "<div class=\"flex items-center justify-between\">")
    (insert "<span className=\"text-lg font-bold\">")
    (let ((classes (tailwindcss-extract-classes-from-buffer)))
      (should (= (length classes) 5))
      (should (member "flex" classes))
      (should (member "items-center" classes))
      (should (member "justify-between" classes))
      (should (member "text-lg" classes))
      (should (member "font-bold" classes)))))

(ert-deftest tailwindcss-test-extract-classes-no-duplicates ()
  "Test that duplicate classes are removed."
  (with-temp-buffer
    (insert "<div class=\"flex\">")
    (insert "<div class=\"flex\">")
    (let ((classes (tailwindcss-extract-classes-from-buffer)))
      (should (= (length classes) 1))
      (should (equal (car classes) "flex")))))

(ert-deftest tailwindcss-test-extract-classes-empty-buffer ()
  "Test extracting classes from an empty buffer."
  (with-temp-buffer
    (let ((classes (tailwindcss-extract-classes-from-buffer)))
      (should (null classes)))))

;;; Tests for Class Sorting

(ert-deftest tailwindcss-test-sort-layout-classes ()
  "Test sorting layout classes."
  (let ((classes '("hidden" "flex" "block" "inline"))
        (sorted (tailwindcss-sort-classes '("hidden" "flex" "block" "inline"))))
    (should (equal (car sorted) "block"))
    (should (equal (cadr sorted) "inline"))
    (should (equal (caddr sorted) "flex"))))

(ert-deftest tailwindcss-test-sort-mixed-classes ()
  "Test sorting mixed classes by category."
  (let ((classes '("text-lg" "bg-blue-500" "flex" "mt-4" "border"))
        (sorted (tailwindcss-sort-classes classes)))
    ;; Layout should come before spacing
    (should (< (cl-position "flex" sorted)
               (cl-position "mt-4" sorted)))
    ;; Spacing should come before typography
    (should (< (cl-position "mt-4" sorted)
               (cl-position "text-lg" sorted)))
    ;; Typography should come before backgrounds
    (should (< (cl-position "text-lg" sorted)
               (cl-position "bg-blue-500" sorted)))))

(ert-deftest tailwindcss-test-sort-preserves-all-classes ()
  "Test that sorting preserves all classes."
  (let* ((classes '("flex" "items-center" "bg-white" "p-4" "text-sm"))
         (sorted (tailwindcss-sort-classes classes)))
    (should (= (length sorted) (length classes)))
    (dolist (class classes)
      (should (member class sorted)))))

;;; Tests for Utility Functions

(ert-deftest tailwindcss-test-format-class-list ()
  "Test formatting a list of classes."
  (let ((classes '("flex" "items-center" "justify-between")))
    (should (equal (tailwindcss-format-class-list classes)
                   "flex items-center justify-between"))))

(ert-deftest tailwindcss-test-format-empty-class-list ()
  "Test formatting an empty class list."
  (should (equal (tailwindcss-format-class-list '()) "")))

(ert-deftest tailwindcss-test-is-valid-variant-breakpoints ()
  "Test validation of breakpoint variants."
  (should (tailwindcss-is-valid-variant-p "sm"))
  (should (tailwindcss-is-valid-variant-p "md"))
  (should (tailwindcss-is-valid-variant-p "lg"))
  (should (tailwindcss-is-valid-variant-p "xl"))
  (should (tailwindcss-is-valid-variant-p "2xl"))
  (should-not (tailwindcss-is-valid-variant-p "invalid")))

(ert-deftest tailwindcss-test-is-valid-variant-states ()
  "Test validation of state variants."
  (should (tailwindcss-is-valid-variant-p "hover"))
  (should (tailwindcss-is-valid-variant-p "focus"))
  (should (tailwindcss-is-valid-variant-p "active"))
  (should (tailwindcss-is-valid-variant-p "disabled"))
  (should (tailwindcss-is-valid-variant-p "checked")))

(ert-deftest tailwindcss-test-is-valid-variant-pseudo ()
  "Test validation of pseudo-class variants."
  (should (tailwindcss-is-valid-variant-p "before"))
  (should (tailwindcss-is-valid-variant-p "after"))
  (should (tailwindcss-is-valid-variant-p "placeholder")))

(ert-deftest tailwindcss-test-is-valid-variant-responsive ()
  "Test validation of responsive variants."
  (should (tailwindcss-is-valid-variant-p "dark"))
  (should (tailwindcss-is-valid-variant-p "light"))
  (should (tailwindcss-is-valid-variant-p "motion-safe"))
  (should (tailwindcss-is-valid-variant-p "print")))

;;; Tests for Configuration

(ert-deftest tailwindcss-test-default-config-file ()
  "Test default configuration file name."
  (should (equal tailwindcss-config-file "tailwind.config.js")))

(ert-deftest tailwindcss-test-default-cli-path ()
  "Test default CLI path."
  (should (equal tailwindcss-cli-path "npx tailwindcss")))

(ert-deftest tailwindcss-test-default-completion-enabled ()
  "Test that completion is enabled by default."
  (should tailwindcss-enable-class-completion))

;;; Tests for Class Lists

(ert-deftest tailwindcss-test-utilities-list-not-empty ()
  "Test that utilities list is not empty."
  (should (> (length tailwindcss-utilities-list) 0)))

(ert-deftest tailwindcss-test-colors-list-contains-basic-colors ()
  "Test that colors list contains basic colors."
  (should (member "red" tailwindcss-colors-list))
  (should (member "blue" tailwindcss-colors-list))
  (should (member "green" tailwindcss-colors-list))
  (should (member "black" tailwindcss-colors-list))
  (should (member "white" tailwindcss-colors-list)))

(ert-deftest tailwindcss-test-breakpoints-list-complete ()
  "Test that breakpoints list contains all standard breakpoints."
  (should (equal tailwindcss-breakpoints-list
                 '("sm" "md" "lg" "xl" "2xl"))))

;;; Tests for Edge Cases

(ert-deftest tailwindcss-test-parse-empty-string ()
  "Test parsing an empty string."
  (let ((result (tailwindcss-parse-class-name "")))
    (should (equal (plist-get result :utility) ""))))

(ert-deftest tailwindcss-test-parse-class-with-numbers ()
  "Test parsing classes with numbers."
  (let ((result (tailwindcss-parse-class-name "p-4")))
    (should (equal (plist-get result :utility) "p-4")))
  (let ((result (tailwindcss-parse-class-name "text-2xl")))
    (should (equal (plist-get result :utility) "text-2xl"))))

(ert-deftest tailwindcss-test-parse-class-with-fractions ()
  "Test parsing classes with fractions."
  (let ((result (tailwindcss-parse-class-name "w-1/2")))
    (should (equal (plist-get result :utility) "w-1/2")))
  (let ((result (tailwindcss-parse-class-name "w-2/3")))
    (should (equal (plist-get result :utility) "w-2/3"))))

(ert-deftest tailwindcss-test-sort-single-class ()
  "Test sorting a single class."
  (let ((sorted (tailwindcss-sort-classes '("flex"))))
    (should (equal sorted '("flex")))))

(ert-deftest tailwindcss-test-sort-empty-list ()
  "Test sorting an empty list."
  (let ((sorted (tailwindcss-sort-classes '())))
    (should (null sorted))))

;;; Tests for Complex Scenarios

(ert-deftest tailwindcss-test-parse-class-with-important ()
  "Test parsing classes with important modifier."
  (let ((result (tailwindcss-parse-class-name "!bg-red-500")))
    (should (equal (plist-get result :utility) "!bg-red-500"))))

(ert-deftest tailwindcss-test-validate-stacked-variants ()
  "Test validating classes with stacked variants."
  (should (tailwindcss-validate-class-name "md:hover:focus:bg-blue-500")))

(ert-deftest tailwindcss-test-extract-classes-with-special-chars ()
  "Test extracting classes that contain special characters."
  (with-temp-buffer
    (insert "<div class=\"hover:bg-[#1da1f2] w-1/2\">")
    (let ((classes (tailwindcss-extract-classes-from-buffer)))
      (should (member "hover:bg-[#1da1f2]" classes))
      (should (member "w-1/2" classes)))))

(ert-deftest tailwindcss-test-generate-class-list ()
  "Test generating class list."
  (let ((classes (tailwindcss-generate-class-list)))
    (should (> (length classes) 0))
    (should (member "container" classes))
    ;; Should contain color variants
    (should (member "text-blue" classes))
    (should (member "bg-red" classes))))

;;; Run all tests

(provide 'tailwindcss-test)

;;; tailwindcss-test.el ends here
