# Notification Templates

Keystone issues automated notifications alerting users to system changes and platform events.
Administrators can customize these notifications using templates to reflect organization-specific branding and
messaging.

## Overriding Templates

Keystone renders HTML notifications using the Jinja2 templating engine.
The location of custom templates is configurable via [application settings](api_settings.md).

When a notification is triggered, Keystone first checks for a custom template file.
If no custom template is available, Keystone falls back to an internal default.
The selected template is then rendered using the context data outlined below.

Email notification templates can be rendered and written to disk using the `keystone-api render_templates` command.
It is strongly recommended to develop and test templates locally before deploying them to a production environment.
See `keystone-api render_templates --help` for details.

### Template Security

Template files are required to have no write permissions for users other than the owner or group (i.e., `o+w`).
If a template file has world-writeable permissions, Keystone will refuse to load it.
This restriction is provided for security and ensures templates cannot be modified by unauthorized users in production.

Notification templates are automatically sanitized to remove any JavaScript or externally loaded resources (e.g. CSS
imports).
Users familiar with the Jinja2 templating engine will also find certain Jinja features are not available, including
access to application internals and the ability to bypass variable sanitation.

## Templates

The following templates are available for customization.

### Common Fields

The following fields are available to all notification templates.

??? info "Available Template Fields"

    | Field Name       | Type    | Description                                                       |
    |------------------|---------|-------------------------------------------------------------------|
    | `frontend_url`   | `str`   | Base URL of the frontend application, without a trailing slash.   |

All templates rendered for a specific user additionally receive the fields below.

??? info "Available Template Fields"

    | Field Name     | Type    | Description                        |
    |----------------|---------|------------------------------------|
    | `user_name`    | `str`   | Username of the notified user.     |
    | `user_first`   | `str`   | First name of the notified user.   |
    | `user_last`    | `str`   | Last name of the notified user.    |

Templates triggered by a change to a database record also receive the fields below.

??? info "Available Template Fields"

    | Field Name          | Type         | Description                                               |
    |---------------------|--------------|-----------------------------------------------------------|
    | `actor_username`    | `str`        | Username of the user who performed the recorded action.   |
    | `record_modified`   | `datetime`   | Date and time when the record was modified.               |

### Base Template

**Template file:** `base.html`

The base template serves as the parent layout for all notification content, providing top-level styling and structure.
The template defines two content blocks that child templates override to inject content.

??? info "Available Template Fields"

    | Block Name   | Description                                              |
    |--------------|----------------------------------------------------------|
    | `main`       | Main body content of the email notification.             |
    | `footer`     | Footer content displayed at the bottom of the message.   |

??? abstract "Default Template Content"

    ```html
    --8<-- "submodules/keystone-api/keystone_api/templates/base.html"
    ```

### General Notification

**Template file:** `general.html`

The _general_ notification is used for one-off and administratively issued messages.
The message body is provided by the notification sender and rendered as the entire content of the email.

??? info "Available Template Fields"

    | Field Name     | Type    | Description                               |
    |----------------|---------|-------------------------------------------|
    | `user_name`    | `str`   | Username of the notified user.            |
    | `user_first`   | `str`   | First name of the notified user.          |
    | `user_last`    | `str`   | Last name of the notified user.           |
    | `message`      | `str`   | Body of the message sent to the user.     |

??? abstract "Default Template Content"

    ```html
    --8<-- "submodules/keystone-api/keystone_api/templates/general.html"
    ```

### New Grant Record

**Template file:** `grant_created.html`

The _grant created_ notification alerts team members that a new grant record has been added to their team.
A summary of the new record is included in the message body.

