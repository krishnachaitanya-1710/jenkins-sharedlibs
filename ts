To add search functionality to your AG Grid table that filters the data based on the input in the search box, you can leverage the `quickFilter` feature of AG Grid.

### Step 1: Update HTML to Bind the Search Input

Make sure your `admin-management.component.html` binds the input event to a search method:

```html
<div class="panel_format table_container" style="height:calc(100vh - 170px);">
  <div class="header-container">
    <span class="heading">Smart Assistant Admin Dashboard</span>
    <div class="button-group">
      <div class="toggle-switch">
        <button class="toggle-button">Concise</button>
        <button class="toggle-button">Classic</button>
      </div>
      <button class="icon-button" title="Onboard New Service"><i class="fa fa-cogs"></i></button>
      <button class="icon-button" title="Onboard New API"><i class="fa fa-plug"></i></button>
      <button class="icon-button" title="Export API Data in JSON"><i class="fa fa-download"></i></button>
      <input class="search-input" type="search" placeholder="Search..." (input)="onQuickFilterChanged($event)">
    </div>
  </div>
  <ag-grid-angular
    id="ViewSummaryTbl"
    style="width: 100%; height: 660px;"
    class="ag-theme-balham custom-ag-theme"
    [rowData]="rowData"
    [columnDefs]="columnDefs"
    [defaultColDef]="defaultColDef"
    [sideBar]="sideBar"
    [enableRangeSelection]="true"
    [enableCharts]="true"
    [animateRows]="true"
    [pagination]="true"
    [paginationPageSize]="paginationPageSize"
    [getRowStyle]="getRowStyle"
    (gridReady)="onGridReady($event)">
  </ag-grid-angular>
</div>
```

### Step 2: Add Method to Handle Quick Filter

Update your `AdminManagementComponent` TypeScript file to include the method for handling the quick filter and store the grid API reference.

**TypeScript:**

```typescript
import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { GridOptions } from 'ag-grid-community';

@Component({
  selector: 'app-admin-management',
  templateUrl: './admin-management.component.html',
  styleUrls: ['./admin-management.component.scss']
})
export class AdminManagementComponent implements OnInit {
  columnDefs = [];
  rowData = [];
  defaultColDef = {
    flex: 1,
    minWidth: 100,
    filter: true,
    sortable: true,
    resizable: true,
    headerClass: 'bold-header' // Add a class to make headers bold
  };
  paginationPageSize = 10; // Set the page size for pagination
  sideBar = {
    toolPanels: [
      {
        id: 'columns',
        labelDefault: 'Columns',
        labelKey: 'columns',
        iconKey: 'columns',
        toolPanel: 'agColumnsToolPanel',
        minWidth: 225,
        maxWidth: 225
      },
      {
        id: 'filters',
        labelDefault: 'Filters',
        labelKey: 'filters',
        iconKey: 'filter',
        toolPanel: 'agFiltersToolPanel',
        minWidth: 225,
        maxWidth: 225
      }
    ],
    defaultToolPanel: 'columns'
  };

  private gridApi;
  private gridColumnApi;
  fieldsToSkip = ['context', 'useQueryParamsInPost'];

  constructor(private http: HttpClient) { }

  ngOnInit(): void {
    this.http.get('assets/config.json').subscribe((data: any) => {
      this.parseConfigData(data);
    });
  }

  parseConfigData(data: any) {
    if (data.services && data.services.length > 0) {
      const apis = data.services.reduce((acc, service) => acc.concat(service.apis), []);
      this.generateColumnDefs(apis);
      this.generateRowData(apis);
    }
  }

  generateColumnDefs(apis: any[]) {
    if (apis.length > 0) {
      const allKeys = new Set<string>();
      apis.forEach(api => {
        Object.keys(api).forEach(key => {
          if (!this.fieldsToSkip.includes(key)) {
            allKeys.add(key);
          }
        });
      });

      this.columnDefs = Array.from(allKeys).map(key => ({
        headerName: key.charAt(0).toUpperCase() + key.slice(1),
        field: key,
        sortable: true,
        filter: true,
        cellRenderer: (params) => {
          if (Array.isArray(params.value)) {
            return params.value.join(', ');
          }
          return params.value ? params.value : '-';
        }
      }));

      // Add the new column for actions
      this.columnDefs.push({
        headerName: 'Actions',
        field: 'actions',
        cellRenderer: this.actionCellRenderer,
        sortable: false,
        filter: false,
        width: 150
      });
    }
  }

  generateRowData(apis: any[]) {
    this.rowData = apis.map(api => {
      let row = {};
      Object.keys(api).forEach(key => {
        if (!this.fieldsToSkip.includes(key)) {
          row[key] = Array.isArray(api[key]) ? api[key].join(', ') : (api[key] || '-');
        }
      });
      return row;
    });
  }

  getRowStyle = (params) => {
    if (params.node.rowIndex % 2 === 0) {
      return { background: '#f9f9f9' };
    }
    return null;
  };

  actionCellRenderer(params) {
    const container = document.createElement('div');
    container.innerHTML = `
      <div class="dropdown">
        <button class="btn btn-secondary dropdown-toggle" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          Actions
        </button>
        <div class="dropdown-menu">
          <button class="dropdown-item" data-action="view"><i class="fa fa-eye"></i> View Record</button>
          <button class="dropdown-item" data-action="edit"><i class="fa fa-edit"></i> Edit Record</button>
          <button class="dropdown-item" data-action="clone"><i class="fa fa-clone"></i> Clone Record</button>
        </div>
      </div>
    `;

    container.querySelectorAll('.dropdown-item').forEach(button => {
      button.addEventListener('click', () => {
        const action = button.getAttribute('data-action');
        switch (action) {
          case 'view':
            console.log('View Record', params.data);
            break;
          case 'edit':
            console.log('Edit Record', params.data);
            break;
          case 'clone':
            console.log('Clone Record', params.data);
            break;
          default:
            break;
        }
      });
    });

    return container;
  }

  onGridReady(params) {
    this.gridApi = params.api;
    this.gridColumnApi = params.columnApi;
  }

  onQuickFilterChanged(event) {
    this.gridApi.setQuickFilter(event.target.value);
  }
}
```

### Explanation:

1. **HTML Update**: Added the `(input)="onQuickFilterChanged($event)"` event binding to the search input.
2. **Grid API Reference**: Captured the grid API reference in `onGridReady` method.
3. **Quick Filter Method**: Implemented the `onQuickFilterChanged` method to filter the grid data based on the search input value.

This setup will allow you to filter the table data dynamically as you type in the search box.