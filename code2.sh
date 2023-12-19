.TH INTERNSCTL 1 "December 2023" "v0.1.0" "internsctl manual"

.SH NAME
internsctl \- Custom Linux command

.SH SYNOPSIS
.B internsctl
[\fIcommand\fP]
[\fIoptions\fP]

.SH DESCRIPTION
.B internsctl
is a custom Linux command that provides various functionalities.

.SH COMMANDS
.TP
.B cpu
Get CPU information.

.TP
.B memory
Get memory information.

.TP
.B user create <username>
Create a new user.

.TP
.B user list [--sudo-only]
List all regular users or users with sudo permissions.

.TP
.B file getinfo [options] <file-name>
Get information about a file.

.SH OPTIONS
.TP
.B \-\-size, \-s
Print the size of the specified file.

.TP
.B \-\-permissions, \-p
Print file permissions.

.TP
.B \-\-owner, \-o
Print file owner.

.TP
.B \-\-last-modified, \-m
Print last modified time of the specified file.

.SH EXAMPLES
.TP
.B internsctl cpu
Get CPU information.

.TP
.B internsctl user create john_doe
Create a new user named john_doe.

.TP
.B internsctl file getinfo --size hello.txt
Get the size of the file hello.txt.

.SH SEE ALSO
.BR lscpu(1),
.BR free(1),
.BR useradd(8),
.BR getent(1),
.BR stat(1).

.SH AUTHOR
Written by Your Name.

.SH BUGS
Report any bugs to your@email.com.

.SH COPYRIGHT
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

.SH VERSION
internsctl v0.1.0 (December 2023)

.SH NOTES
This manual page was written using the man(7) format