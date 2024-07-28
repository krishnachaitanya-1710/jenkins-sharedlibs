To achieve the functionality of streaming data from your Smart Assistant to your database, we need to create an API in your backend to handle the messages and then call this API from your Angular frontend. Here's how you can do it:

### Backend Code

1. **Spring Boot Controller to handle incoming messages:**

```java
@RestController
@RequestMapping("/api/messages")
public class SmartAssistantController {

    @Autowired
    private SmartAssistantService smartAssistantService;

    @PostMapping
    public ResponseEntity<Void> saveMessage(@RequestBody Message message) {
        smartAssistantService.saveMessage(message);
        return ResponseEntity.ok().build();
    }
}
```

2. **Service to handle message saving:**

```java
@Service
public class SmartAssistantService {

    @Autowired
    private SmartAssistantRepository smartAssistantRepository;

    public void saveMessage(Message message) {
        SmartAssistantEntity entity = new SmartAssistantEntity();
        entity.setSessionId(message.getSessionId());
        entity.setEmployeeId(message.getEmployeeId());
        entity.setLanId(message.getLanId());
        entity.setMessages(message.getMessages());
        entity.setCreationDatetime(LocalDateTime.now());
        entity.setUpdateDatetime(LocalDateTime.now());
        entity.setServerIp(message.getServerIp());
        entity.setClientIp(message.getClientIp());

        smartAssistantRepository.save(entity);
    }
}
```

3. **Repository to handle database operations:**

```java
@Repository
public interface SmartAssistantRepository extends JpaRepository<SmartAssistantEntity, Long> {
}
```

4. **Entity to map the table structure:**

```java
@Entity
@Table(name = "smart_assistant_chat_history")
public class SmartAssistantEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "session_id")
    private String sessionId;

    @Column(name = "employee_id")
    private String employeeId;

    @Column(name = "lan_id")
    private String lanId;

    @Column(name = "messages")
    private String messages;

    @Column(name = "creation_datetime")
    private LocalDateTime creationDatetime;

    @Column(name = "updation_datetime")
    private LocalDateTime updateDatetime;

    @Column(name = "server_ip")
    private String serverIp;

    @Column(name = "client_ip")
    private String clientIp;

    // Getters and setters
}
```

### Frontend Code

1. **Angular Service to send messages to the backend:**

```typescript
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Message } from './message.model';

@Injectable({
  providedIn: 'root'
})
export class SmartAssistantService {

  private apiUrl = 'http://your-backend-url/api/messages';

  constructor(private http: HttpClient) { }

  saveMessage(message: Message): Observable<void> {
    return this.http.post<void>(this.apiUrl, message);
  }
}
```

2. **Interface for Message:**

```typescript
export interface Message {
  sessionId: string;
  employeeId: string;
  lanId: string;
  messages: string;
  serverIp: string;
  clientIp: string;
}
```

3. **Component to call the service and send messages:**

```typescript
import { Component } from '@angular/core';
import { SmartAssistantService } from './smart-assistant.service';
import { Message } from './message.model';

@Component({
  selector: 'app-smart-assistant',
  templateUrl: './smart-assistant.component.html',
  styleUrls: ['./smart-assistant.component.css']
})
export class SmartAssistantComponent {

  constructor(private smartAssistantService: SmartAssistantService) { }

  sendMessage() {
    const message: Message = {
      sessionId: 'your-session-id',
      employeeId: 'your-employee-id',
      lanId: 'your-lan-id',
      messages: 'your-message-content',
      serverIp: 'your-server-ip',
      clientIp: 'your-client-ip'
    };

    this.smartAssistantService.saveMessage(message).subscribe(response => {
      console.log('Message saved successfully');
    });
  }
}
```

With this setup, whenever you call the `sendMessage` method in your `SmartAssistantComponent`, it will send the message to your backend, which will then save it to the database. Make sure to adjust the URLs and paths according to your actual setup.