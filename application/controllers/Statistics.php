<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Statistics extends CI_Controller {
	 
	public function index()
	{
		$data['title'] = 'Statistics';
		
	
		$getData = $this->input->get(NULL,true);
		$data['filtered'] = array();
		if(!empty($getData)){
			$data['filtered'] = $this->Statistics_model
			->getFilteredStats($getData['fromDate'], $getData['toDate'], $getData['cntID'], $getData['usrID']);	
		}
		
		$data['stats'] = empty($data['filtered']) ? $this->Statistics_model->getStatistics() : $data['filtered'];
		$data['countries'] = $this->Statistics_model->getCountries();



		$this->load->view('templates/header');
		$this->load->view('statistics/index', $data);
		$this->load->view('templates/footer');
	}

	public function getFilteredData()
	{
		$getData = $this->input->get(NULL,true);
		$data['filtered'] = $this->Statistics_model
		->getFilteredStats($getData['fromDate'], $getData['toDate'], $getData['cntID'], $getData['usrID']);
		# code...
		echo json_encode($data['filtered']);
	}
}