??? info "Available Template Fields"

    | Field Name          | Type               | Description                                                      |
    |---------------------|--------------------|------------------------------------------------------------------|
    | `user_name`         | `str`              | Username of the notified user.                                   |
    | `user_first`        | `str`              | First name of the notified user.                                 |
    | `user_last`         | `str`              | Last name of the notified user.                                  |
    | `team_name`         | `str`              | Name of the team the notification was issued for.                |
    | `actor_username`    | `str`              | Username of the user who created the grant record.               |
    | `record_modified`   | `datetime`         | Date and time when the grant record was created.                 |
    | `grant_title`       | `str`              | Title of the grant.                                              |
    | `grant_agency`      | `str`              | Name of the agency funding the grant.                            |
    | `grant_number`      | `str` or `None`    | Identification number assigned to the grant by the agency.       |
    | `grant_pi`          | `str` or `None`    | Name of the principal investigator.                              |
    | `grant_amount`      | `float`            | Total amount awarded under the grant.                            |
    | `grant_start`       | `date`             | Date when the grant period begins.                               |
    | `grant_end`         | `date` or `None`   | Date when the grant period ends.                                 |
    | `grant_team`        | `str`              | Name of the team associated with the grant.                      |

??? abstract "Default Template Content"

    ```html
    --8<-- "submodules/keystone-api/keystone_api/templates/grant_created.html"
    ```

### Modified Grant Record

**Template file:** `grant_modified.html`

The _grant modified_ notification alerts team members that an existing grant record has been updated.
The message body reflects the state of the record after the modification was applied.

??? info "Available Template Fields"

    | Field Name          | Type               | Description                                                  |
    |---------------------|--------------------|--------------------------------------------------------------|
    | `user_name`         | `str`              | Username of the notified user.                               |
    | `user_first`        | `str`              | First name of the notified user.                             |
    | `user_last`         | `str`              | Last name of the notified user.                              |
    | `team_name`         | `str`              | Name of the team the notification was issued for.            |
    | `actor_username`    | `str`              | Username of the user who modified the grant record.          |
    | `record_modified`   | `datetime`         | Date and time when the grant record was modified.            |
    | `grant_id`          | `int`              | ID of the modified grant record.                             |
    | `grant_title`       | `str`              | Title of the grant.                                          |
    | `grant_agency`      | `str`              | Name of the agency funding the grant.                        |
    | `grant_number`      | `str` or `None`    | Identification number assigned to the grant by the agency.   |
    | `grant_pi`          | `str` or `None`    | Name of the principal investigator.                          |
    | `grant_amount`      | `float`            | Total amount awarded under the grant.                        |
    | `grant_start`       | `date`             | Date when the grant period begins.                           |
    | `grant_end`         | `date` or `None`   | Date when the grant period ends.                             |
    | `grant_team`        | `str`              | Name of the team associated with the grant.                  |

??? abstract "Default Template Content"

    ```html
    --8<-- "submodules/keystone-api/keystone_api/templates/grant_modified.html"
    ```

### Deleted Grant Record

**Template file:** `grant_deleted.html`

The _grant deleted_ notification alerts team members that a grant record has been removed from their team.
Only identifying details of the deleted record are available to the template.

??? info "Available Template Fields"

    | Field Name          | Type         | Description                                          |
    |---------------------|--------------|------------------------------------------------------|
    | `user_name`         | `str`        | Username of the notified user.                       |
    | `user_first`        | `str`        | First name of the notified user.                     |
    | `user_last`         | `str`        | Last name of the notified user.                      |
    | `team_name`         | `str`        | Name of the team the notification was issued for.    |
    | `actor_username`    | `str`        | Username of the user who deleted the grant record.   |
    | `record_modified`   | `datetime`   | Date and time when the grant record was deleted.     |
    | `grant_id`          | `int`        | ID of the deleted grant record.                      |
    | `grant_title`       | `str`        | Title of the deleted grant.                          |

??? abstract "Default Template Content"

    ```html
    --8<-- "submodules/keystone-api/keystone_api/templates/grant_deleted.html"
    ```

### New Publication Record

**Template file:** `publication_created.html`

The _publication created_ notification alerts team members that a new publication record has been added to their team.
A summary of the new record is included in the message body.

