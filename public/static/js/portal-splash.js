(function () {
    var splash = document.getElementById("portalSplash");
    if (!splash) return;

    document.body.classList.add("portal-loading");

    function dismissSplash() {
        if (splash.classList.contains("done")) return;
        splash.classList.add("done");
        document.body.classList.remove("portal-loading");
    }

    var minDisplay = 2600;
    var start = Date.now();

    window.addEventListener("load", function () {
        var elapsed = Date.now() - start;
        var remaining = Math.max(0, minDisplay - elapsed);
        setTimeout(dismissSplash, remaining);
    });

    setTimeout(dismissSplash, 5000);
})();
