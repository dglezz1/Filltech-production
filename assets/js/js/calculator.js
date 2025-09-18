document.addEventListener('DOMContentLoaded', () => {
  const servicesContainer = document.getElementById('services-container');
  const calculateButton = document.getElementById('calculate-button');
  const resetButton = document.getElementById('reset-button');
  const totalPriceElement = document.getElementById('total-price');
  const numPagesInput = document.getElementById('num-pages');
  const numImagesInput = document.getElementById('num-images');
  const numMonthsSupportInput = document.getElementById('num-months-support');
  const numMonthsHostingInput = document.getElementById('num-months-hosting');
  const numProductsInput = document.getElementById('num-products');
  let totalPrice = 0;

  fetch('/api/services')
    .then(response => response.json())
    .then(services => {
      const table = document.createElement('table');
      table.classList.add('table', 'table-striped');

      const thead = document.createElement('thead');
      const headerRow = document.createElement('tr');
      const headers = ['Seleccionar', 'Servicio', 'Costo'];
      headers.forEach(headerText => {
        const th = document.createElement('th');
        th.textContent = headerText;
        headerRow.appendChild(th);
      });
      thead.appendChild(headerRow);
      table.appendChild(thead);

      const tbody = document.createElement('tbody');
      services.forEach(service => {
        const row = document.createElement('tr');

        const checkboxCell = document.createElement('td');
        const checkbox = document.createElement('input');
        checkbox.type = 'checkbox';
        checkbox.value = service.price;
        checkbox.id = service.name;
        checkbox.classList.add('service-checkbox');
        checkboxCell.appendChild(checkbox);
        row.appendChild(checkboxCell);

        const nameCell = document.createElement('td');
        nameCell.textContent = service.name;
        row.appendChild(nameCell);

        const priceCell = document.createElement('td');
        priceCell.textContent = `$${service.price}`;
        row.appendChild(priceCell);

        tbody.appendChild(row);
      });

      table.appendChild(tbody);
      servicesContainer.appendChild(table);
    })
    .catch(error => console.error('Error fetching services:', error));

  calculateButton.addEventListener('click', () => {
    totalPrice = 0;
    const checkboxes = document.querySelectorAll('.service-checkbox:checked');
    checkboxes.forEach(checkbox => {
      totalPrice += parseFloat(checkbox.value);
    });

    const numPages = parseInt(numPagesInput.value) || 0;
    const numImages = parseInt(numImagesInput.value) || 0;
    const numMonthsSupport = parseInt(numMonthsSupportInput.value) || 0;
    const numMonthsHosting = parseInt(numMonthsHostingInput.value) || 0;
    const numProducts = parseInt(numProductsInput.value) || 0;

    totalPrice += numPages * 300;
    totalPrice += numImages * 25;
    totalPrice += numMonthsSupport * 200;
    totalPrice += numMonthsHosting * 250;
    totalPrice += numProducts * 80;

    totalPriceElement.textContent = `El precio aproximado de tu Web es de: $${totalPrice}`;
  });

  resetButton.addEventListener('click', () => {
    totalPrice = 0;
    totalPriceElement.textContent = `Total: $${totalPrice}`;
    const checkboxes = document.querySelectorAll('.service-checkbox');
    checkboxes.forEach(checkbox => {
      checkbox.checked = false;
    });
    numPagesInput.value = 1;
    numImagesInput.value = 0;
    numMonthsSupportInput.value = 0;
    numMonthsHostingInput.value = 0;
    numProductsInput.value = 0;
  });
});