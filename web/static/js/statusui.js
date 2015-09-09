let ui = {};

import channel from "./socket"

let fullStatus;

function init() {
	fetch('/status').then(function (response) {
		console.log('in then', response);
		console.dir(response);
		return response.json();
	}).then(function (response) {
		fullStatus = response.status;
		var services = Object.keys(fullStatus);
		services.forEach(function (serviceName) {
			fullStatus[serviceName].forEach(function (serviceInstanceStatus) {
				let el = getElementForStatus(serviceInstanceStatus.url, serviceName);
				let serviceIsOk = serviceInstanceStatus.status.last_status === 200;
				el.classList.toggle('status-ok', serviceIsOk);
			});
			updateGroupStatus(serviceName);
		});
	});
	console.log('fetching status');
}
init();

function getElementForStatus(id, group) {
	let existing = document.querySelector(`.main-status-container .status-group-panel .status-panel[data-target="${id}"]`);
	if (existing) {
		return existing;
	}
	let panel = document.createElement('div');
	panel.setAttribute('class', 'status-panel');
	panel.setAttribute('data-target', id);
	panel.innerText = id;
	let container = getStatusGroupPanel(group || id)
	container.appendChild(panel);
	return panel;
}

function getStatusGroupPanel(groupName) {
	let existing = document.querySelector(`.main-status-container .status-group-panel[data-group-name="${groupName}"]`);
	if (existing) {
		return existing;
	}
	let panel = document.createElement('div');
	panel.setAttribute('class', 'status-group-panel');
	panel.setAttribute('data-group-name', groupName);
	panel.innerText = groupName;
	let container = document.querySelector('.main-status-container')
	container.appendChild(panel);
	return panel;
}

function updateGroupStatus(groupName) {
	let groupPanel = document.querySelector(`.main-status-container .status-group-panel[data-group-name="${groupName}"]`);
	let badInstances = groupPanel.querySelector('.status-panel:not(.status-ok)')
	let goodInstances = groupPanel.querySelector('.status-panel.status-ok')
	groupPanel.classList.toggle('status-ok', !badInstances);
	groupPanel.classList.toggle('status-partial', (badInstances && goodInstances))
}

channel.on("update", msg => {
	console.log(msg)

	if (!fullStatus || !msg.instance_url) {
		return;
	}

	console.log(`update for ${msg.service_name} ${msg.instance_url}`);
	let statusPanel = getElementForStatus(msg.instance_url, msg.service_name);
	statusPanel.classList.toggle('status-ok', msg.status === 200);
	updateGroupStatus(msg.service_name);
});

export default ui;
