<!SLIDE >
# Classroom Presentation

* Our presentation server allows you to interact with your instructor.
* Let's make sure you can connect back to the server.
    1. Open the menu in the upper left of the page.
    1. Make sure there is not a *disconnected* icon.
    1. Make sure that the buttons are not greyed out.
 
<input type="button" value="Get Started" onclick="showTour('showoff:menu', false)" />
    
<script type="text/javascript">
  // overwrite the stock messages
  tours['showoff:menu'] = [
    {
      element: "#hamburger",
      intro: "Click here to open the menu."
    },
    {
      element: "#feedbackSidebar h3",
      intro: "There should be no <i>disconnected</i> icon here."
    },
    {
      element: "#paceFaster",
      intro: "These buttons should not be greyed out."
    },
    {
      element: "#questionToggle",
      intro: "Clicking this button should open a dialog allowing you to post a question. This is the last test in this series."
    }
  ];
</script>
