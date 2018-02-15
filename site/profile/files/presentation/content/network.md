<!SLIDE >
# Network Validation

* Video conferences always work better with a good connection.
* Let's see what you've got.
* We'd like to see at least 1.5Mbps here.

<input id="networkTest" type="button" value="Test Connection" onclick="testNetwork()" />

<script type="text/javascript">
  function testNetwork() {
    $("#networkTest").replaceWith('<iframe src="https://fast.com" width="100%" height="400" scrolling="no"></iframe>');
  }
</script>
