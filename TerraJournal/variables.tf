# # Input variables that must be provided explicitly from the calling parent module

variable "journal_name" {
  type        = string
  description = "The name of the journal."
  nullable    = false

  # Guard clauses
  validation {
    condition     = length(var.journal_name) != 0
    error_message = "Please provide a non-empty string value."
  }
}

variable "journal_description" {
  type        = string
  description = "The optional description for the journal."
  default     = ""
}

variable "articles" {
  type = list(object({
    entry_name    = string
    entry_date    = string
    entry_content = string
  }))
  description = "An ordered collection of journal entry objects to include in the final site."
  nullable    = false

  # Guard clauses
  validation {
    condition     = length(compact([for article in var.articles : article.entry_name])) == length(var.articles)
    error_message = "Please ensure all articles have a valid non-empty entry name."
  }

  validation {
    condition     = length(compact([for article in var.articles : article.entry_date])) == length(var.articles)
    error_message = "Please ensure all articles have a valid non-empty entry date."
  }

  validation {
    condition     = length(compact([for article in var.articles : article.entry_content])) == length(var.articles)
    error_message = "Please ensure all articles have a valid non-empty entry content value."
  }
}

variable "output_directory" {
  type        = string
  description = "The directory to create the final website files in."
  nullable    = false

  # Guard clauses
  validation {
    condition     = length(var.output_directory) != 0
    error_message = "Please provide a non-empty string value."
  }

  validation {
    condition     = can(regex("^((/[a-zA-Z0-9-_]+)+|/)$", var.output_directory))
    error_message = "Please provide a valid file path."
  }

  validation {
    condition     = provider::local::direxists(var.output_directory)
    error_message = "Please provide a valid directry path."
  }
}