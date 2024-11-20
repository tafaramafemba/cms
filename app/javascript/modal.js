document.addEventListener("DOMContentLoaded", function() {
    const form = document.querySelector('.form-group');
    const confirmationModal = document.getElementById('confirmation-modal');
    const confirmSubmit = document.getElementById('confirm-submit');
    const cancelSubmit = document.getElementById('cancel-submit');
    const categorySelect = document.getElementById('category_select');
    const weightInput = document.getElementById('weight-input');
    const amountInput = document.getElementById('amount-input');
    let confirmTotalCost = document.getElementById('confirm-total-cost');
  
    let basePrice = 0;
    let additionalCost = 0;
    let minimumCost = 0;
    let feePercentage = 0;
  
    // Function to update the total cost based on current weight/amount and pricing details
    function updateTotalCost() {
      const weight = parseFloat(weightInput.value) || 0;
      const amount = parseFloat(amountInput.value) || 0;
      let totalCost = 0;
  
      const pricingType = document.querySelector('input[name="toggle"]:checked').value;
  
      if (pricingType == "amount") {
        console.log("amount was selected");
        totalCost = Math.max(amount * (feePercentage / 100)); // Cash fee calculation
        if (totalCost < minimumCost) {
            console.log("Total cost is below minimumCost. Setting totalCost to minimumCost.");
            totalCost = minimumCost;
          }
      } else {
        console.log("weight was selected");
        totalCost = (basePrice * weight) + (additionalCost * weight); // Weight-based calculation
        if (totalCost < minimumCost) {
            console.log("Total cost is below minimumCost. Setting totalCost to minimumCost.");
            totalCost = minimumCost;
          }
      }
  
      // Update the display of total cost in the confirmation modal
      confirmTotalCost.innerText = totalCost.toFixed(2);
      console.log("Confirm Total cost", confirmTotalCost);
  
      // Set total cost to hidden input for form submission
      document.getElementById("package-cost").value = totalCost.toFixed(2);
      console.log("feePercentage:", feePercentage);
    console.log("amount:", amount);
      console.log("Calculated cost", totalCost.toFixed(2));
    }
  
    // Fetch pricing details when a category is selected
    categorySelect.addEventListener("change", function() {
      const categoryId = categorySelect.value;
  
      if (categoryId) {
        fetch(`/categories/${categoryId}/pricing_details`)
          .then(response => response.json())
          .then(data => {
            basePrice = parseFloat(data.base_price) || 0;
            additionalCost = parseFloat(data.additional_cost) || 0;
            feePercentage = parseFloat(data.fee_percentage) || 0;
            minimumCost = parseFloat(data.minimum_cost) || 0;
  
            console.log("Fetched Base price:", basePrice);
            console.log("Fetched Additional cost:", additionalCost);
            console.log("Fetched Fee percentage:", feePercentage);
            console.log("Fetched Minimum cost:", minimumCost);

            updateTotalCost(); // Ensure cost is recalculated with new data
          })
          .catch(error => console.error("Error fetching pricing details:", error));
      }
    });
  
    // Show confirmation modal on form submit
    form.addEventListener("submit", function(event) {
      event.preventDefault(); // Prevent the default form submission

      updateTotalCost();

      console.log("Modal values updated:");


  
      // Populate the modal with form data
      const originCity = form.elements["package[origin_city_id]"];
      const destinationCity = form.elements["package[destination_city_id]"];
      const category = form.elements["package[category_id]"];
      const weight = weightInput.value;
      const amount = amountInput.value;
  
        document.getElementById("confirm-origin-city").innerText = originCity.options[originCity.selectedIndex].text;
        document.getElementById("confirm-destination-city").innerText = destinationCity.options[destinationCity.selectedIndex].text;
        document.getElementById("confirm-category").innerText = category.options[category.selectedIndex].text;
        document.getElementById("confirm-weight").innerText = weight;
        document.getElementById("confirm-amount").innerText = amount;


      updateTotalCost();
        console.log("Before displaying modal:");
        console.log("Total cost (hidden input):", document.getElementById("package-cost").value);
        console.log("Modal total cost text:", confirmTotalCost.innerText);

      // Show the modal
      confirmationModal.style.display = "flex";
    });
  
    // When the user confirms, submit the form
    confirmSubmit.addEventListener("click", function() {
      confirmationModal.style.display = "none";
      form.submit(); // Submit the form
    });
  
    // When the user cancels, close the modal
    cancelSubmit.addEventListener("click", function() {
      confirmationModal.style.display = "none";
    });
  
    // Update total cost whenever the weight or amount changes
    weightInput.addEventListener("input", updateTotalCost);
    amountInput.addEventListener("input", updateTotalCost);
  });