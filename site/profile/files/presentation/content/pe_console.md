<!SLIDE >
# Puppet Enterprise Console

* You'll interact with the PE Console in your class
* It's secured with a self-signed SSL certificate.
* Let's make sure you can accept and use the certificate.

<input id="consoleTest" type="button" value="Test Certificates" onclick="testConsole()" />

<script type="text/javascript">
  function testConsole() {
    $("#consoleTest").replaceWith('<iframe src="https://classroom.puppet.com/ssltest.html" width="100%" height="400" scrolling="no"></iframe>');
  }
</script>
