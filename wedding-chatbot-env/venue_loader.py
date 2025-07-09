import json
import os

def load_venue_data(file_path='venue_data.json'):
    try:
        with open(file_path, 'r') as f:
            data = json.load(f)
        print(f"✅ Loaded {len(data)} venues from {file_path}")
        return data
    except FileNotFoundError:
        print(f"❌ File not found: {file_path}")
        return []
    except json.JSONDecodeError:
        print(f"❌ Invalid JSON in {file_path}")
        return []

def get_hall_by_name(name, venues):
    name_lower = name.lower()
    for venue in venues:
        if name_lower in venue['name'].lower():
            return venue
    return None

# Sample usage
if __name__ == '__main__':
    venues = load_venue_data()
    azure = get_hall_by_name("Azure", venues)
    
    if azure:
        print(f"\nAzure Gardens Details:")
        print(f"Location: {azure['location']}")
        print(f"Capacity: {azure['capacity']}")
        print("Services:")
        for service in azure['services']:
            print(f"- {service['name']}: ${service['price']} {service['type']}")
    else:
        print("Venue not found")