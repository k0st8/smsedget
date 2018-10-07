<h2><?=$title;?></h2>
<form id="filterData" action="" >

	<div class="form-group">
		<label for="cntID">Select Dates</label>
		<div class="input-daterange input-group" id="datepicker">
	    	<input type="text" class="input-sm form-control" name="fromDate" title="From Date"/>
	    	<span class="input-group-addon">TO</span>
	    	<input type="text" class="input-sm form-control" name="toDate" title="To Date"/>
		</div>
	</div>
	<div class="form-group">
      <label for="cntID">Select from Countries (Optional)</label>
      <select class="form-control" id="cntID" name="cntID">
        <option value=''>Countries</option>
        <?php foreach ($countries as $country): ?>
        	<option value="<?= $country->cnt_id; ?>"><?= $country->cnt_title; ?></option>
        <?php endforeach; ?>
      </select>
    </div>
    <div class="form-group">
      <label for="usrID">Select from Users (Optional)</label>
      <select class="form-control" id="usrID" name="usrID">
        <option value=''>Users</option>
        <?php foreach ($stats as $user): ?>
        	<option value="<?= $user->usr_id; ?>"><?= $user->usr_id; ?></option>
        <?php endforeach; ?>
      </select>
    </div>
    <button type="submit" class="btn btn-primary">Filter</button>
</form>
<table class="table-striped">
	<thead>
		<tr>
			<th>User ID</th>
			<th>Country</th>
			<th>Success</th>
			<th>Failure</th>
			<th>Date</th>
		</tr>
	</thead>
	<tbody id="statResult">
<?php foreach($stats as $stat): ?>
<tr>
	<td><?= $stat->usr_id; ?></td>
	<td><?= $stat->cnt_title; ?></td>
	<td><?= $stat->log_success; ?></td>
	<td><?= $stat->log_fail; ?></td>
	<td><?= $stat->log_created; ?></td>
</tr>
<?php endforeach; ?>
</tbody>
</table>