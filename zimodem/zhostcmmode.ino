/*
   Copyright 2016-2024 Bo Zimmerman

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
#ifdef INCLUDE_SD_SHELL
#ifdef INCLUDE_HOSTCM
void ZHostCMMode::switchBackToCommandMode()
{
  if(proto != 0)
    delete proto;
  proto = 0;
  currMode = &commandMode;
}

void ZHostCMMode::switchTo()
{
  currMode=&hostcmMode;
  if(proto == 0)
    proto = new HostCM(&SD);
}

void ZHostCMMode::serialIncoming()
{
  if(proto != 0)
    proto->receiveLoop();
}

void ZHostCMMode::loop()
{
  serialOutDeque();
  if((proto != 0) && (proto->isAborted()))
    switchBackToCommandMode();
  logFileLoop();
}

#endif
#endif
