/**
 * MRBS Custom Functionality
 * 1. Handles conditional field visibility for Zoom/Hybrid meeting links.
 * 2. Provides real-time validation for the 'How many participants' field.
 */

$(document).on('ready', function() {
    
    // --- 0. Digital Clock ---
    function updateClock() {
        var now = new Date();
        var hours = now.getHours();
        var minutes = now.getMinutes();
        var seconds = now.getSeconds();
        var ampm = hours >= 12 ? 'PM' : 'AM';
        
        hours = hours % 12;
        hours = hours ? hours : 12; // the hour '0' should be '12'
        minutes = minutes < 10 ? '0'+minutes : minutes;
        seconds = seconds < 10 ? '0'+seconds : seconds;
        
        var timeString = hours + ':' + minutes + ':' + seconds + ' ' + ampm;
        $('#digital-clock').text( timeString);
    }
    
    if ($('#digital-clock').length > 0) {
        updateClock();
        setInterval(updateClock, 1000);
    }

    // --- 1. Hybrid Meeting Link Toggle ---
    function toggleMeetingLink() {
        // Now that it's a radio group, we check the value of the selected radio button
        var selectedValue = $('input[name="f_hybrid_facility"]:checked').val();
        var meetingLinkContainer = $('.meeting_link_field');
        var meetingLinkInput = $('input[name="f_meeting_link"]');
        
        // If 'Yes' (value 1) is selected
        if (selectedValue === '1') {
            meetingLinkContainer.attr('style', 'display: flex !important');
            meetingLinkInput.prop('required', true);
        } else {
            meetingLinkContainer.attr('style', 'display: none !important');
            meetingLinkInput.prop('required', false);
            meetingLinkInput.val(''); // Clear the link if no longer hybrid
        }
    }

    // Initialize Hybrid state on page load
    if ($('input[name="f_hybrid_facility"]').length > 0) {
        toggleMeetingLink();
        // Listen for changes on any radio button in the group
        $('input[name="f_hybrid_facility"]').on('change', function() {
            toggleMeetingLink();
        });
    }


    // --- 2. Seat Count Validation ---
    function validateSeatCount() {
        // The field name in MRBS is prefixed with 'f_' for custom fields
        var seatCountField = $('input[name="f_seat_count"]');
        if (seatCountField.length === 0) return;

        var maxCapacity = parseInt(seatCountField.attr('max'));
        var seatCount = parseInt(seatCountField.val());
        var errorDiv = $('#seat_count_error');

        if (!isNaN(seatCount) && !isNaN(maxCapacity) && seatCount > maxCapacity) {
            seatCountField.css({
                'border-color': '#ff5252',
                'background-color': 'rgba(255, 82, 82, 0.1)'
            });
            errorDiv.text('Error: Number of participants (' + seatCount + ') cannot exceed room capacity (' + maxCapacity + ')!').show();
        } else {
            seatCountField.css({
                'border-color': '',
                'background-color': ''
            });
            errorDiv.hide();
        }
    }

    // Initialize Seat Count validation on page load
    if ($('input[name="f_seat_count"]').length > 0) {
        validateSeatCount();
        
        // Validate on change or input
        $(document).on('input change', 'input[name="f_seat_count"]', function() {
            validateSeatCount();
        });
    }
});
