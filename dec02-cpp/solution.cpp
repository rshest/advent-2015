#include <iostream>
#include <string>
#include <algorithm>
#include <sstream>

void parseExtents(const std::string& config, int& w, int& h, int& d) {
    char x;
    std::istringstream ss(config);
    ss >> w >> x >> h >> x >> d;
}

int getWrappingArea(int w, int h, int d) {
    const int maxSide = std::max(std::max(w, h), d);
    const int slack = w*h*d/maxSide;
    const int area = (w*h + h*d + w*d)*2 + slack;
    return area;
}

int getRibbonLength(int w, int h, int d) {
    const int maxSide = std::max(std::max(w, h), d);
    const int vol = w*h*d;
    const int length = (w + h + d - maxSide)*2 + vol;
    return length;
}

int main() {
    std::string str;
    int area = 0;
    int ribbonLength = 0;
    while (std::getline(std::cin, str)) {
        int w, h, d;
        parseExtents(str, w, h, d);
        area += getWrappingArea(w, h, d);
        ribbonLength += getRibbonLength(w, h, d);
    }

    std::cout << "Total square feet of wrapping paper: " << area << "\n";
    std::cout << "Total ribbon length: " << ribbonLength << "\n";
}

