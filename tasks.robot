*** Settings ***
Documentation       Shows two ways of implementing simplified keywords for
...                 merging and splitting PDF documents. With python (split), or
...                 by implementing a keyword (merge).

Library             RPA.PDF
Library             ExtendedPDF
Library             String
Library             RPA.FileSystem


*** Variables ***
${INPUT_DIR}    input


*** Tasks ***
Merge and split pdfs
    [Documentation]    This first splits and then merges again a PDF doc.

    ${files}=    Create List
    ...    ${INPUT_DIR}${/}acord.png:align=center
    ...    ${INPUT_DIR}${/}multipage.pdf:1,3-4

    # This is an example of simply wrapping the add files to pdf under simple
    # keyword such as "merge pdfs".
    Merge pdfs    ${files}    ${OUTPUT_DIR}${/}merged.pdf

    # This is an example where some of the logic remains on .robot code (namely
    # looping per page), but the splif pdf is implemented as a python method.
    Split per page    ${OUTPUT_DIR}${/}merged.pdf


*** Keywords ***
Merge pdfs
    [Documentation]    Takes in an argument of list of PDF and
    ...    other files such as images, and merges them as one
    ...    file saved in the path given as a second argument.
    [Arguments]    ${file_list}    ${output_path}
    Add Files To Pdf    ${file_list}    ${output_path}

Split per page
    [Documentation]    Creates a separate PDF file out of each page in the
    ...    given input pdf file in the same directory.
    [Arguments]    ${input_file}

    ${page_count}=    Get Number Of Pages    ${input_file}
    ${file_stem}=    Get File Stem    ${input_file}
    ${extension}=    Get File Extension    ${input_file}

    # Loop for each page to split them to individual files
    FOR    ${x}    IN RANGE    1    ${page_count} + 1
        # Construct the resulting file name
        ${page_str}=    Convert To String    ${x}
        ${output_file}=    Set Variable    ${OUTPUT_DIR}${/}${file_stem}-${page_str}${extension}

        # Use python method for split
        ${result}=    ExtendedPDF.Split Pdf    ${input_file}    ${page_str}    ${output_file}
        Should Be Equal    ${result}    Success
    END
