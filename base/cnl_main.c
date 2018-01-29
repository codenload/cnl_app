/*
 * MIT License
 * Copyright (c) 2017, Pablo Ridolfi - Code 'n Load
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

/*==================[inclusions]=============================================*/

#include <systemd/sd-daemon.h>
#include <syslog.h>
#include <stdlib.h>
#include "cnl_main.h"

/*==================[macros and definitions]=================================*/

/*==================[internal data declaration]==============================*/

/*==================[internal functions declaration]=========================*/

/*==================[internal data definition]===============================*/

/*==================[external data definition]===============================*/

/*==================[internal functions definition]==========================*/

/*==================[external functions definition]==========================*/

int main(void) {
	syslog(LOG_INFO, "Starting Code 'n Load user application. Build " __DATE__ " " __TIME__);
	syslog(LOG_INFO, "Source code path: %s", getenv("CNL_APP_PATH"));
	syslog(LOG_INFO, "Source code repository: %s", getenv("CNL_APP_URL"));
	wiringPiSetupGpio();
	setup();
	sd_notify(0, "READY=1");
	while (1) {
		sd_notify(0, "WATCHDOG=1");
		loop();
	}
	return 0;
}

/*==================[end of file]============================================*/