??? info "Available Template Fields"

    | Field Name                | Type               | Description                                                |
    |---------------------------|--------------------|------------------------------------------------------------|
    | `user_name`               | `str`              | Username of the notified user.                             |
    | `user_first`              | `str`              | First name of the notified user.                           |
    | `user_last`               | `str`              | Last name of the notified user.                            |
    | `team_name`               | `str`              | Name of the team the notification was issued for.          |
    | `actor_username`          | `str`              | Username of the user who created the publication record.   |
    | `record_modified`         | `datetime`         | Date and time when the publication record was created.     |
    | `publication_title`       | `str`              | Title of the publication.                                  |
    | `publication_journal`     | `str` or `None`    | Name of the journal the publication appears in.            |
    | `publication_volume`      | `str` or `None`    | Journal volume the publication appears in.                 |
    | `publication_issue`       | `str` or `None`    | Journal issue the publication appears in.                  |
    | `publication_doi`         | `str` or `None`    | Digital Object Identifier assigned to the publication.     |
    | `publication_submitted`   | `date` or `None`   | Date when the publication was submitted.                   |
    | `publication_published`   | `date` or `None`   | Date when the publication was published.                   |
    | `publication_team`        | `str`              | Name of the team associated with the publication.          |

??? abstract "Default Template Content"

    ```html
    --8<-- "submodules/keystone-api/keystone_api/templates/publication_created.html"
    ```

### Modified Publication Record

**Template file:** `publication_modified.html`

The _publication modified_ notification alerts team members that an existing publication record has been updated.
The message body reflects the state of the record after the modification was applied.

??? info "Available Template Fields"

    | Field Name                | Type               | Description                                                 |
    |---------------------------|--------------------|-------------------------------------------------------------|
    | `user_name`               | `str`              | Username of the notified user.                              |
    | `user_first`              | `str`              | First name of the notified user.                            |
    | `user_last`               | `str`              | Last name of the notified user.                             |
    | `team_name`               | `str`              | Name of the team the notification was issued for.           |
    | `actor_username`          | `str`              | Username of the user who modified the publication record.   |
    | `record_modified`         | `datetime`         | Date and time when the publication record was modified.     |
    | `publication_id`          | `int`              | ID of the modified publication record.                      |
    | `publication_title`       | `str`              | Title of the publication.                                   |
    | `publication_journal`     | `str` or `None`    | Name of the journal the publication appears in.             |
    | `publication_volume`      | `str` or `None`    | Journal volume the publication appears in.                  |
    | `publication_issue`       | `str` or `None`    | Journal issue the publication appears in.                   |
    | `publication_doi`         | `str` or `None`    | Digital Object Identifier assigned to the publication.      |
    | `publication_submitted`   | `date` or `None`   | Date when the publication was submitted.                    |
    | `publication_published`   | `date` or `None`   | Date when the publication was published.                    |
    | `publication_team`        | `str`              | Name of the team associated with the publication.           |

??? abstract "Default Template Content"

    ```html
    --8<-- "submodules/keystone-api/keystone_api/templates/publication_modified.html"
    ```

### Deleted Publication Record

**Template file:** `publication_deleted.html`

The _publication deleted_ notification alerts team members that a publication record has been removed from their team.
Only identifying details of the deleted record are available to the template.

??? info "Available Template Fields"

    | Field Name            | Type         | Description                                                |
    |-----------------------|--------------|------------------------------------------------------------|
    | `user_name`           | `str`        | Username of the notified user.                             |
    | `user_first`          | `str`        | First name of the notified user.                           |
    | `user_last`           | `str`        | Last name of the notified user.                            |
    | `team_name`           | `str`        | Name of the team the notification was issued for.          |
    | `actor_username`      | `str`        | Username of the user who deleted the publication record.   |
    | `record_modified`     | `datetime`   | Date and time when the publication record was deleted.     |
    | `publication_id`      | `int`        | ID of the deleted publication record.                      |
    | `publication_title`   | `str`        | Title of the deleted publication.                          |

??? abstract "Default Template Content"

    ```html
    --8<-- "submodules/keystone-api/keystone_api/templates/publication_deleted.html"
    ```

### New Allocation Request

**Template file:** `request_created.html`

The _request created_ notification alerts users that a new resource allocation request has been submitted on behalf of
their team.
The message body includes a snapshot of the request as it was submitted, including the service units requested on each
cluster.

