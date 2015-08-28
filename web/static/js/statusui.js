let ui = {};

import channel from "./socket"

function getElementForStatus(id) {
	let existing = document.querySelector(`.main-status-container .status-panel[data-target="${id}"]`);
	if (existing) {
		return existing;
	}
	let panel = document.createElement('div');
	panel.setAttribute('class', 'status-panel');
	panel.setAttribute('data-target', id);
	panel.innerText = id;
	let container = document.querySelector('.main-status-container')
	container.appendChild(panel);
	return panel;
}

channel.on("update", msg => {
	console.log(msg)
	let statusPanel = getElementForStatus(msg.id);
	statusPanel.classList.toggle('status-ok', msg.status === 200);
});

export default ui;
