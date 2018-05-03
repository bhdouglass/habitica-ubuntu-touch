function handler(event) {
    console.log('Injecting ubuntu touch styling fixes');

    var style = document.createElement('style');
    style.type = 'text/css';
    style.appendChild(document.createTextNode(
        '.useMobileApp { display: none !important; } ' +
        '.drawer-container { max-width: 94% !important; left: 3% !important; } ' +
        '.spell-container .mana { display: none !important; } ' +
        '.member-stats .progress-container .progress { min-width: 100px !important; } ' +
        '#loading-screen-inapp p { width: 100% !important; } ' +
        '.spell .details { padding: 0 !important; text-align: center !important; flex: 0 0 100% !important; max-width: 100% !important; } '
    ));

    document.head.appendChild(style);
}

window.addEventListener('load', handler, false);
