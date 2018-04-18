Feature: BDDCoffeeSite
	

@SetBasePage
Scenario: Set the base url
	Given I have a deployed web site
	And I want to override the default site url
	When I set the Site Url to https://drcoffee.azurewebsites.net
	Then a browser opens to the default page

@HomePage
Scenario: Verify Cappuccino is available
	Given I like Capuccino
	When I set the Site Url to https://drcoffee.azurewebsites.net
	And I go to the relative url of /
	Then the coffee type Cappuccino is found

@AboutPage
Scenario: Show how anyone can write new tests
	Given I want to show how to write tests
	When I set the Site Url to https://drcoffee.azurewebsites.net
	And I go to the relative url of /about.jsp
	Then I can verify the text 'Its a coffee shop' is on the page