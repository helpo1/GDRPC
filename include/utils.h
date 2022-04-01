#pragma once

#include <map>
#include <string>

std::string getFileName(const std::string &path);
std::string getModuleFileName();
std::string toUpperCase(std::string str);
std::string getWorldNameG1(std::string zenFile);
std::string getWorldNameG2(std::string zenFile);
std::string utf8Encode(const std::wstring &wstr);
std::wstring ansiEncode(const std::string &str);
std::wstring pseudoCzEncode(std::wstring str);
std::map<std::string, std::string> getCommandLineArgs();
std::string getModTitle(std::string modIniPath);
std::string getExeDirectory();
std::string getModText();
