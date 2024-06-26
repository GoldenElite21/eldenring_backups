# eldenring_backups
Script to back up Elden Ring saves on an interval.

Create a Task Scheduler Task

    Open Task Scheduler:
        Open Task Scheduler.

    Create a New Task:
        Click on Create Task.

    General Tab:
        Name the task, e.g., "Elden Ring Save Backup".
        Select Run whether user is logged on or not.
        Check Run with highest privileges.

    Triggers Tab:
        Click New.
        Set Begin the task to On a schedule.
        Set Settings to Daily.
        Set Repeat task every to 15 minutes (or whatever interval).
        Set for a duration of to Indefinitely.
        Click OK.

    Actions Tab:
        Click New.
        Set Action to Start a program.
        Set Program/script to cscript.exe.
        Set Add arguments (optional) to "%userprofile%\Desktop\Scripts\backup_eldenring.vbs", replacing "%userprofile%\Desktop\Scripts\backup_eldenring.vbs" with the correct path if different.
