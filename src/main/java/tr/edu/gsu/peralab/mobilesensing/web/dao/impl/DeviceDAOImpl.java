package tr.edu.gsu.peralab.mobilesensing.web.dao.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.stereotype.Repository;

import tr.edu.gsu.peralab.mobilesensing.web.constant.SQLQuery;
import tr.edu.gsu.peralab.mobilesensing.web.dao.DeviceDAO;
import tr.edu.gsu.peralab.mobilesensing.web.dao.JDBCBaseDAO;
import tr.edu.gsu.peralab.mobilesensing.web.dao.rowmapper.LocationRowMapper;
import tr.edu.gsu.peralab.mobilesensing.web.dao.rowmapper.UserRowMapper;
import tr.edu.gsu.peralab.mobilesensing.web.entity.Activity;
import tr.edu.gsu.peralab.mobilesensing.web.entity.Device;
import tr.edu.gsu.peralab.mobilesensing.web.entity.Location;
import tr.edu.gsu.peralab.mobilesensing.web.entity.User;
import tr.edu.gsu.peralab.mobilesensing.web.util.DateUtil;

@Repository
public class DeviceDAOImpl extends JDBCBaseDAO implements DeviceDAO {

	@Override
	public Device retrieveDeviceDetail(String userName) {
		User user = (User) getJdbcTemplate().queryForObject(
				SQLQuery.GET_USER_BY_USERNAME.getValue(),
				new Object[] { userName }, new UserRowMapper());

		String phoneActQuery = "SELECT extra FROM mobilesensing.phoneactdata"
				+ "_" + userName + "_" + user.getUserId();

		String batteryLevel = null;
		String runningApplications = null;
		Device device = new Device();
		try {
			batteryLevel = getJdbcTemplate()
					.queryForObject(
							phoneActQuery
									+ " WHERE Feature = 'Battery' AND Field = 'Battery Level' ORDER BY time DESC LIMIT 1",
							String.class);
			runningApplications = getJdbcTemplate()
					.queryForObject(
							phoneActQuery
									+ " WHERE Feature = 'Application' AND Field = 'Running Applications' ORDER BY time DESC LIMIT 1",
							String.class);
			batteryLevel = batteryLevel.substring(0, batteryLevel.length() - 1);
			device.setBatteryLevel(batteryLevel);
			device.setRunningApplicationNumber(runningApplications);
			device.setName(userName);
		} catch (EmptyResultDataAccessException e) {
			logger.warn(e);
		}
		return device;
	}

	@Override
	public Location retriveDeviceLocation(String userName) {
		User user = (User) getJdbcTemplate().queryForObject(
				SQLQuery.GET_USER_BY_USERNAME.getValue(),
				new Object[] { userName }, new UserRowMapper());
		Location location = null;
		try {
			String locationQuery = "SELECT provider,latitude, longitude FROM mobilesensing.locationinfodata"
					+ "_" + userName + "_" + user.getUserId();
			location = (Location) getJdbcTemplate().queryForObject(
					locationQuery + " ORDER BY time DESC LIMIT 1",
					new LocationRowMapper());
		} catch (EmptyResultDataAccessException e) {
			logger.warn(e);
		}
		return location;
	}

	@Override
	public List<Activity> retrieveUserActivity(String userName, long startTime,
			long endTime) {
		List<Activity> activities = new ArrayList<Activity>();
		User user = (User) getJdbcTemplate().queryForObject(
				SQLQuery.GET_USER_BY_USERNAME.getValue(),
				new Object[] { userName }, new UserRowMapper());

		String startTimeStr = DateUtil.convertTimestampToDbDate(startTime);
		String endTimeStr = DateUtil.convertTimestampToDbDate(endTime);

		String activityQuery = "SELECT actfeatures.act FROM mobilesensing.actfeaturesdata"
				+ "_"
				+ userName
				+ "_"
				+ user.getUserId()
				+ " actfeatures  WHERE  STR_TO_DATE(actfeatures.time, '%d.%m.%Y_%H:%i:%s') >= '"
				+ startTimeStr
				+ "' AND STR_TO_DATE(actfeatures.time, '%d.%m.%Y_%H:%i:%s') <= '"
				+ endTimeStr + "'";

		List<Map<String, Object>> rows = getJdbcTemplate().queryForList(
				activityQuery);
		for (Map<String, Object> row : rows) {
			activities.add(Activity.valueOf((String) row.get("act")));
		}
		return activities;
	}

}
