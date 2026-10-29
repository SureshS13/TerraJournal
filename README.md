<img width="1309" height="245" alt="TerraJournalLogo-V1" src="https://github.com/user-attachments/assets/9888a710-65c0-471d-a317-116eef731f18" />

<h1 align="center">TerraJournal</h1>

> [!WARNING]
> This is a proof of concept. It has not been rigorously tested for cross-platform compatability, **so please use with caution.**

A module that uses a pre-designed and pre-developed HTML/CSS template to generate a new personal journal / blog website with article pages.

<br>

## Architecture

The module creates the following files:

`src/`    
├── `index.html`     
├── `styles.css`    
└── `articles/`    
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└── `INSERT-ARTICLE-NAME-HERE.html`

The articles folder will contain up to *N* `.html` files, where *N* is the amount of articles passed as module variable arguments.

<br>

## Requirements

- Terraform version `~>1.17.0`
- Hashicorp/local provider version `~>2.9.1`
- Hashicorp/external provider version `~>2.4.2`

<br>

## Usage Example

```hcl
module "my_blog_website" {
    source              = "git::https://github.com/SureshS13/TerraJournal.git//TerraJournal"

    journal_name        = "Jane Doe's Journal"
    journal_description = "This is my new journal."
  
    articles = [
        {
            entry_name    = "My first entry"
            entry_date    = "11/26/36"
            entry_content = "Hello world!"
        }
    ]

    output_directory = "INSERT DIRECTORY PATH HERE"
}
```

<br>

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| journal_name | Name of the journal. | string | n/a | yes |
| journal_description | Description of the journal. | string | n/a | yes |
| output_directory | The directory to generate the files in on the filesystem. | string | n/a | yes |
articles | List of objects representing each article to generate an HTML page for. | list(object({entry_name, entry_date, entry_content})) | n/a | yes |
  -- entry_name | Name of the article entry. | string | n/a | yes |
  -- entry_date | Date of the article entry. | string | n/a | yes |
  -- entry_content | Content of the article entry. | string | n/a | yes |

<br>

## Outputs

| Name | Description |
|------|-------------|
| is_every_folder_and_file_created_successfully | A boolean flag variable that checks to ensure that every folder and file was created succesfully. This does NOT check the contents of files. |

<br>

## Notes / Known Issues

- This module uses the "hashicorp/external" provider to execute a Bash script that verifies all website files were created successfully. Due to the dependency on Bash, using this module may encounter issues on certain operating systems without access to it.

- Currently, this module does not check if the contents of files match what is expected.

<br>

## License

GNU GENERAL PUBLIC LICENSE - Version 3, 29 June 2007

 Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
 Everyone is permitted to copy and distribute verbatim copies
 of this license document, but changing it is not allowed.
