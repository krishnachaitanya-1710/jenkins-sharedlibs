.panel_format.table_container {
  display: flex;
  flex-direction: column;
}

.header-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 20px;
  background-color: #f8f9fa;
  border-bottom: 1px solid #dee2e6;
}

.heading {
  font-size: 1.5rem;
  font-weight: bold;
}

.button-group {
  display: flex;
  align-items: center;
}

.toggle-switch {
  display: flex;
  align-items: center;
  margin-right: 15px;
}

.toggle-button {
  background: #007bff;
  border: none;
  color: white;
  padding: 5px 10px;
  margin: 0 5px;
  border-radius: 4px;
  cursor: pointer;
}

.toggle-button:hover {
  background: #0056b3;
}

.icon-button {
  background: dimgrey;
  border: none;
  color: white;
  padding: 10px;
  margin-right: 5px;
  border-radius: 4px;
  cursor: pointer;
  transition: transform 0.2s, background-color 0.2s;
  position: relative;
}

.icon-button i {
  font-size: 1.2rem;
}

.icon-button:hover {
  background: #505050;
  transform: scale(1.1);
}

.icon-button:hover::after {
  content: attr(title);
  position: absolute;
  top: -30px;
  left: 50%;
  transform: translateX(-50%);
  background: black;
  color: white;
  padding: 5px 10px;
  border-radius: 4px;
  white-space: nowrap;
  font-size: 0.8rem;
}

.search-input {
  padding: 5px 10px;
  border: 1px solid #ced4da;
  border-radius: 4px;
  font-size: 1rem;
}

.custom-ag-theme .ag-header-cell-label {
  font-weight: bold;
  font-size: 16px; /* Adjust the size as needed */
  padding: 10px 15px; /* Adjust padding for more spacing */
}

.bold-header {
  font-weight: bold;
  font-size: 16px; /* Adjust the size as needed */
  padding: 10px 15px; /* Adjust padding for more spacing */
}

.custom-ag-theme .ag-cell {
  font-size: 14px; /* Adjust the font size as needed */
  padding: 8px 15px; /* Adjust padding for more spacing */
}

.custom-ag-theme .ag-row:nth-child(even) {
  background-color: #f9f9f9;
}

.custom-ag-theme .ag-row:nth-child(odd) {
  background-color: #ffffff;
}

.custom-ag-theme .ag-paging-panel {
  font-size: 14px; /* Adjust the font size for pagination controls */
  padding: 10px 15px; /* Adjust padding for pagination controls */
}

.dropdown {
  display: inline-block;
}

.dropdown-menu {
  font-size: 14px;
  min-width: 120px;
}

.dropdown-item {
  cursor: pointer;
  padding: 5px 10px;
}

.dropdown-item:hover {
  background-color: #f1f1f1;
}