??? info "Available Template Fields"

    | Field Name            | Type               | Description                                                            |
    |-----------------------|--------------------|------------------------------------------------------------------------|
    | `user_name`           | `str`              | Username of the notified user.                                         |
    | `user_first`          | `str`              | First name of the notified user.                                       |
    | `user_last`           | `str`              | Last name of the notified user.                                        |
    | `actor_username`      | `str`              | Username of the user who submitted the request.                        |
    | `record_modified`     | `datetime`         | Date and time when the request was submitted.                          |
    | `req_id`              | `int`              | ID of the allocation request being notified about.                     |
    | `req_title`           | `str`              | Title of the allocation request.                                       |
    | `req_team`            | `str`              | Name of the team associated with the allocation request.               |
    | `req_status`          | `str`              | Human readable status of the allocation request.                       |
    | `req_submitter`       | `str`              | Username of the user the request was submitted by.                     |
    | `req_submitted`       | `date` or `None`   | Date when the allocation request was submitted.                        |
    | `req_active`          | `date` or `None`   | Date when the allocation request becomes active.                       |
    | `req_expire`          | `date` or `None`   | Date when the allocation request expires.                              |
    | `allocations`         | `list[dict]`       | List of allocated resources tied to the request. Each item includes:   |
    | ├ `alloc_cluster`     | `str`              | Name of the cluster where the resource is allocated.                   |
    | └ `alloc_requested`   | `int`              | Number of service units requested (or `0` if unavailable).             |

??? abstract "Default Template Content"

    ```html
    --8<-- "submodules/keystone-api/keystone_api/templates/request_created.html"
    ```

### Reviewer Assigned

**Template file:** `request_reviewer_assigned.html`

The _reviewer assigned_ notification alerts a staff user that they have been assigned as a reviewer for a resource
allocation request.
In addition to a snapshot of the request, the message lists any other reviewers assigned to the same request so
reviewers can coordinate their work.

??? info "Available Template Fields"

    | Field Name            | Type               | Description                                                            |
    |-----------------------|--------------------|------------------------------------------------------------------------|
    | `user_name`           | `str`              | Username of the notified user.                                         |
    | `user_first`          | `str`              | First name of the notified user.                                       |
    | `user_last`           | `str`              | Last name of the notified user.                                        |
    | `actor_username`      | `str`              | Username of the user who made the reviewer assignment.                 |
    | `record_modified`     | `datetime`         | Date and time when the assignment was made.                            |
    | `req_id`              | `int`              | ID of the allocation request being notified about.                     |
    | `req_title`           | `str`              | Title of the allocation request.                                       |
    | `req_team`            | `str`              | Name of the team associated with the allocation request.               |
    | `req_status`          | `str`              | Human readable status of the allocation request.                       |
    | `req_submitter`       | `str`              | Username of the user the request was submitted by.                     |
    | `req_submitted`       | `date` or `None`   | Date when the allocation request was submitted.                        |
    | `req_active`          | `date` or `None`   | Date when the allocation request becomes active.                       |
    | `req_expire`          | `date` or `None`   | Date when the allocation request expires.                              |
    | `req_coassignees`     | `list[str]`        | Usernames of any other reviewers assigned to the request.              |
    | `allocations`         | `list[dict]`       | List of allocated resources tied to the request. Each item includes:   |
    | ├ `alloc_cluster`     | `str`              | Name of the cluster where the resource is allocated.                   |
    | └ `alloc_requested`   | `int`              | Number of service units requested (or `0` if unavailable).             |

??? abstract "Default Template Content"

    ```html
    --8<-- "submodules/keystone-api/keystone_api/templates/request_reviewer_assigned.html"
    ```

### New Request Comment

**Template file:** `request_comment_created.html`

The _comment created_ notification alerts users that a new comment has been posted on a resource allocation request.
The comment body is rendered as written and the template indicates whether the comment was marked private to staff
reviewers.

