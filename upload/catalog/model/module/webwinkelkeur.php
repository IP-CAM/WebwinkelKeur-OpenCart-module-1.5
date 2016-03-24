<?php
require_once DIR_SYSTEM . 'library/Peschar_URLRetriever.php';
class ModelModuleWebwinkelkeur extends Model {
    private function getOrdersToInvite($settings) {
        $max_time = time() - 1800;

        $where = array();

        if($this->getMultistore())
            $where[] = 'o.store_id = ' . (int) $this->config->get('config_store_id');

        if(empty($settings['order_statuses']))
            $where[] = '0';
        else
            $where[] = 'o.order_status_id IN (' . implode(',', array_map('intval', $settings['order_statuses'])) . ')';

        if(empty($where))
            $where = '0';
        else
            $where = implode(' AND ', $where);

        $query = $this->db->query($q="
            SELECT o.*, l.code as language_code
            FROM `" . DB_PREFIX . "order` o
            LEFT JOIN `" . DB_PREFIX . "language` l USING(language_id)
            WHERE
                o.webwinkelkeur_invite_sent = 0
                AND o.webwinkelkeur_invite_tries < 10
                AND o.webwinkelkeur_invite_time < $max_time
                AND $where
        ");

        return $query->rows;
    }

    public function sendInvites() {
        $settings = $this->getSettings();

        if(empty($settings['shop_id']) ||
           empty($settings['api_key']) ||
           empty($settings['invite'])
        )
            continue;

        foreach($this->getOrdersToInvite($settings) as $order) {
            $this->db->query("
                UPDATE `" . DB_PREFIX . "order`
                SET
                    webwinkelkeur_invite_tries = webwinkelkeur_invite_tries + 1,
                    webwinkelkeur_invite_time = " . time() . "
                WHERE
                    order_id = " . $order['order_id'] . "
                    AND webwinkelkeur_invite_tries = " . $order['webwinkelkeur_invite_tries'] . "
                    AND webwinkelkeur_invite_time = " . $order['webwinkelkeur_invite_time'] . "
            ");
            if($this->db->countAffected()) {
                $parameters = array(
                    'id'        => $settings['shop_id'],
                    'password'  => $settings['api_key'],
                    'email'     => $order['email'],
                    'order'     => $order['order_id'],
                    'delay'     => $settings['invite_delay'],
                    'lang'      => str_replace('-', '_', $order['language_code']),
                    'customername' => "$order[payment_firstname] $order[payment_lastname]",
                    'client'    => 'opencart',
                );
                if($settings['invite'] == 2)
                    $parameters['noremail'] = '1';
                $url = 'http://www.webwinkelkeur.nl/api.php?' . http_build_query($parameters);
                $retriever = new Peschar_URLRetriever();
                $response = $retriever->retrieve($url);
                if(preg_match('|^Success:|', $response) || preg_match('|invite already sent|', $response)) {
                    $this->db->query("UPDATE `" . DB_PREFIX . "order` SET webwinkelkeur_invite_sent = 1 WHERE order_id = " . $order['order_id']);
                } else {
                    $this->db->query("INSERT INTO `" . DB_PREFIX . "webwinkelkeur_invite_error` SET url = '" . $this->db->escape($url) . "', response = '" . $this->db->escape($response) . "', time = " . time());
                }
            }
        }
    }

    public function getSettings() {
        $this->load->model('setting/setting');

        $settings = $this->getSetting('webwinkelkeur');

        if(!empty($settings['multistore'])
           && ($store_id = $this->config->get('config_store_id'))
        ) {
            if(empty($settings['store'][$store_id]))
                return array();
            return $settings['store'][$store_id];
        } else {
            return $settings;
        }
    }

    public function getMultistore() {
        $this->load->model('setting/setting');

        $settings = $this->getSetting('webwinkelkeur');

        return !empty($settings['multistore']);
    }

    public function getSetting($group, $store_id = 0) {
        $data = array(); 
        
        $query = $this->db->query("SELECT * FROM " . DB_PREFIX . "setting WHERE store_id = '" . (int)$store_id . "' AND `group` = '" . $this->db->escape($group) . "'");
        
        foreach ($query->rows as $result) {
            if (!$result['serialized']) {
                $data[$result['key']] = $result['value'];
            } else {
                $data[$result['key']] = unserialize($result['value']);
            }
        }

        return $data;
    }
}
