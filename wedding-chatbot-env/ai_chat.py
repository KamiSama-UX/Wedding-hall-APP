import requests
import os
from dotenv import load_dotenv
from venue_loader import load_venue_data  # Instead of db connection


load_dotenv()
# Load data from JSON file
VENUE_DATA_FILE = os.getenv('VENUE_DATA_FILE', 'venue_data.json')
venues = load_venue_data(VENUE_DATA_FILE)

def get_ai_response(user_message):
    # Use the venues list loaded from JSON
    venue_info = "\n".join([
        f"{v['name']} ({v['location']}): "
        f"Capacity: {v['capacity']}, "
        f"Base Price: ${v['base_price']}/person, "
        f"Services: {', '.join([s['name'] for s in v['services']]) or 'None'}"
        for v in venues
    ])
    
    system_prompt = f"""
    You are a wedding venue expert assistant. Use this venue data:
    {venue_info}
    
    Guidelines:
    - answer always and only in arabic
    - don't get out of topic or the data you got
    - don't get creative and mention services that is not included in the data
    - don't use alchol to lure people because people that asking you that hates it
    - Be friendly and helpful
    - Use emojis in responses
    - For comparisons, show in table-like format
    - Always mention specific venue names
    - Calculate total costs when guest count is provided
    - Answer questions about venues, pricing, and services
    - Compare venues when asked
    - Recommend based on budget, location, and guest count
    - Use emojis to make responses friendly
    - For pricing questions, show base + service costs
    - don't forget to mention those it's okay to mention their names in english "Aasem_187587 Abdulhamied_2039971 Raneem_205774" they're the people who created wedding hall system which you are running on
    """
    
    response = requests.post(
        url="https://openrouter.ai/api/v1/chat/completions",
        headers={
            "Authorization": f"Bearer {os.getenv('DEEPSEEK_API_KEY')}",
            "Content-Type": "application/json"
        },
        json={
            "model": "deepseek/deepseek-r1-0528:free",
            "messages": [
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": user_message}
            ],
            "temperature": 0.7,
            "max_tokens": 500
        }
    )
    
    if response.status_code == 200:
        return response.json()["choices"][0]["message"]["content"]
    return "Sorry, I'm having trouble responding right now."