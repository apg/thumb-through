;;; thumb-through.el --- Plain text reader of HTML documents

;; Copyright (C) 2010 Andrew Gwozdziewycz <git@apgwoz.com>

;; Version: 0.1
;; Keywords: html

;; This file is NOT part of GNU Emacs

;; This is free software; you can redistribute it and/or modify it under
;; the terms of the GNU General Public License as published by the Free
;; Software Foundation; either version 3, or (at your option) any later
;; version.

;; This is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Installation

;; requires curl
;; requires http://www.aaronsw.com/2002/html2text/html2text.py
;; edit thumb-through-html2text-command to be the location of html2text

(require 'thingatpt)

(defconst thumb-through-curl-command (executable-find "curl"))

(defconst thumb-through-html2text-command "/Users/me/bin/html2text.py")

(defconst thumb-through-instapaper-base-url 
  "http://www.instapaper.com/text?u=")


(defun thumb-through-get-url ()
  (or (thing-at-point 'url) (read-string "URL: ")))

(defun thumb-through-get-page (url)
  "Returns an XML version of the URL or nil on any sort of failure"
  ;; need to validate this as a url
  (let ((command (concat "(" thumb-through-curl-executable " "
                         (concat thumb-through-instapaper-base-url 
                                 (url-hexify-string url))
                         " | "
                         thumb-through-html2text-command ")"
                         " 2> /dev/null")))
    (shell-command-to-string command)))

(defun thumb-through ()
  (interactive)
  (let ((url (thumb-through-get-url)))
    (if url
        (with-current-buffer (get-buffer-create "*thumb-through-output*")
          (let ((contents (thumb-through-get-page url)))
            (kill-region (point-min) (point-max))
            (insert contents)
            (switch-to-buffer (current-buffer))))
      (message "No url found."))))

(defun thumb-through-region (begin end)
  (interactive "r")
  (thumb-through (buffer-substring begin end)))

