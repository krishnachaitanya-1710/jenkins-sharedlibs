I understand you want to integrate the context menu directly within the same component. Here's how you can achieve it without creating a separate component:

### Step 1: HTML
Ensure your action button is correctly placed within the grid to trigger the menu.

```html
<!-- Assuming this is part of your AG-Grid column definition -->
<ag-grid-angular
  #agGrid
  class="ag-theme-balham"
  [rowData]="rowData"
  [columnDefs]="columnDefs"
  [frameworkComponents]="frameworkComponents"
  (gridReady)="onGridReady($event)"
  [context]="{ componentParent: this }"
></ag-grid-angular>

<!-- Add the context menu inside your main component -->
<div *ngIf="contextMenuVisible" [style.top.px]="contextMenuPosition.top" [style.left.px]="contextMenuPosition.left" class="context-menu">
  <button (click)="viewApi(selectedRow)">View Record</button>
  <button (click)="editApi(selectedRow)">Edit Record</button>
  <button (click)="cloneApi(selectedRow)">Clone Record</button>
</div>
```

### Step 2: TypeScript
Modify your component to handle the context menu items and their actions properly.

```typescript
import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-admin-management',
  templateUrl: './admin-management.component.html',
  styleUrls: ['./admin-management.component.scss']
})
export class AdminManagementComponent implements OnInit {
  public rowData: any[] = [];
  public columnDefs: any[] = [];
  public frameworkComponents: any;

  public contextMenuVisible = false;
  public contextMenuPosition = { top: 0, left: 0 };
  public selectedRow: any = null;

  constructor(private http: HttpClient) {}

  ngOnInit(): void {
    this.loadConfigurations();
  }

  loadConfigurations(): void {
    this.http.get('/api/configurations').subscribe(
      (data: any) => {
        this.configData = data;
        this.apps = Object.keys(data);
        this.setServicesAndApis(data);
        this.generateColumnDefs(data);
        this.generateRowData(data);
      },
      error => {
        console.error('Error loading configurations', error);
      }
    );
  }

  setServicesAndApis(data: any): void {
    this.services = {};
    this.apis = {};
    this.apps.forEach(app => {
      data[app].services.forEach(service => {
        this.services[app] = this.services[app] || [];
        this.services[app].push(service.name);
        this.apis[app] = this.apis[app] || {};
        this.apis[app][service.name] = service.apis;
      });
    });
  }

  generateColumnDefs(data: any): void {
    const allKeys = new Set<string>();
    this.apps.forEach(app => {
      data[app].services.forEach(service => {
        service.apis.forEach(api => {
          Object.keys(api).forEach(key => {
            if (!this.fieldsToSkip.includes(key)) {
              allKeys.add(key);
            }
          });
        });
      });
    });
    allKeys.add('serviceName');
    allKeys.add('appName');

    this.columnDefs = Array.from(allKeys).map(key => ({
      headerName: key.charAt(0).toUpperCase() + key.slice(1),
      field: key,
      sortable: true,
      filter: true,
      cellStyle: { 'white-space': 'normal', 'text-align': 'left' },
      autoHeight: true,
      cellRenderer: (params: any) => {
        return Array.isArray(params.value) ? params.value.join(', ') : params.value || '--';
      }
    }));

    this.columnDefs.push({
      headerName: 'Actions',
      field: 'actions',
      cellRenderer: (params) => this.actionsCellRenderer(params),
      sortable: false,
      filter: false
    });
  }

  generateRowData(data: any): void {
    this.rowData = [];
    this.apps.forEach(app => {
      data[app].services.forEach(service => {
        service.apis.forEach(api => {
          const row = { appName: app, serviceName: service.name };
          Object.keys(api).forEach(key => {
            if (!this.fieldsToSkip.includes(key)) {
              row[key] = Array.isArray(api[key]) ? api[key].join(', ') : api[key] || '--';
            }
          });
          this.rowData.push(row);
        });
      });
    });
  }

  actionsCellRenderer(params: any): string {
    return `<button (click)="showContextMenu($event, ${params.rowIndex})">...</button>`;
  }

  showContextMenu(event: MouseEvent, rowIndex: number): void {
    event.preventDefault();
    this.selectedRow = this.rowData[rowIndex];
    this.contextMenuPosition = { top: event.clientY, left: event.clientX };
    this.contextMenuVisible = true;
  }

  viewApi(params: any): void {
    console.log('Viewing API', params);
    // Implement your view logic here
    this.contextMenuVisible = false;
  }

  editApi(params: any): void {
    console.log('Editing API', params);
    // Implement your edit logic here
    this.contextMenuVisible = false;
  }

  cloneApi(params: any): void {
    console.log('Cloning API', params);
    // Implement your clone logic here
    this.contextMenuVisible = false;
  }
}
```

### Explanation:
1. **HTML:**
   - The context menu is added directly inside your main component HTML.
   - The `actionsCellRenderer` function is now defined inline within the `generateColumnDefs` function.

2. **TypeScript:**
   - `showContextMenu`: This method shows the context menu at the mouse click position.
   - `viewApi`, `editApi`, `cloneApi`: Methods to handle the respective actions, closing the context menu after performing the action.
   - `actionsCellRenderer`: Generates the button to show the context menu.

This setup ensures the context menu is shown correctly within the grid and handles the actions as required. The context menu visibility and position are controlled within the same component.