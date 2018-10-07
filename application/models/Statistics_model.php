<?php 
defined('BASEPATH') OR exit('No direct script access allowed');

/**
* 
*/
class Statistics_model extends CI_Model
{
	
	public function __construct()
	{
		$this->load->database();
	}

	public function getStatistics()
	{
		$sql = 'SELECT usr_id, cnt_title, log_created, log_success, log_fail FROM send_log_aggregated, countries  WHERE ';
		$sql .= ' send_log_aggregated.cnt_id=countries.cnt_id ORDER BY log_created';
		$q = $this->db->query($sql);
		return $q->result();
	}

	public function getCountries($byCountryId='')
	{
		$sql = 'SELECT * FROM countries';
		if(!empty($byCountryId)){
			$sql .= ' WHERE cnt_id=?';
			// Prepared statement
			return $this->db->query($sql, array($byCountryId))->result();
		} 

		return $this->db->query($sql)->result();
	}

	public function getFilteredStats($fromDate,$toDate,$countryID = '', $userID = '')
	{
		$sql = 'SELECT usr_id, cnt_title, log_created, log_success, log_fail FROM send_log_aggregated, countries  WHERE ';
		$sql .= ' send_log_aggregated.cnt_id=countries.cnt_id AND ';
		$sql .= 'log_created BETWEEN ? AND ? ';
		$prep = array($fromDate, $toDate);
			
		if(!empty($countryID)){
			$sql .= 'AND send_log_aggregated.cnt_id = ? ';
			$prep[] = $countryID;	
		}
		if (!empty($userID)) {
			$sql .= 'AND usr_id = ? ';
			$prep[] = $userID;		
		}
		$sql .= ' ORDER BY log_created';

		return $this->db->query($sql, $prep)->result();
	}
}