??? info "Available Template Fields"

    | Field Name            | Type                   | Description                                                |
    |-----------------------|------------------------|------------------------------------------------------------|
    | `user_name`           | `str`                  | Username of the notified user.                             |
    | `user_first`          | `str`                  | First name of the notified user.                           |
    | `user_last`           | `str`                  | Last name of the notified user.                            |
    | `actor_username`      | `str`                  | Username of the user who posted the comment.               |
    | `record_modified`     | `datetime`             | Date and time when the comment was posted.                 |
    | `req_id`              | `int`                  | ID of the allocation request being notified about.         |
    | `req_title`           | `str`                  | Title of the allocation request.                           |
    | `req_team`            | `str`                  | Name of the team associated with the allocation request.   |
    | `req_status`          | `str`                  | Human readable status of the allocation request.           |
    | `comment_user`        | `str`                  | Username of the comment author.                            |
    | `comment_content`     | `str`                  | Body of the comment as it was written.                     |
    | `comment_created`     | `datetime` or `None`   | Date and time when the comment was created.                |
    | `comment_private`     | `bool`                 | Whether the comment is only visible to staff reviewers.    |

??? abstract "Default Template Content"

    ```html
    --8<-- "submodules/keystone-api/keystone_api/templates/request_comment_created.html"
    ```

### Request Status Change

**Template file:** `request_status_changed.html`

The _status changed_ notification alerts users that the status of a resource allocation request has changed.
The default template branches on the `req_status_code` field to render dedicated messaging for approved (`AP`),
declined (`DC`), and changes requested (`CR`) requests, and falls back to a generic message describing the old and new
status for all other transitions.

??? info "Available Template Fields"

    | Field Name           | Type                  | Description                                                              |
    |----------------------|-----------------------|--------------------------------------------------------------------------|
    | `user_name`          | `str`                 | Username of the notified user.                                           |
    | `user_first`         | `str`                 | First name of the notified user.                                         |
    | `user_last`          | `str`                 | Last name of the notified user.                                          |
    | `actor_username`     | `str`                 | Username of the user who changed the request status.                     |
    | `record_modified`    | `datetime`            | Date and time when the status change was recorded.                       |
    | `req_id`             | `int`                 | ID of the allocation request being notified about.                       |
    | `req_title`          | `str`                 | Title of the allocation request.                                         |
    | `req_team`           | `str`                 | Name of the team associated with the allocation request.                 |
    | `req_status_code`    | `str`                 | Status code of the request after the change (e.g., `AP`, `DC`, `CR`).    |
    | `req_status_old`     | `str`                 | Human readable status of the request before the change.                  |
    | `req_status_new`     | `str`                 | Human readable status of the request after the change.                   |
    | `req_active`         | `date` or `None`      | Date when the allocation request becomes active.                         |
    | `req_expire`         | `date` or `None`      | Date when the allocation request expires.                                |
    | `allocations`        | `list[dict]`          | List of allocated resources tied to the request. Each item includes:     |
    | ├ `alloc_cluster`    | `str`                 | Name of the cluster where the resource is allocated.                     |
    | ├ `alloc_requested`  | `int`                 | Number of service units requested (or `0` if unavailable).               |
    | └ `alloc_awarded`    | `int` or `None`       | Number of service units awarded (or `None` if not yet awarded).          |

??? abstract "Default Template Content"

    ```html
    --8<-- "submodules/keystone-api/keystone_api/templates/request_status_changed.html"
    ```

### Upcoming Resource Expiration

**Template file:** `request_nearing_expiration.html`

The _upcoming expiration_ notification alerts users that one or more of their active resource allocations is nearing
its expiration date.

