<?php
/**
 * @author Albert Peschar <albert@peschar.net>
 */

class Peschar_URLRetriever {
    public function retrieve($url, $post = null) {
        if(($content = $this->retrieveWithCURL($url, $post)) !== false) {
            return $content;
        } elseif(($content = $this->retrieveWithFile($url, $post)) !== false) {
            return $content;
        } else {
            return false;
        }
    }

    public function retrieveWithCURL($url, $post) {
        if(!function_exists('curl_init')) {
            return false;
        }
        if(!($curl = @curl_init($url))) {
            return false;
        }
        $opts = array(
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_SSL_VERIFYPEER => false
        );
        if ($post) {
            $opts[CURLOPT_POST] = true;
            $opts[CURLOPT_POSTFIELDS] = $post;
        }
        if (!@curl_setopt_array($curl, $opts)) {
            return false;
        }
        return @curl_exec($curl);
    }

    public function retrieveWithFile($url) {
        return @file_get_contents($url);
    }
}
