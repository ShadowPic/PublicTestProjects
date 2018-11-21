Feature: ChartOfAccountsConfiguration
	In order to verify each deployment is consistent
	And ensure that minimum required accounting elements are present
	to avoid testin new features before manual configurations have been completed


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
	| Car audio receipts |
	| Car audio issues |
	| Car audio returns |
	| DVD player receipts |
	| DVD player issues |
	| DVD player returns |
	| DVR receipts |
	| DVR issues |
	| DVR returns |
	| HTS receipts |
	| HTS issues |
	| HTS returns |
	| Projector receipts |
	| Projector issues |
	| Projector returns |
	| Receiver receipts |
	| Receiver issues |
	| Receiver returns |
	| Speaker receipts |
	| Speaker issues |
	| Speaker returns |
	| Television receipts |
	| Television issues |
	| Television returns |
	| Raw materials receipts |
	| Raw materials issues |
	| Raw materials returns |
	| Packaging receipts |
	| Packaging issues |
	| Packaging returns |
	| Services receipts |
	| Services issues |
	| Services returns |
	| Misc. receipts/issues |
	| Misc. returns |
	| Inventory Clearing - Received, un-invoiced |
	| Inventory Clearing - Received, un-invoiced - Intercompany |
	| Inventory Clearing - Shipped, un-invoiced |
	| Inventory Clearing - Shipped, un-invoiced - Intercompany |
	| Deferred expense |
	| Deferred expense - Intercompany |
	| TOTAL PHYSICAL INVENTORY |
	| Production WIP-Clearing |
	| Production WIP-Materials |
	| Production WIP-Labor |
	| Production WIP-Overhead |
	| TOTAL INVENTORY PRODUCTION |
	| TOTAL INVENTORY |
	| WIP - Hour Costs |
	| WIP - Item Costs |
	| WIP - Expense Costs |
	| WIP - Accrued Loss |
	| TOTAL PROJECT WIP COST VALUE |
	| WIP - Production |
	| WIP - Profit |
	| WIP - Sales Value |
	| TOTAL PROJECT WIP SALES VALUE |
	| PROJECT GROSS WIP |
	| WIP - Invoiced - On Account |
	| PROJECT NET WIP |
	| Goodwill |
	| Development |
	| Amortization - intangible assets |
	| TOTAL INTANGIBLE ASSETS |
	| Computer Equipment |
	| Accumulated depreciation - Computer Equipment |
	| Accumulated depreciation - Furniture & Fixtures |
	| Accumulated depreciation - Machine & Equipment |
	| Accumulated depreciation - Office Hardware |
	| Amortization- Patents |
	| Accumulated depreciation - Vehicles |
	| Accumulated depreciation - Buildings |
	| Accumulated depletion - Land |
	| Deferred Tax Assets, Long-term |
	| Revaluation adjustment |
	| Disposal fixed assets |
	| Accumulated write up |
	| Accumulated write down |
	| Reversal of depreciation & write up/down |
	| Revaluation adjustment |
	| TOTAL TANGIBLE FIXED ASSETS |
	| TOTAL ASSETS |
	| Accounts Payable - Foreign |
	| TOTAL ACCRUALS |
	| SHORT TERM LIABILITIES |
	| Accounts Payable - Domestic |
	| Accounts Payable - Foreign |
	| Inter-unit Payable |
	| Accounts Payable - Clearing |
	| Accounts Payable - Other |
	| Invoice Pending Approval |
	| Offset Invoice Pending Appr |
	| Promisorry Notes |
	| Remitted promissory notes |
	| Bridging |
	| Accrued purchases |
	| Accrued purchases - Intercompany |
	| Salaries and wages payable |
	| Commissions payable |
	| Payroll benefits payable |
	| Dividends payable |
	| Freight payable |
	| Payroll deductions payable |
	| Employee benefits payable |
	| State workers compensation payable |
	| Short term interest payable |
	| Prepayment of service subscription fee |
	| Customer deposits |
	| TOTAL ACCOUNTS PAYABLE |
	| California state tax payable |
	| Colorado state tax payable |
	| Tennesse state tax payable |
	| Nevada state tax payable |
	| New Jersey state tax payable |
	| Michigan state tax payable |
	| DC state tax payable |
	| Florida state tax payable |
	| Georgia state tax payable |
	| Iowa state tax payable |
	| Idaho state tax payable |
	| Illinois state tax payable |
	| Massachusetts state tax payable |
	| Maryland state tax payable |
	| Minnesota state tax payable |
	| North Dakota state tax payable |
	| New York state tax payable |
	| Ohio state tax payable |
	| Oregon state tax payable |
	| Pennsylvania state tax payable |
	| Texas state tax payable |
	| Washington state tax payable |
	| Sales Tax Payable - Clearing |
