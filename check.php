<?php
date_default_timezone_set('America/Los_Angeles');

function convert_time($time_string, $to_tz, $from_tz) {
	$USER_DATE_FORMAT = 'l, F j, Y g:ia T';
	try {
		$datetime = new DateTime($time_string, new DateTimeZone($from_tz));
		return $datetime->setTimezone(new DateTimeZone($to_tz))->format($USER_DATE_FORMAT);
	} catch(Exception $e) {
		return date($USER_DATE_FORMAT, strtotime($time_string)) . ' EST';
	}
}

$db = new mysqli('host', 'user', 'pass');
$db->query("INSERT INTO ikea.log (event) VALUES ('Start');");
$ch = curl_init();
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
$result = $db->query("SELECT DISTINCT store_id, article_number FROM ikea.requests WHERE active = '1';"); //Check performance vs GROUP BY

while($row = $result->fetch_object()) {
	curl_setopt($ch, CURLOPT_URL, 'http://m.ikea.com/us/en/store/availability/?storeCode=' . str_pad($row->store_id, 3, 0, STR_PAD_LEFT) . "&itemType=art&itemNo={$row->article_number}");
	$text = curl_exec($ch);

	$text = str_replace('<hr class="divider">', null, $text);


	if($xml = @simplexml_load_string("<a>$text</div></div></a>")) { //In stock, good HTML
		$db->query("INSERT IGNORE INTO ikea.stock (article_number, store_id, time, stock) VALUES ({$row->article_number}, {$row->store_id}, '" . date('Y-m-d H:i:s', strtotime("{$xml->div->div->p->span[0]} {$xml->div->div->p->span[1]}")) . "', {$xml->div->h3->b});");
	} elseif($xml = @simplexml_load_string("<a>$text</a>")) { //Not in stock, good HTML
		$db->query("INSERT IGNORE INTO ikea.stock (article_number, store_id, time, stock) VALUES ({$row->article_number}, {$row->store_id}, '" . date('Y-m-d H:i:s', strtotime("{$xml->div->div->p->span[0]} {$xml->div->div->p->span[1]}")) . "', 0);");
	} else {
		echo 'Could not parse HTML';
	}
}
curl_close($ch);
$result->close();

///////////////////////////////

$result = $db->query("SELECT r.email_address, r.created_at, r.user_tz, s.stock, s.time, p.name, p.description, st.city FROM ikea.requests r NATURAL JOIN ikea.stock s LEFT JOIN ikea.products p ON r.article_number = p.article_number LEFT JOIN ikea.stores st on r.store_id = st.store_id WHERE s.stock > r.desired_level AND r.active = '1' ORDER BY s.stock_id DESC GROUP BY r.request_id");
if($result->num_rows) {
	$db->query("INSERT INTO ikea.log (event, number) VALUES ('Email', {$result->num_rows});");

	while($row = $result->fetch_object()) {
		echo "Your alert for {$row->name} {$row->description} created " . convert_time($row->created_at, $row->user_tz, date_default_timezone_get()) . " now has {$row->stock} pieces in stock at the {$row->city} Ikea as of " . convert_time($row->time, $row->user_tz, 'America/New_York');
	}
}
$result->close();

$db->query("INSERT INTO ikea.log (event) VALUES ('End');");