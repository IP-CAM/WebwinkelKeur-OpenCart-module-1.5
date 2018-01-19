<?php if ($run_cron):?>
<div style="
    position: absolute;
    top: -9999em;
    left: -9999em;
    background: url(<?php echo $cron_url; ?>);
"></div>
<?php endif;?>
<?php if(isset($settings)): ?>
<script type="text/javascript">
(function() {
    <?php foreach($settings as $key => $value): ?>
    <?php echo $key; ?> = <?php echo json_encode($value); ?>;
    <?php endforeach; ?>
    var js = document.createElement("script"); js.type = "text/javascript";
    js.async = true; js.src = "//www.webwinkelkeur.nl/js/sidebar.js";
    var s = document.getElementsByTagName("script")[0]; s.parentNode.insertBefore(js, s);
})();
</script>
<?php endif; ?>
<?php if(isset($rich_snippet)): ?>
<?php echo $rich_snippet; ?>
<?php endif; ?>
<?php // vim: set ft=php :
