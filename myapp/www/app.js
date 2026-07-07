$(function() {
  $(".loading-page", window.parent.document).remove();

  // Follow the browser back/forward buttons across the navbar tabs by mirroring
  // the active tab in the parent window's URL hash. window.parent is this window
  // when the app isn't in an iframe, so this works standalone and inside the
  // shinylive iframe.
  var sendHash = function() {
    Shiny.setInputValue("url_hash", window.parent.location.hash,
                        {priority: "event"});
  };
  $(document).on("shiny:connected", sendHash);
  $(window.parent).on("hashchange", sendHash);

  // the server records each tab change as a new browser history entry
  Shiny.addCustomMessageHandler("pushHash", function(hash) {
    if (window.parent.location.hash !== hash) {
      window.parent.history.pushState(null, null, hash);
    }
  });
});
