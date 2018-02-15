<!SLIDE >
# Git Repository

* We store and edit code in Git repositories.
* We'll be hosting a server on port 3000 in the classroom.
* Let's ensure that you can reach that port.
* You should see a green logo below.

<div id="gitea"></div>
<p id="gitea_error" class="callout warning" style="display: none;">Sorry, but it appears that you cannot load that port.</p>

<script>
  $(document).ready(function(){
    $("#preso").bind("showoff:loaded", function (event) {
      $("#gitea").html('<img src="http://' + window.location.hostname + ':3000/images/gitea.png" />');

      $("#gitea img").on("error", function() {
        $(this).hide();
        $("#gitea_error").show();
      });
    });
  });
</script>
