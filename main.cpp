#include <iostream>
#include "git_version_info.h"

int main() {
    std::cout << "Project Git Version: " << LATEST_GIT_TAG << std::endl;
    return 0;
}
