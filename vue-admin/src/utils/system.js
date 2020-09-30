
export function composeUrl(url) {
    let web_site = this.$store.state.settings.webSite;
    let temp = url.substr(0, 4);
    if (temp != 'http') {
        url = web_site.url;
    }        
    return url;
}