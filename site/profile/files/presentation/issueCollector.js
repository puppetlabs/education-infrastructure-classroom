$(document).ready(function(){
  jQuery.ajax({
      url: "https://tickets.puppetlabs.com/s/659529536b296109c093d0e787c9c41f-T/-ha9v1j/75006/e63b6717cbf4e060f06cf070bbe5d711/2.0.24/_/download/batch/com.atlassian.jira.collector.plugin.jira-issue-collector-plugin:issuecollector-embededjs/com.atlassian.jira.collector.plugin.jira-issue-collector-plugin:issuecollector-embededjs.js?locale=en-US&collectorId=e6e3f94c",
      type: "get",
      cache: true,
      dataType: "script"
  }).fail(function() {
    $(".callout.info.jira").hide();
    $(".callout.info.fallback").show();
  });

  window.ATL_JQ_PAGE_PROPS =  {
    triggerFunction: function(showCollectorDialog) {
      jQuery("#report").click(function(e) {
        //e.preventDefault();
        showCollectorDialog();
      })
    }
  };
});
