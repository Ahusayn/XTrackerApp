






# XTracker App


XTracker is a modern expense-tracking app built using Swift, designed to simplify expense management with an intuitive user experience. The app offers innovative features such as chart visualizations for expenses and voice input for adding expenses by category.



 Key Features

1. Expense Visualization with Charts
   - View detailed breakdowns of your expenses using visually appealing charts.
   - Analyze spending patterns across different categories such as Education, Food, Housing, Transportation, Entertainment, and Shopping.

 2. Voice Input for Expense Logging
   - Add expenses seamlessly by speaking commands.
   - Keywords are matched to specific categories to automatically categorize your expenses.

 3. Category Keywords
   XTracker intelligently categorizes expenses based on the following predefined keywords:

   ```swift
   let categoryKeywords: [String: [String]] = [
       "Education": ["school", "fees", "tuition", "education"],
       "Food": ["grocery", "food", "restaurant", "meal", "dinner", "lunch"],
       "Housing": ["rent", "apartment", "house", "mortgage"],
       "Transportation": ["transport", "fuel", "bus", "train", "gas"],
       "Entertainment": ["movie", "cinema", "concert", "entertainment", "watched"],
       "Shopping": ["watch", "jewelry", "luxury", "accessories", "gold"]
   ]
   ```
   
   Example:
   - Saying "I spent $50 on groceries" will categorize the expense under **Food**.

---

 How It Works

 Step 1: Add an Expense
- Manual Input: Enter the amount and category directly.
- Voice Input: Speak the expense details (e.g., "I spent $20 on rent").

 Step 2: Visualize Your Data
- Access the **Charts View** to see spending trends.
- Filter by category or time period to gain insights into your financial habits.

 Step 3: Manage Your Budget
- Use XTracker to monitor and control your expenses across different categories.

---

Technologies Used
- Swift: Core language for app development.
- Swift Data: To store and manage expense data.
- Speech Framework: To handle voice input and match keywords to categories.
- SwiftCharts: For generating charts and visualizations.

---



