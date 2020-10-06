import defaultSettings from '@/settings.js'

export function composeUrl(url) {    
    let web_site = defaultSettings.webSite;
    let temp = url.substr(0, 4);
    if (temp != 'http' && url) {
        url = web_site+url;
    }        
    return url;
}