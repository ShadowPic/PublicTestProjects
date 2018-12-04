Feature: ChartOfAccountsConfiguration
	In order to verify each deployment is consistent
	And ensure that minimum required accounting elements are present
	to avoid testing new features before manual configurations have been completed


Scenario Outline: Required GL Accounts exist
	Given the 'MainAccounts' have been created
	When we look at the 'Name' key
	Then <AccountName> should match
	Examples: 
	| AccountName |
	| Cash Advance Returns |
	| Bank Account - USD |
	| Bank Account - CNY |
	| Bank Account - EUR |
	| Bank Account - RUB |
	| Bank Account - GBP |
	| USD Cash Advances Account |
	| EUR Cash Advances Account |
	| CAD Cash Advances Account |
	| Yuan Cash Advances Account |
	| All Other Cash Advances Account |
	| Bank Account - Payroll |
	| Cash in bank - US (Fixed asset purch) |
	| Petty Cash |
	| TOTAL CASH & CASH EQUIVALENTS |
	| Bonds |
	| Other Marketable Securities |
	| Bill of Exchange (BOE) |
	| BOE Remitted for Collection |
	| BOE Remitted for Discount |
	| Protested BOE |
	| TOTAL SECURITIES |
	| Accounts Receivable - Domestic |
	| Accounts Receivable - Foreign |
	| Accounts Receivable - Clearing |
	| Inter-unit Receivable - Domestic |
	| Credit Card Receivable |
	| Interest Receivable |
	| Notes Receivable |
	| Other Receivables |
	| TOTAL ACCOUNTS RECEIVABLE |
	| Prepaid Expenses |
	| Prepaid Insurance |
	| Advances |
	| Prepaid Commissions |
	| TOTAL OTHER CURRENT ASSETS |
	