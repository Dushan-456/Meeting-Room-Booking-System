/**
 * Custom JavaScript for MRBS
 * Provides real-time validation for the 'How many participants' field.
 */

(function() {
    'use strict';

    function validateSeatCount() {
        // The field name in MRBS is prefixed with 'f_' for custom fields
        const seatCountInput = document.querySelector('input[name="f_seat_count"]');
        const errorDiv = document.getElementById('seat_count_error');

        if (!seatCountInput || !errorDiv) return;

        const checkValue = () => {
            const val = parseInt(seatCountInput.value, 10);
            const max = parseInt(seatCountInput.getAttribute('max'), 10);

            if (!isNaN(val) && !isNaN(max) && val > max) {
                errorDiv.style.display = 'block';
                seatCountInput.style.backgroundColor = '#fff3f3';
                seatCountInput.style.borderColor = '#ff5252';
                seatCountInput.style.boxShadow = '0 0 0 2px rgba(255, 82, 82, 0.2)';
            } else {
                errorDiv.style.display = 'none';
                seatCountInput.style.backgroundColor = '';
                seatCountInput.style.borderColor = '';
                seatCountInput.style.boxShadow = '';
            }
        };

        // Validate on input
        seatCountInput.addEventListener('input', checkValue);
        
        // Also check on load (for edit mode)
        checkValue();
    }

    // Run when the DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', validateSeatCount);
    } else {
        validateSeatCount();
    }
})();