??? info "Available Template Fields"

    | Field Name                      | Type               | Description                                                                 |
    |---------------------------------|--------------------|-----------------------------------------------------------------------------|
    | `user_name`                     | `str`              | Username of the notified user.                                              |
    | `user_first`                    | `str`              | First name of the notified user.                                            |
    | `user_last`                     | `str`              | Last name of the notified user.                                             |
    | `req_id`                        | `int`              | ID of the allocation request being notified about.                          |
    | `req_title`                     | `str`              | Title of the allocation request.                                            |
    | `req_team`                      | `str`              | Name of the team associated with the allocation request.                    |
    | `req_submitted`                 | `date`             | Date when the allocation request was submitted.                             |
    | `req_active`                    | `date`             | Date when the allocation request became active.                             |
    | `req_expire`                    | `date` or `None`   | Date when the allocation request expires.                                   |
    | `req_days_left`                 | `int` or `None`    | Number of days remaining until expiration (calculated from current date).   |
    | `allocations`                   | `list[dict]`       | List of allocated resources tied to the request. Each item includes:        |
    | ├ `alloc_cluster`               | `str`              | Name of the cluster where the resource is allocated.                        |
    | ├ `alloc_requested`             | `int`              | Number of service units requested (or `0` if unavailable).                  |
    | └ `alloc_awarded`               | `int`              | Number of service units awarded (or `0` if unavailable).                    |
    | `upcoming_requests`             | `list[dict]`       | List of upcoming or active requests for the same team. Each item includes:  |
    | ├ `id`                          | `int`              | ID of the upcoming allocation request.                                      |
    | ├ `title`                       | `str`              | Title of the upcoming allocation request.                                   |
    | ├ `submitted`                   | `date`             | Date when the upcoming request was submitted.                               |
    | ├ `active`                      | `date`             | Date when the upcoming request became active.                               |
    | ├ `expire`                      | `date` or `None`   | Date when the upcoming request expires.                                     |
    | └ `status`                      | `str`              | Status of the upcoming allocation request.                                  |

??? abstract "Default Template Content"

    ```html
    --8<-- "submodules/keystone-api/keystone_api/templates/request_nearing_expiration.html"
    ```

### Expired Resource Allocation

**Template file:** `request_past_expiration.html`

The _past expiration_ notification alerts users that one or more of their active resource allocations has expired
and that the resources granted under that allocation are no longer available for use.

??? info "Available Template Fields"

    | Field Name                      | Type               | Description                                                                 |
    |---------------------------------|--------------------|-----------------------------------------------------------------------------|
    | `user_name`                     | `str`              | Username of the notified user.                                              |
    | `user_first`                    | `str`              | First name of the notified user.                                            |
    | `user_last`                     | `str`              | Last name of the notified user.                                             |
    | `req_id`                        | `int`              | ID of the allocation request being notified about.                          |
    | `req_title`                     | `str`              | Title of the allocation request.                                            |
    | `req_team`                      | `str`              | Name of the team associated with the allocation request.                    |
    | `req_submitted`                 | `date`             | Date when the allocation request was submitted.                             |
    | `req_active`                    | `date`             | Date when the allocation request became active.                             |
    | `req_expire`                    | `date` or `None`   | Date when the allocation request expires.                                   |
    | `allocations`                   | `list[dict]`       | List of allocated resources tied to the request. Each item includes:        |
    | ├ `alloc_cluster`               | `str`              | Name of the cluster where the resource is allocated.                        |
    | ├ `alloc_requested`             | `int`              | Number of service units requested (or `0` if unavailable).                  |
    | ├ `alloc_awarded`               | `int`              | Number of service units awarded (or `0` if unavailable).                    |
    | └ `alloc_final`                 | `int`              | Number of service units used by the team (or `0` if unavailable).           |
    | `upcoming_requests`             | `list[dict]`       | List of upcoming or active requests for the same team. Each item includes:  |
    | ├ `id`                          | `int`              | ID of the upcoming allocation request.                                      |
    | ├ `title`                       | `str`              | Title of the upcoming allocation request.                                   |
    | ├ `submitted`                   | `date`             | Date when the upcoming request was submitted.                               |
    | ├ `active`                      | `date`             | Date when the upcoming request became active.                               |
    | ├ `expire`                      | `date` or `None`   | Date when the upcoming request expires.                                     |
    | └ `status`                      | `str`              | Status of the upcoming allocation request.                                  |

??? abstract "Default Template Content"

    ```html
    --8<-- "submodules/keystone-api/keystone_api/templates/request_past_expiration.html"
    ```
