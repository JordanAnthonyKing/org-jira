;;; org-jira-t.el --- ERT tests

;; Copyright (C) 2017 Matthew Carter <m@ahungry.com>
;;
;; Authors:
;; Matthew Carter <m@ahungry.com>
;;
;; Maintainer: Matthew Carter <m@ahungry.com>
;; URL: https://github.com/ahungry/org-jira
;; Version: 2.6.2
;; Keywords: ahungry jira org bug tracker
;; Package-Requires: ((emacs "24.5") (cl-lib "0.5") (request "0.2.0"))

;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see
;; <http://www.gnu.org/licenses/> or write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
;; 02110-1301, USA.

;;; Commentary:

;; This tests the extension to org-mode for syncing issues with JIRA
;; issue servers.

;;; News:

;;;; Changes since 0.0.0:
;; - Add some basic tests

;;; Code:

(require 'org-jira)

(ert-deftest org-jira-date-strip-letter-t-test ()
  (should
   (string= "2017-01-01 00:00:00.000-0500"
            (org-jira-date-strip-letter-t "2017-01-01T00:00:00.000-0500")))
  )

(ert-deftest org-jira-date-to-org-clock-test ()
  (should
   (string= "2017-01-01 Sun 00:00"
            (org-jira-date-to-org-clock "2017-01-01T00:00:00.000-0500")))
  (should
   (string= "2017-02-05 Sun 00:00"
            (org-jira-date-to-org-clock "2017-02-05T00:00:00.000-0500")))
  )

(ert-deftest org-jira-time-stamp-to-org-clock-test ()
  (should
   (string= "2016-12-31 Sat 19:05"
            (org-jira-time-stamp-to-org-clock '(22632 18348))))
  )

(defvar org-jira-worklog-fixture-response
  '((startAt . 0)
    (maxResults . 2)
    (total . 2)
    (worklogs .
              [((self . "https://example.com/rest/api/2/issue/10402/worklog/10101")
                (author
                 (self . "https://example.com/rest/api/2/user?username=admin")
                 (name . "admin")
                 (key . "admin")
                 (accountId . "omitted")
                 (emailAddress . "m@example.com")
                 (avatarUrls
                  (48x48 . "https://avatar-cdn.atlassian.com/12345?s=48&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F12345%3Fd%3Dmm%26s%3D48%26noRedirect%3Dtrue")
                  (24x24 . "https://avatar-cdn.atlassian.com/12345?s=24&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F12345%3Fd%3Dmm%26s%3D24%26noRedirect%3Dtrue")
                  (16x16 . "https://avatar-cdn.atlassian.com/12345?s=16&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F12345%3Fd%3Dmm%26s%3D16%26noRedirect%3Dtrue")
                  (32x32 . "https://avatar-cdn.atlassian.com/12345?s=32&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F12345%3Fd%3Dmm%26s%3D32%26noRedirect%3Dtrue"))
                 (displayName . "Matthew Carter")
                 (active . t)
                 (timeZone . "America/New_York"))
                (updateAuthor
                 (self . "https://example.com/rest/api/2/user?username=admin")
                 (name . "admin")
                 (key . "admin")
                 (accountId . "omitted")
                 (emailAddress . "m@example.com")
                 (avatarUrls
                  (48x48 . "https://avatar-cdn.atlassian.com/12345?s=48&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F12345%3Fd%3Dmm%26s%3D48%26noRedirect%3Dtrue")
                  (24x24 . "https://avatar-cdn.atlassian.com/12345?s=24&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F12345%3Fd%3Dmm%26s%3D24%26noRedirect%3Dtrue")
                  (16x16 . "https://avatar-cdn.atlassian.com/12345?s=16&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F12345%3Fd%3Dmm%26s%3D16%26noRedirect%3Dtrue")
                  (32x32 . "https://avatar-cdn.atlassian.com/12345?s=32&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F12345%3Fd%3Dmm%26s%3D32%26noRedirect%3Dtrue"))
                 (displayName . "Matthew Carter")
                 (active . t)
                 (timeZone . "America/New_York"))
                (comment . "Some comment here")
                (created . "2017-02-27T23:47:04.261-0500")
                (updated . "2017-02-27T23:47:04.261-0500")
                (started . "2017-02-26T00:08:00.000-0500")
                (timeSpent . "1h")
                (timeSpentSeconds . 3600)
                (id . "10101")
                (issueId . "10402"))
               ((self . "https://example.com/rest/api/2/issue/10402/worklog/10200")
                (author
                 (self . "https://example.com/rest/api/2/user?username=admin")
                 (name . "admin")
                 (key . "admin")
                 (accountId . "omitted")
                 (emailAddress . "m@example.com")
                 (avatarUrls
                  (48x48 . "https://avatar-cdn.atlassian.com/12345?s=48&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F12345%3Fd%3Dmm%26s%3D48%26noRedirect%3Dtrue")
                  (24x24 . "https://avatar-cdn.atlassian.com/12345?s=24&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F12345%3Fd%3Dmm%26s%3D24%26noRedirect%3Dtrue")
                  (16x16 . "https://avatar-cdn.atlassian.com/12345?s=16&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F12345%3Fd%3Dmm%26s%3D16%26noRedirect%3Dtrue")
                  (32x32 . "https://avatar-cdn.atlassian.com/12345?s=32&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F12345%3Fd%3Dmm%26s%3D32%26noRedirect%3Dtrue"))
                 (displayName . "Matthew Carter")
                 (active . t)
                 (timeZone . "America/New_York"))
                (updateAuthor
                 (self . "https://example.com/rest/api/2/user?username=admin")
                 (name . "admin")
                 (key . "admin")
                 (accountId . "omitted")
                 (emailAddress . "m@example.com")
                 (avatarUrls
                  (48x48 . "https://avatar-cdn.atlassian.com/12345?s=48&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F12345%3Fd%3Dmm%26s%3D48%26noRedirect%3Dtrue")
                  (24x24 . "https://avatar-cdn.atlassian.com/12345?s=24&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F12345%3Fd%3Dmm%26s%3D24%26noRedirect%3Dtrue")
                  (16x16 . "https://avatar-cdn.atlassian.com/12345?s=16&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F12345%3Fd%3Dmm%26s%3D16%26noRedirect%3Dtrue")
                  (32x32 . "https://avatar-cdn.atlassian.com/12345?s=32&d=https%3A%2F%2Fsecure.gravatar.com%2Favatar%2F12345%3Fd%3Dmm%26s%3D32%26noRedirect%3Dtrue"))
                 (displayName . "Matthew Carter")
                 (active . t)
                 (timeZone . "America/New_York"))
                (comment . "Add 32 minutes")
                (created . "2017-03-16T23:25:45.396-0400")
                (updated . "2017-03-16T23:25:45.396-0400")
                (started . "2017-03-16T22:25:00.000-0400")
                (timeSpent . "32m")
                (timeSpentSeconds . 1920)
                (id . "10200")
                (issueId . "10402"))]))
  "A sample response, as served from the #'jiralib-get-worklogs call.")

(ert-deftest org-jira-worklogs-to-org-clocks-test ()
  (let ((result (org-jira-worklogs-to-org-clocks
                 (cdr (assoc 'worklogs org-jira-worklog-fixture-response)))))
    (should
     (string= "2017-02-26 Sun 00:08"
              (caar result)))
    (should
     (string= "2017-02-26 Sun 01:08"
              (cadar result)))
    (should
     (string= "2017-03-16 Thu 22:25"
              (caadr result)))
    (should
     (string= "2017-03-16 Thu 22:57"
              (cadadr result)))
    ))

(ert-deftest org-jira-format-clock-test ()
    (should
     (string= "CLOCK: [2017-02-26 Sun 00:08]--[2017-02-26 Sun 01:08]"
              (org-jira-format-clock '("2017-02-26 Sun 00:08" "2017-02-26 Sun 01:08")))))

(provide 'org-jira-t)
;;; org-jira-t.el ends here