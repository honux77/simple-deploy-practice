package honux.time;

import java.time.LocalDateTime;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class Time {
    @GetMapping("/time")
    public String getTime() {
        return LocalDateTime.now().toString();
    }
}
