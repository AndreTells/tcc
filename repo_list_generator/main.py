from time import sleep,time
import requests 
def extract_next_page_link(link: str)->str|None:
    link_list = link.split(',')
    for labeled_url in link_list: 
        temp =  labeled_url.split(';') 
        if (temp[1].strip() != 'rel="next"'):
            continue

        return temp[0].strip()[1:-1]
    return None 


def main(num_stars:int=50):
    link = f"https://api.github.com/search/repositories?q=language%3AC%20is%3Apublic%20stars%3A%3E%3D{num_stars}"

    while True:
        res = requests.get(link)
        if(res.status_code == 429 or res.status_code == 403):
            sleep(int(int(res.headers['x-ratelimit-reset']) - time())+1)
            continue

        repo_links = map(
            lambda x: x['clone_url'],
            res.json()['items']
        )

        for link in repo_links:
            print(link)

        if('Link' not in res.headers):
            break

        link = extract_next_page_link(res.headers['Link'])
        if(link is None):
            break

main()
