//= require jquery3

$(document).ready(function() {
    // get_top_artists();
    // get_top_tracks();
});

function get_top_artists() {
    $.ajax({
        url: 'top_artists',
        type: 'post',
        dataType: 'json',
        data: dates(),
        success: function(data) { update_artists(data) },
        error: function(error) {}
    });
}

function get_top_tracks() {
    $.ajax({
        url: 'top_tracks',
        type: 'post',
        dataType: 'json',
        data: dates(),
        success: function(data) { update_tracks(data) },
        error: function(error) {}
    });
}

function dates() {
    let today = new Date();

    return {
        start_date: '2000-01-01',
        end_date: today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate()
    }
}

function update_artists(data) {
    let tableBody = $('#artist-table tbody');

    for (let record of data) {
        let link = '/spotify/' + record[1]['id'] + '/artist';
        let row = "<tr><td><a href=" + link + '>'  + truncate(record[0], 30) + '</a></td><td>' + record[1]['occurrences'] + '</td></tr>';

        tableBody.append(row);
    }
}

function update_tracks(data) {
    let tableBody = $('#track-table tbody');

    for (let record of data) {
        let link = '/spotify/' + record[1]['artist_id'] + '/artist';
        let row = '<tr><td>'  + truncate(record[0], 30) + '</td><td><a href=' + link + '>'  + truncate(record[1]['artist'], 30) + '</a></td><td>' + record[1]['occurrences'] + '</td></tr>';

        tableBody.append(row);
    }
}

function truncate(string, length) {
    if (string.length < length || length < 1) {
        return string
    }

    return string.substring(0, length-1) + '...';
}