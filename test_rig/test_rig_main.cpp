#include "process.hpp"
#include <iostream>
#include <vector>

using namespace std;
using namespace TinyProcessLib;

int main()
{
    cout << endl
         << "Placeholder code show Java version" << endl;
    Process process2(
            vector<string>{"java", "--show-version", ""}, "",
            [](const char *bytes, size_t n) {
                cout << "Output from stdout: " << string(bytes, n);
            },
            [](const char *bytes, size_t n) {
                cout << "Output from stderr: " << string(bytes, n);
                // Add a newline for prettier output on some platforms:
                if(bytes[n - 1] != '\n')
                    cout << endl;
            });
    auto exit_status = process2.get_exit_status();
    cout << "Example 2 process returned: " << exit_status << " (" << (exit_status == 0 ? "success" : "failure") << ")" << endl;
    return 0;
}
