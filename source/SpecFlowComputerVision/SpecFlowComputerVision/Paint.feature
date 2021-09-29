Feature: Paint
	In order to test computer vision functionality in Paint
	As an end user
	I want to drawn an image and find image using computer vision

Scenario: Select Triangle
	Given I select a traingle
	Then image with 3 sides is found

Scenario: Draw Rectangle
	Given I draw a rectangle
	Then image with 4 sides is found
