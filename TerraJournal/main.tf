# Primary entrypoint for the module

resource "local_file" "index_html_markup_file" {
  content  = <<EOT
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <link rel="stylesheet" href="styles.css" />
        <title>${var.journal_name}</title>
      </head>
      <body>
        <header>
          <h1>${var.journal_name}</h1>
          <p>${var.journal_description}</p>
        </header>
        <nav>
          <h3>Recent Entries</h3>
          <div id="article-links">
            ${join("\n", [for article in var.articles : "<div class=\"article-link\"><a href=\"articles/${article.entry_name}.html\">${article.entry_name}</a><span>${article.entry_date}</span></div>"])}
          </div>
        </nav>
        <footer>
          Built with <a href>TerraJournal</a> ❤️
        </footer>
      </body>
    </html>
  EOT
  filename = "${var.output_directory}/src/index.html"
}

resource "local_file" "styles_css_stylesheet_file" {
  content  = <<EOT
    /**************/
    /* CSS Resets */
    /**************/

    /* Use a more-intuitive box-sizing model */
    *, *::before, *::after {
        box-sizing: border-box;
    }

    /* Remove any default user agent margins */
    *:not(dialog) {
        margin: 0;
    }

    /***************/
    /* Type scale /*/
    /***************/

    h1 {
        font-size: 2.986rem;

        @media screen and (max-width: 576px) {
            font-size: 2.488rem;
        }
    }

    h2 {
        font-size: 2.488rem;

        @media screen and (max-width: 576px) {
            font-size: 2.074rem;
        }
    }

    h3 {
        font-size: 2.074rem;

        @media screen and (max-width: 576px) {
            font-size: 1.728rem;
        }
    }

    p {
        font-size: 1rem;
    }

    /***************/
    /* Base styles */
    /***************/

    :root {
        --page-content-max-width: 35rem;
    }

    body {
        font-family: 'Trebuchet MS', sans-serif;
        letter-spacing: 0.015rem;
        line-height: 1.6;
        min-height: 100vh;
        background: #dbeafe;
        background: linear-gradient(135deg, #dbeafe, #93c5fd, #c4b5fd);
    }

    body {
        display: flex;
        flex-direction: column;
        align-items: center;
        row-gap: 3rem;
        padding: 2rem;
    }

    header {
        text-align: center;
        max-width: var(--page-content-max-width);

        & a {
            display: inline-block;
            text-decoration: none;
            margin-bottom: 1rem;

            &:hover {
                text-decoration: underline;
            }
        }

        & h1 {
            margin-bottom: 1rem;

            &:not(#article-header)::after {
                content: '';
                display: inline-block;
                width: 1rem;
                height: 2.5rem;
                margin-left: 0.75rem;
                background: black;
                animation: blinkingCursor 1s steps(1) infinite            
            }
        }
    }

    nav, article {
        flex-grow: 1;
        max-width: var(--page-content-max-width);
    }

    nav {
        & h3 {
            margin-bottom: 2rem;
        }

        & #article-links {
            display: flex;
            flex-direction: column;
            row-gap: 2rem;

            & .article-link {
                display: flex;
                flex-basis: 100%;

                &:hover {
                    cursor: pointer;
                    outline: 0.125rem solid black;
                    outline-offset: 1rem;
                    border-radius: 0.5rem;
                    animation: headingHover 900ms steps(1) infinite   
                }

                & > a {
                    display: inline-block;
                    flex-grow: 1;
                    padding-right: 1rem;
                    color: black;
                    text-decoration: none;
                }
                
                & span {
                    align-self: flex-start;
                }
            }
        }
    }

    article {
        & p:nth-of-type(1n+2) {
            margin-top: 1rem;
        }
    }

    /**************/
    /* Keyframes /*/
    /**************/

    @keyframes blinkingCursor {
        50% {
            opacity: 0;
        }
    }

    @keyframes headingHover {
        25% {
            outline-style: dashed;
        }
        50% {
            outline-style: dotted;
        }
        75% {
            outline-style: dashed;
        }
    }
  EOT
  filename = "${var.output_directory}/src/styles.css"
}

resource "local_file" "article_html_markup_file" {
  # Using the for_each meta argument, we want to dynamically create individual article HTML files for every article inputted
  for_each = { for article in var.articles : "${article.entry_name}${article.entry_date}" => article }
  content  = <<EOD
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <title>${var.journal_name} - ${each.value.entry_name}</title>
        <link rel="stylesheet" href="../styles.css">
      </head>
      <body>
        <header>
          <a href="../index.html">← Back to Homepage</a>
          <h1 id="article-header">${each.value.entry_name}</h1>
          <p>${each.value.entry_date}</p>
        </header>
        <article>
          <p>${each.value.entry_content}</p>
        </article>
        <footer>
          Built with <a href>TerraJournal</a> ❤️
        </footer>
      </body>
    </html>
  EOD
  filename = "${var.output_directory}/src/articles/${each.value.entry_name}.html"
}

# Run a custom Bash script after attempting to create our resources to check if all files/folders were generated successfully
# NOTE: This script currently does not check the contents of files
data "external" "validate_generated_resources" {
  program = ["bash", "${path.module}/scripts/validate_resources.sh"]

  query = {
    # Arbitrary map from strings to strings, passed to the external program as the data query
    output_directory = "${var.output_directory}/"
    article_count    = length(var.articles)
  }

  # Adding this meta-argument to create explicit dependencies
  # We want to ensure that we've attempted to create all our resources first, before querying the filesystem
  depends_on = [local_file.index_html_markup_file, local_file.styles_css_stylesheet_file, local_file.article_html_markup_file]
}

