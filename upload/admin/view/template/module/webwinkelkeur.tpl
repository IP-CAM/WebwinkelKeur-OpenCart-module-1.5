<?php echo $header; ?>
<div id="content">
  <div class="breadcrumb">
    <?php foreach ($breadcrumbs as $breadcrumb) { ?>
    <?php echo $breadcrumb['separator']; ?><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
    <?php } ?>
  </div>
  <?php if ($error_warning) { ?>
  <?php foreach ($error_warning as $error_message): ?>
  <div class="warning"><?php echo $error_message; ?></div>
  <?php endforeach; ?>
  <?php } ?>
  <form action="" method="post" enctype="multipart/form-data" id="form" name="webwinkelkeur">
    <div class="box">
      <div class="heading">
        <h1><img src="view/image/information.png" alt="" /> WebwinkelKeur</h1>
        <div class="buttons"><a onclick="$('#form').submit();" class="button">Opslaan</a><a href="<?php echo $cancel; ?>" class="button">Annuleren</a></div>
      </div>
      <div class="content" style="min-height:0;">
        <table class="form">
          <?php if($stores): ?>
          <tr>
            <td>Multi-store:</td>
            <td>
              <label>
                <input type="radio" name="multistore" value="0" <?php if(!$multistore) echo "checked"; ?> onchange="document.forms.webwinkelkeur.submit();" />
                Gebruik dezelfde instellingen voor elke winkel
              </label><br />
              <label>
                <input type="radio" name="multistore" value="1" <?php if($multistore) echo "checked"; ?> onchange="document.forms.webwinkelkeur.submit();" />
                Configureer de module voor elke winkel
              </label>
            </td>
          </tr>
          <?php endif; ?>
          <?php foreach($view_stores as $store): ?>
          <?php if($multistore): ?>
        </table>
      </div>
    </div>
    <div class="box">
      <div class="heading">
        <h1><?php echo $store['name']; ?></h1>
        <div class="buttons"><a onclick="$('#form').submit();" class="button">Opslaan</a><a href="<?php echo $cancel; ?>" class="button">Annuleren</a></div>
      </div>
      <div class="content">
        <?php if($store['store_id']): ?>
        <input type="hidden" name="store[<?php echo $store['store_id']; ?>][store_name]" value="<?php echo $store['name']; ?>" />
        <?php endif; ?>
        <table class="form">
          <?php endif; ?>
          <tr>
            <td><span class="required">*</span> Webwinkel ID:</td>
            <td><input type="text" name="<?php printf($store['field_name'], 'shop_id'); ?>" value="<?php echo $store['settings']['shop_id']; ?>" /></td>
          </tr>
          <tr>
            <td><span class="required">*</span> API key:</td>
            <td><input type="text" name="<?php printf($store['field_name'], 'api_key'); ?>" value="<?php echo $store['settings']['api_key']; ?>" /></td>
          </tr>
          <tr>
            <td>
              JavaScript-integratie:<br />
              <span class="help">Gebruik de JavaScript-integratie om de sidebar en de tooltip op je site te plaatsen. Alle instellingen voor de sidebar en de tooltip, vind je in het <a href="https://dashboard.webwinkelkeur.nl/integration" target="_blank">WebwinkelKeur Dashboard</a>.</span>
            </td>
            <td>
              <label>
                <input type="radio" name="<?php printf($store['field_name'], 'javascript'); ?>" value="1" <?php if($store['settings']['javascript']) echo "checked"; ?> />
                Ja
              </label>
              <label>
                <input type="radio" name="<?php printf($store['field_name'], 'javascript'); ?>" value="0" <?php if(!$store['settings']['javascript']) echo "checked"; ?> />
                Nee
              </label>
            </td>
          </tr>
          <tr>
            <td>
              Uitnodiging versturen:<br />
              <span class="help">alleen beschikbaar voor Plus-leden</span>
            </td>
            <td>
              <label>
                <input type="radio" name="<?php printf($store['field_name'], 'invite'); ?>" value="1" <?php if($store['settings']['invite'] == 1) echo "checked"; ?> />
                Ja, na elke bestelling
              </label><br />
              <label>
                <input type="radio" name="<?php printf($store['field_name'], 'invite'); ?>" value="2" <?php if($store['settings']['invite'] == 2) echo "checked"; ?> />
                Ja, alleen bij de eerste bestelling
              </label><br />
              <label>
                <input type="radio" name="<?php printf($store['field_name'], 'invite'); ?>" value="0" <?php if(!$store['settings']['invite']) echo "checked"; ?> />
                Nee, geen uitnodigingen versturen
              </label>
            </td>
          </tr>
          <tr>
            <td>
              Wachttijd voor uitnodiging:<br/>
              <span class="help">de uitnodiging wordt verstuurd nadat het opgegeven aantal dagen is verstreken</span>
            </td>
            <td><input type="text" name="<?php printf($store['field_name'], 'invite_delay'); ?>" size="2" value="<?php echo $store['settings']['invite_delay']; ?>" /></td>
          </tr>
          <tr>
            <td>
              Orderstatus voor uitnodiging:<br />
              <span class="help">de uitnodiging wordt alleen verstuurd wanneer de bestelling de aangevinkte status heeft</span>
            </td>
            <td class="webwinkelkeur-order-statuses">
              <?php foreach($order_statuses as $order_status): ?>
              <label style="display:block;width:200px;overflow:hidden;float:left;">
                <input type="checkbox" name="<?php printf($store['field_name'], 'order_statuses'); ?>[]" value="<?php echo $order_status['order_status_id']; ?>" <?php if(in_array($order_status['order_status_id'], $store['settings']['order_statuses'])) echo 'checked'; ?> />
                <?php echo $order_status['name']; ?>
              </label>
              <?php endforeach; ?>
              <div style="clear:both;"></div>
            </td>
          </tr>
          <tr>
            <td>
              Rich snippet sterren:<br/>
              <span class="help">Voeg een <a href="https://support.google.com/webmasters/answer/99170?hl=nl">rich snippet</a> toe aan de footer. Google kan uw waardering dan in de zoekresultaten tonen. Gebruik op eigen risico.</span>
            </td>
            <td>
              <label>
                <input type="radio" name="<?php printf($store['field_name'], 'rich_snippet'); ?>" value="1" <?php if($store['settings']['rich_snippet']) echo "checked"; ?> />
                Ja
              </label>
              <label>
                <input type="radio" name="<?php printf($store['field_name'], 'rich_snippet'); ?>" value="0" <?php if(!$store['settings']['rich_snippet']) echo "checked"; ?> />
                Nee
              </label>
            </td>
          </tr>
          <?php endforeach; ?>
        </table>
      </div>
    </div>
  </form>
  <?php if($invite_errors): ?>
  <div class="box">
    <div class="heading">
      <h1><img src="view/image/warning.png" alt="" /> Fouten opgetreden bij het versturen van uitnodigingen</h1>
    </div>
    <div class="content">
      <table>
        <?php foreach($invite_errors as $invite_error): ?>
        <tr>
          <td style="padding-right:10px;"><?php echo date('d-m-Y H:i', $invite_error['time']); ?></td>
          <td>
            <?php if($invite_error['response']): ?>
            <?php echo htmlentities($invite_error['response'], ENT_QUOTES, 'UTF-8'); ?>
            <?php else: ?>
            De Webwinkelkeur-server kon niet worden bereikt.
            <?php endif; ?>
          </td>
        </tr>
        <?php endforeach; ?>
      </table>
    </div>
  </div>
  <?php endif; ?>
</div>
<script>
jQuery(function($) {
    var $container = $('.webwinkelkeur-order-statuses');
    $container.find('label:has(input:checked)').css('font-weight', 'bold');
    $container.find('input').change(function() {
        this.parentNode.style.fontWeight = this.checked ? 'bold' : 'normal';
    });
});
</script>
<?php echo $footer; ?>
<?php // vim: set sw=2 sts=2 et ft=php :
