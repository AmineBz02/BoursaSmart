import requests
import pandas as pd
import plotly.graph_objects as go
from companies import companies  # Import the companies dictionary

# API Endpoint
url = "https://data.irbe7.com/api/data/history"

# Define countback variable
countback = 330  # Number of data points to retrieve

# User selects a company by name
choice = "AMEN BANK"

# Validate choice
if choice not in companies:
    print("\nError: Company not found! Please ensure you entered the name exactly as shown.")
else:
    # Get parameters for the chosen company
    params = companies[choice]

    # Add countback to the parameters
    params["countback"] = countback

    # Debugging: Print parameters
    print("Request Parameters:", params)

    # Fetch data from API
    try:
        response = requests.get(url, params=params)
    except requests.exceptions.RequestException as e:
        print(f"\nError: An exception occurred while fetching data: {e}")
        exit(1)

    # Debugging: Print raw response status
    print("\nHTTP Status:", response.status_code)
    if response.status_code != 200:
        print("Error: Failed to fetch data")
        print("Response Text:", response.text)
    else:
        try:
            data = response.json()
        except ValueError:
            print("Error: Response is not in JSON format")
            exit(1)

        # Check if data retrieval was successful
        if not data or "t" not in data or "o" not in data:
            print("\nError: Unable to retrieve data or incorrect response format")
            print("Response Content:", data)
        else:
            # Convert API response to DataFrame
            df = pd.DataFrame({
                "timestamp": data["t"],  # Time
                "open": data["o"],       # Open price
                "high": data["h"],       # High price
                "low": data["l"],        # Low price
                "close": data["c"]       # Close price
            })

            # Convert timestamps to readable dates and group by day
            df["date"] = pd.to_datetime(df["timestamp"], unit='s').dt.date

            # Aggregate data to get OHLC per day
            grouped_df = df.groupby("date").agg({
                "open": "first",   # First open of the day
                "high": "max",     # Highest price of the day
                "low": "min",      # Lowest price of the day
                "close": "last"    # Last close of the day
            }).reset_index()

            # Check if grouped_df is empty
            if grouped_df.empty:
                print("\nNo data available for the selected company in the specified date range.")
            else:
                # Create Candlestick Chart
                fig = go.Figure(data=[go.Candlestick(
                    x=grouped_df["date"],
                    open=grouped_df["open"],
                    high=grouped_df["high"],
                    low=grouped_df["low"],
                    close=grouped_df["close"],
                    name=choice
                )])

                # Update layout for better visualization
                fig.update_layout(
                    title=f"Candlestick Chart for {choice} (Grouped by Day)",
                    xaxis_title="Date",
                    yaxis_title="Price",
                    xaxis_rangeslider_visible=False
                )

                # Show the chart
                fig.show()