module.exports = function(data) {
    let jobs = data.targets.map(target => {

        let labels = target.labels.reduce((total, label) => {
            total[label.name.trim()] = label.value.trim();
            return total;
        }, {});

        let meta_labels = {
            "__meta_directus_job": target.job ? target.job.name.trim() : "directus"
        };

        return {
            "targets": [target.address.trim()],
            "labels": { ...meta_labels, ...labels }
        };

    });

    return jobs;
};
