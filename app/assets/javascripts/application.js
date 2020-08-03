//= require jquery3

$(document).ready(function() {
    track_changes();

    $("#save-button").click(function () {
       save_playlist();
    });

    $('#feeling-lucky').click(function () {
        feelingLucky();
    })
});

function track_changes() {
    $(".recommendation-input").each(function() {
        $(this).change(function() {
            if (too_many_checked()) {
                alert("You can only select up to 5 artists");
                this.checked = false;
            } else {
                show_progress_bar();
                update_recommendations();
            }
        });
    });
}

function update_recommendations() {
    $.ajax({
        url: 'recommendation_result',
        type: 'post',
        dataType: 'json',
        data: data_from_inputs(),
        success: function(data) { set_data(data) },
        error: function(error) { handle_error(error) }
    });
}

function playlist_saved(data) {
    alert("Playlist saved successfully");
}

function playlist_save_failed(error) {
    alert("Playlist failed to save");
}

function feelingLucky() {
    $.ajax({
        url: 'feeling_lucky',
        type: 'post',
        dataType: 'json',
        success: function(data) { set_data(data) },
        error: function(error) { handle_error(error) }
    })
}

function save_playlist() {
    $.ajax({
        url: 'save_playlist',
        type: 'post',
        dataType: 'json',
        data: track_data(),
        success: function(data) { playlist_saved(data) },
        error: function(error) { playlist_save_failed(error) }
    });
}

function track_data() {
    let tracks = [];
    $("#recommendation-table tbody:first tr td:last-child").each(function() {
        tracks.push($(this).html())
    });
    return {
        playlist_name: $('#playlist-name').val(),
        tracks: tracks
    };
}

function data_from_inputs() {
    let data = {};
    $(".recommendation-input").each(function() {
        let input = $(this);

        if (input.attr('type') === 'checkbox') {
            if (input.prop('checked') === true) {
                if (input.attr('value') !== '') {
                    data[input.attr('name')] = input.attr('value')
                } else if (input.classList.contains('playlist-size')) {
                    data['playlist_size'] = $('#playlist-size')
                } else {
                    let number = input.attr('id').slice(-1);
                    let jquery_string = "#artist-submit-text-" + number;
                    data['input_artist_' + number] = $(jquery_string).val()
                }
            }
        }

        if (input.attr('type') === 'range') {
            data[input.attr('name')] = input.val()
        }
    });
    return data
}

function set_data(data) {
    let tableBody = $('#recommendation-table tbody');
    tableBody.empty();
    for (let track of data) {
        let row = '<tr><td>' + track.name + '</td><td>' + track.artists.join(', ') + '</td><td>' + track.album + '</td><td hidden>' + track.id + '</td></tr>';

        $('#help-text').hide();
        $('#error-text').hide();
        hide_progress_bar();
        tableBody.append(row);
    }
    show_table();
}

function show_progress_bar() {
    $('#progress-bar').removeClass('is-hidden');
}

function hide_progress_bar() {
    $('#progress-bar').addClass('is-hidden');
}

function show_table() {
    $('#recommendation-table').show();
    $('#save-button').removeClass('is-hidden');
    $('#playlist-name').removeClass('is-hidden');
}

function handle_error(error) {
    hide_progress_bar();
    $('#help-text').show();
    $('#error-text').show();
    $('#recommendation-table').hide();
    $('#save-button').addClass('is-hidden');
    $('#playlist-name').addClass('is-hidden');
}

function too_many_checked() {
    return ($('input[type=checkbox]:checked').length > 5)
}