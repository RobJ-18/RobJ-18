import requests
import time

def get_public_ip():
    try:
        # Get the public IP address
        response = requests.get('https://api.ipify.org?format=json')
        ip_address = response.json()['ip']
    except requests.RequestException as e:
        print("Error fetching public IP address:", e)
        ip_address = None
    
    return ip_address

def send_to_discord(ip_address, webhook_url):
    # Create a message payload
    data = {
        "content": f"Vegas IP: {ip_address}"
    }

    # Send request to the Discord webhook URL
    try:
        response = requests.post(webhook_url, json=data)
        if response.status_code == 204:
            print("IP address successfully sent to Discord!")
        else:
            print(f"Failed to send message to Discord. Status code: {response.status_code}")
    except requests.RequestException as e:
        print(f"Error sending to Discord: {e}")

def main():
    # Place your webhook URL here
    webhook_url = 'https://discord.com/api/webhooks/...'

    while True:
        # Get the public IP address
        public_ip = get_public_ip()
        
        if public_ip:
            print(f"Vegas IP: {public_ip}")
            # Send the IP address to Discord
            send_to_discord(public_ip, webhook_url)
        else:
            print("Could not retrieve public IPv4 address.")
        
        # Time to next send
        print("Update to be sent in 1 hour...")
        time.sleep(3600)  # 3600 seconds = 1 hour

if __name__ == '__main__':
    main()
