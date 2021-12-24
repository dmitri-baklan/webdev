//#include <fcgio.h>
#include <stdlib.h>
#include <fcgi_config.h>
#include <fcgi_stdio.h>
#include <string.h>
#include <stdio.h>

extern char **environ;

static void PrintEnv(char *label, char **envp)
{
    printf("%s:<br>\n<pre>\n", label);
    for ( ; *envp != NULL; envp++) {
        printf("%s\n", *envp);
    }
    printf("</pre><p>\n");
}


int main()
{
    char **initialEnv = environ;
    int count = 0;

    while(FCGI_Accept() == 0)
    {
        char sPath[1024] = "";
        char *pTmp;
        if ((pTmp = getenv("PATH_INFO")) != NULL) // SCRIPT_NAME
            strncpy(sPath, pTmp, 1023); // Save a copy for our use.
        // char * path = "/";
        char ch;
        if (strcmp(sPath, "/") == 0) {
            FILE * index_fp = fopen("index.html", "r");
            if (index_fp == NULL)
            {
                printf("Content-type: text/html\r\n"
                       "\r\n"
                       "<title>FastCGI echo</title>"
                       "<h1>Not found</h1>\n"
                       "Request number %d,  Process ID: %d<p>\n",
                       ++count, getpid());
                continue;
            }
            printf("Content-type: text/html\r\n"
                       "\r\n"
                       "Request number %d,  Process ID: %d<p>\n",
                       ++count, getpid());
            while((ch = fgetc(index_fp)) != EOF)
            {
                printf("%c", ch);
            }
                
        }
        else if (strcmp(sPath, "/echo") == 0) {
            printf("Content-type: text/html\r\n"
                    "\r\n"
                    "<title>FastCGI echo</title>"
                    "<h1>My main fcgi application</h1>\n"
                    "Request number %d,  Process ID: %d<p>\n", ++count, getpid());
                    PrintEnv("Request environment", environ);
        }
         else if (strcmp(sPath, "/mpstat") == 0) {
            printf("Content-type: text/html\r\n"
                    "\r\n"
                    "<title>FastCGI echo</title>"
                    "<h1>My main fcgi application</h1>\n"
                    "Request number %d,  Process ID: %d<p>\n", ++count, getpid());
                    printf("<body>");
                    printf("MPSTAT\n");
                    int res = system("mpstat"); // 1 1 >/dev/null 2>&1
                    printf("System call result %i ", res);
                    printf("</body>");

        }
        else {
                printf("Content-type: text/html\r\n"
                "\r\n"
                "Not found ");
                printf(sPath);
                if (system(NULL)) {
                    printf("System works\n");
                } else {
                    printf("System doesn't works\n");
                }
                // system("ls -l"); // >/dev/null 2>&1
                printf("\n");
                printf("Request number %d,  Process ID: %d<p>\n", ++count, getpid());
                PrintEnv("Request environment", environ);
        }

    }
}

// # echo "$(cgi-fcgi -connect 127.0.0.1:49311 example)"