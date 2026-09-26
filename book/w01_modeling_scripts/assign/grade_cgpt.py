import sys
import os
import logging
from pathlib import Path
import csv

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

def setup_logging(log_file):
    """Configure logging to write to both file and terminal."""
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)
    
    file_handler = logging.FileHandler(log_file, mode='a')
    console_handler = logging.StreamHandler()
    
    formatter = logging.Formatter('%(message)s')
    file_handler.setFormatter(formatter)
    console_handler.setFormatter(formatter)
    
    logger.addHandler(file_handler)
    logger.addHandler(console_handler)
    
    return logger

def grade_submission(student_dir):
    """Check submission files and return grade."""
    required_files = ['penny.m', 'pennywithair.m', 'bike_update.m', 'aquarium.m']
    submission_dir = os.path.join(student_dir, 'Submission attachment(s)')
    
    if not os.path.exists(submission_dir):
        return 90, [], required_files
    
    present_files = os.listdir(submission_dir)
    present_files = [f for f in present_files if os.path.isfile(os.path.join(submission_dir, f))]
    
    missing_files = [f for f in required_files if f not in present_files]
    
    if not missing_files:
        return 100, present_files, required_files
    else:
        return 90, present_files, required_files

def main():
    if len(sys.argv) != 2:
        print("Usage: python grade_cgpt.py <AssignmentName directory>")
        sys.exit(1)
    
    assignment_dir = sys.argv[1]
    grades_csv = os.path.join(assignment_dir, 'grades.csv')
    
    grades_data = []
    with open(grades_csv, 'r') as f:
        reader = csv.reader(f)
        for row in reader:
            grades_data.append(row)
    
    for i, row in enumerate(grades_data):
        if i < 3:
            continue
        
        display_id = row[0].strip('"')
        student_dir = os.path.join(assignment_dir, display_id)
        
        if not os.path.exists(student_dir):
            continue
        
        comments_file = os.path.join(student_dir, 'comments.txt')
        logger = setup_logging(comments_file)
        
        logger.info(f"\n{'='*50}")
        logger.info(f"Student: {display_id}")
        logger.info(f"{'='*50}")
        
        grade, present, required = grade_submission(student_dir)
        
        if grade == 100:
            logger.info("All required files present.")
        else:
            logger.info("Missing files detected.")
            logger.info(f"Files present: {present}")
            logger.info(f"Required files: {required}")
        
        logger.info(f"Grade: {grade}\n")
        
        for handler in logger.handlers[:]:
            logger.removeHandler(handler)
            handler.close()
        
        grades_data[i][4] = str(grade)
    
    with open(grades_csv, 'w', newline='') as f:
        writer = csv.writer(f)
        writer.writerows(grades_data)

if __name__ == "__main__":
    main()