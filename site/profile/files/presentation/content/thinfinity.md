<!SLIDE >
# Windows Desktops

* Some Puppet training classes incorporate Windows clients.
* Skip this test if you are not registered in one of:
  * Puppetizing Infrastructure
  * Puppet Essentials for Windows
* We provide both native RDP and a web based remote access client.
* If you see a logo below then your firewall allows RDP access.

<div id="rdp"></div>

<input type="button" value="Test HTML Client" onclick="window.open('https://cloud.thinrdp.net/WordPad/')" />

<script>
  $(document).ready(function(){
    $("#preso").bind("showoff:loaded", function (event) {
      $("#rdp").html('<img src="http://' + window.location.hostname + ':3389/images/rdp.png" />');

      $("#rdp img").on("error", function() {
        $(this).hide();
      });
    });
  });
</script>
