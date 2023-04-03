from RPA.PDF import PDF

pdf = PDF()

def split_pdf(input_path:str, split_string:str, output_path:str):
    '''Splits a PDF file using a split range string, for example 1, or 1,3-4.'''
    
    files = [input_path + ":" + split_string]
    try:
        pdf.add_files_to_pdf(files, output_path)
    except:
        return "Error"
        
    return "Success"