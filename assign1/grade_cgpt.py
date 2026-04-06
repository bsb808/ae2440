"""
"This python script is for grading and adding comments to submissions for a course.

The one positional argument is the path to the AssignmentName directory.

The directory structure for an AssignmentName is as follows (for two students)

AssignmentName/
├── grades.csv
├── Student Name1
│   ├── comments.txt
│   ├── Feedback Attachment(s)
│   ├── Submission attachment(s)
│   │   ├── aquarium.m
│   │   ├── bike_update.m
│   │   ├── penny.m
│   │   └── pennywithair.m
│   └── timestamp.txt
└── Student Name2
    ├── comments.txt
    ├── Feedback Attachment(s)
    ├── Submission attachment(s)
    │   ├── aquarium.m
    │   ├── bike_update.m
    │   ├── penny.m
    │   └── pennywithair.m
    └── timestamp.txt


For each student:
- Append comments "comments.txt" file.  Maybe use python logging to write to the file and also to the terminal.  Include demarcation for each student 
- evaluate the files and in the "Submissions attachment(s)" directory.  Test if there are all the files in the following list: [penny.m, pennywithair, bike_update.m, aquarium.m]
- If all the files are present, print a log to comments.txt that all the files are all there and assign a grade of 100
- If there are any missing files, print a log to the comment.txt that there is at least one missing files.  Also log the files present and the list it was compared to.  Assign a grade of 90 

Write the grades in the existing "grades.csv" file.  The existing file has this format:
----------------------------
"Assignment Name ","SCORE_GRADE_TYPE"
""
"Display ID","ID","Last Name","First Name","grade","Submission date","Late submission"
"student.name1","student.name1","Name1","Student","","2026-04-02T04:00:05Z","On time"
"student.name2","student.name2","Name2","Student","","2026-04-01T16:41:58Z","On time"
----------------------------
Modify only the "grade" column.
"""

