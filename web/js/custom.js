/**
 * MRBS Custom Functionality
 * 1. Handles conditional field visibility for Zoom/Hybrid meeting links.
 * 2. Provides real-time validation for the 'How many participants' field.
 */

$(document).on('ready page_ready tableload', function() {
    
    // --- 0. Digital Clock ---
    function updateClock() {
        var $clock = $('#digital-clock');
        if ($clock.length === 0) return;

        var now = new Date();
        var hours = now.getHours();
        var minutes = now.getMinutes();
        var seconds = now.getSeconds();
        var ampm = hours >= 12 ? 'PM' : 'AM';
        
        hours = hours % 12;
        hours = hours ? hours : 12; 
        minutes = minutes < 10 ? '0'+minutes : minutes;
        seconds = seconds < 10 ? '0'+seconds : seconds;
        
        var timeString = hours + ':' + minutes + ':' + seconds + ' ' + ampm;
        $clock.text(timeString);
    }
    
    // Clear any existing interval to prevent multiple clocks running
    if (window.clockInterval) {
        clearInterval(window.clockInterval);
    }
    
    if ($('#digital-clock').length > 0) {
        updateClock();
        window.clockInterval = setInterval(updateClock, 1000);
    }

    // --- 1. Hybrid Meeting Link Toggle ---
    function toggleMeetingLink() {
        var selectedValue = $('input[name="f_hybrid_facility"]:checked').val();
        var meetingLinkContainer = $('.meeting_link_field');
        var meetingLinkInput = $('input[name="f_meeting_link"]');
        
        if (selectedValue === '1') {
            meetingLinkContainer.attr('style', 'display: flex !important');
            meetingLinkInput.prop('required', true);
        } else {
            meetingLinkContainer.attr('style', 'display: none !important');
            meetingLinkInput.prop('required', false);
            meetingLinkInput.val(''); 
        }
    }

    if ($('input[name="f_hybrid_facility"]').length > 0) {
        toggleMeetingLink();
        $('input[name="f_hybrid_facility"]').off('change').on('change', function() {
            toggleMeetingLink();
        });
    }


    // --- 2. Seat Count Validation ---
    function validateSeatCount() {
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

    if ($('input[name="f_seat_count"]').length > 0) {
        validateSeatCount();
        $(document).off('input change', 'input[name="f_seat_count"]').on('input change', 'input[name="f_seat_count"]', function() {
            validateSeatCount();
        });
    }

    // --- 3. Message Ticker (Marquee Effect) ---
    $('.message_top').each(function() {
        var $this = $(this);
        if ($this.find('span').length === 0) {
            var text = $this.text();
            $this.empty().append($('<span>').text(text));
        }
    });

    // --- 4. Dynamic Room Capacity Update ---
    function updateMaxCapacity() {
        var $roomSelect = $('#rooms');
        if ($roomSelect.length === 0) return;

        var maxCapacity = 0;
        $roomSelect.find('option:selected').each(function() {
            var capacity = parseInt($(this).attr('data-capacity')) || 0;
            if (capacity > maxCapacity) {
                maxCapacity = capacity;
            }
        });

        // Ensure max capacity cannot be minus
        if (maxCapacity < 0) maxCapacity = 0;

        var $seatCountField = $('input[name="f_seat_count"]');
        if ($seatCountField.length > 0) {
            $seatCountField.attr('max', maxCapacity);
            $seatCountField.attr('min', 0); // Ensure cannot be minus
            
            // Update the hint text
            var $hint = $seatCountField.parent().find('.field_hint');
            if ($hint.length > 0) {
                $hint.text("Max room capacity: " + maxCapacity);
            }
            
            // Re-validate seat count
            validateSeatCount();
        }
    }

    // Listen for room selection changes
    $(document).on('change', '#rooms', function() {
        updateMaxCapacity();
    });

    // Also handle area changes which swap the rooms list
    $(document).on('change', 'select[name="area"]', function() {
        // MRBS dynamic room swapping takes a moment
        setTimeout(updateMaxCapacity, 200);
    });

    // Initial check on load
    updateMaxCapacity();
});
