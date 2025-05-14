# Load required package
if (!require("stringr")) install.packages("stringr")
library(stringr)

# Define the folder containing the .qmd files
posts_dir <- "posts"

# Function to update the "date" field in a .qmd file
update_date_in_qmd <- function(file_path) {
  # Read the file content
  lines <- readLines(file_path)
  
  # Check if the file contains YAML metadata (start and end with "---")
  metadata_start <- which(lines == "---")[1]
  metadata_end <- which(lines == "---")[2]
  
  if (!is.na(metadata_start) && !is.na(metadata_end)) {
    # Find the line containing "date:"
    date_line_index <- which(str_detect(lines[metadata_start:metadata_end], "^date:")) + metadata_start - 1
    
    # If "date:" exists, update it; otherwise, add it
    if (length(date_line_index) > 0) {
      lines[date_line_index] <- paste0("date: ", Sys.Date())
    } else {
      # Add "date:" immediately after the opening "---"
      lines <- append(lines, paste0("date: ", Sys.Date()), metadata_start)
    }
    
    # Write the updated content back to the file
    writeLines(lines, file_path)
  } else {
    message("No valid YAML metadata found in ", file_path)
  }
}

# Update all .qmd files in the "posts" directory
files <- list.files(posts_dir, pattern = "\\.qmd$", full.names = TRUE)
for (file in files) {
  update_date_in_qmd(file)
  message("Updated date for: ", file)
}