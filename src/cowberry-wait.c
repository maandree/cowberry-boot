/**
 * cowberry-boot – A minimal sysvinit script set designed for Raspberry Pi
 * Copyright © 2013, 2014  André Technology (mattias@andretechnology.com)
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
#include <sys/types.h>
#include <signal.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>
#include <alloca.h>


/**
 * Simply waits for a set of processes to exit
 */
int main(int argc, char** argv)
{
  pid_t* pids = alloca(argc * sizeof(pid_t));
  int remaining = argc - 1, i;
  
  for (i = 1; i < argc; i++)
    *(pids + i) = (pid_t)(atoll(*(argv + i)));
  
  for (;;)
    {
      for (i = 1; i < argc; i++)
	if (*(pids + i))
	  if (kill(*(pids + i), 0) == -1)
	    if (errno == ESRCH)
	      {
		remaining--;
		*(pids + i) = 0;
	      }
      if (remaining)
	usleep(1000000 /* µs = 100 ms */);
      else
	return 0;
    }
}

