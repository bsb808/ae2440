
/home/bsb/Classes/AE2440/StudentWork/moss/Assignment_5__ODEs___copy_/Baameur,_Ahmed_ahmed.a.baameur_/Submission_attachment_s_/
/home/bsb/Classes/AE2440/StudentWork/moss/Assignment_5__ODEs___copy_/*/Submission_attachment_s_/*.m
/home/bsb/Classes/AE2440/StudentWork/moss/Assignment_5__ODEs___copy_/*/Submission_attachment_s_/euler.m

# Example path with spaces
#path_with_spaces="/path/to/my directory/with spaces"
path="/home/bsb/Classes/AE2440/StudentWork/Assignment 5_ ODEs /"
echo $path

"/home/bsb/Classes/AE2440/StudentWork/Assignment 5_ ODEs /*/Submission attachment(s)/euler.m"
fullpath="${path}/*/*/*.m"
echo $fullpath
# Proper way to handle the path with quotes
if [ -d "$fullpath" ]; then
    # Using quotes around the variable preserves spaces
    ls -la "$fullpath"
else
    echo "Directory does not exist: $path_with_spaces"
fi


/home/bsb/Classes/AE2440/StudentWork/moss/Assignment_5__ODEs__(copy)/*/Submission_attachment(s)/*.m