package main

import (
	"errors"
	"fmt"
	"io/ioutil"
	"os"
	"regexp"
	"strconv"
	"strings"
)

type ingredient struct {
	name   string
	amount int
	cmp    int
}

type person struct {
	number      int
	ingredients []int
}

func parseIngredient(descr string) (ingredient, error) {
	re := regexp.MustCompile(`([a-z]+): (\d+)`)
	parts := re.FindStringSubmatch(descr)
	if len(parts) < 3 {
		return ingredient{"", 0, 0}, errors.New("Failed to parse ingredient")
	}
	n, _ := strconv.Atoi(parts[2])
	return ingredient{parts[1], n, 0}, nil
}

func getIngredientIdx(name string, ingredients []ingredient) int {
	for j := range ingredients {
		if ingredients[j].name == name {
			return j
		}
	}
	return -1
}

func parsePerson(descr string,
	ingredients []ingredient) (person, error) {

	re := regexp.MustCompile(`Sue (\d+)|([a-z]+): (\d+)`)
	parts := re.FindAllStringSubmatch(descr, -1)
	ingList := make([]int, len(ingredients))
	nparts := len(parts)
	if nparts < 1 {
		return person{0, ingList}, errors.New("Failed to parse person")
	}
	personID, _ := strconv.Atoi(parts[0][1])
	for i := range ingList {
		ingList[i] = -1
	}
	for i := 1; i < nparts; i++ {
		p := parts[i]
		if len(p) < 4 {
			return person{0, ingList}, errors.New("Failed to parse person")
		}

		idx := getIngredientIdx(p[2], ingredients)
		amt, _ := strconv.Atoi(p[3])
		ingList[idx] = amt
	}
	return person{personID, ingList}, nil
}

func readInput(idx int) []string {
	fname := "input" + strconv.Itoa(idx) + ".txt"
	if len(os.Args) > idx {
		fname = os.Args[idx]
	}

	data, _ := ioutil.ReadFile(fname)
	return strings.Split(string(data), "\n")
}

func compares(a int, b int, cmp int) bool {
	if cmp == 0 {
		return a == b
	} else if cmp > 0 {
		return a > b
	} else {
		return a < b
	}
}

func findMatchingID(persons []person, ingredients []ingredient) int {
	for i := range persons {
		person := persons[i]
		match := true
		for j := range ingredients {
			ing := person.ingredients[j]
			if ing >= 0 &&
				!compares(ing, ingredients[j].amount, ingredients[j].cmp) {
				match = false
			}
		}
		if match {
			return person.number
		}
	}
	return -1
}

func main() {
	ingLines := readInput(1)
	ingredients := make([]ingredient, 0, len(ingLines))
	for i := range ingLines {
		ing, err := parseIngredient(ingLines[i])
		if err == nil {
			ingredients = append(ingredients, ing)
		}
	}

	personLines := readInput(2)
	persons := make([]person, 0, len(personLines))
	for i := range personLines {
		person, err := parsePerson(personLines[i], ingredients)
		if err == nil {
			persons = append(persons, person)
		}
	}
	fmt.Printf("1st Aunt Sue: %d\n", findMatchingID(persons, ingredients))

	corr := map[string]int{
		"cats":        1,
		"trees":       1,
		"pomeranians": -1,
		"goldfish":    -1,
	}
	for name, cmp := range corr {
		ingredients[getIngredientIdx(name, ingredients)].cmp = cmp
	}
	fmt.Printf("2nd Aunt Sue: %d\n", findMatchingID(persons, ingredients))
}
