#include "nlohmann/json.hpp"

#include <iostream>

int main()
{
	using namespace nlohmann;

	auto content = R"({
		"name": "Rob",
		"age": 32
	})"_json;

	content["gender"] = "male";
	content["posture"] = json(std::unordered_map<std::string, int>{
		{"width", 160},
		{"height", 56},
	});

	std::cout << content.dump(4) << std::endl;

	return EXIT_SUCCESS;
}
