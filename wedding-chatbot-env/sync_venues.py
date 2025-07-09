# sync_venues.py
import requests
import os
import time
from threading import Timer

NODE_API_URL = 'http://localhost:5000/export-json'
SAVE_PATH = 'venue_data.json'

def sync_venue_data():
    try:
        print(f"🔄 Syncing venue data from {NODE_API_URL}...")
        response = requests.get(NODE_API_URL)
        if response.status_code == 200:
            with open(SAVE_PATH, 'wb') as f:
                f.write(response.content)
            print(f"✅ Venue data synced at {time.strftime('%Y-%m-%d %H:%M:%S')}")
            return True
        else:
            print(f"❌ Sync failed: HTTP {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ Sync error: {str(e)}")
        return False

def schedule_sync(interval=3600):  # 3600 seconds = 1 hour
    def wrapper():
        sync_venue_data()
        # Reschedule the timer
        Timer(interval, wrapper).start()
    
    # Initial start
    Timer(interval, wrapper).start()

if __name__ == '__main__':
    print("🚀 Starting venue data sync service")
    print(f"⏰ Will sync every hour to {SAVE_PATH}")
    
    # Run immediately on startup
    sync_venue_data()
    
    # Start the recurring schedule
    schedule_sync()