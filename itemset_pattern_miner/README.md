# Description
Utilize an implementation of the apriori algorithm
(https://pypi.org/project/efficient-apriori/) applied to a transaction
database style list of entries in a csv file.

# Input File
As mentioned, the input file is to be a .csv listing 4 columns:
- the project
- the file 
- the caller function 
- the callee function

It is additionally expected that a caller lists as calling a given callee at
most once. So if a function calls `free` multiple times, for example, it should
only appear once in the data set.

# Output File

List of detected patterns in the source code files
