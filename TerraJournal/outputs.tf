# Output block definitions to export data back to the calling root module and make it accessible elsewhere

output "is_every_folder_and_file_created_successfully" {
  type        = bool
  description = "A boolean flag variable that checks to ensure that every folder and file was created succesfully. This does NOT check the contents of files."
  value       = data.external.validate_generated_resources.result["are_all_files_created"]
}