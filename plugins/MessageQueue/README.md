# Message Queue

> Send messages using files  
> Version 0.1.0  
> Chadnaut 2024  
> https://github.com/Chadnaut/Attract-Mode-Modules

## Quickstart

- Configure > Plug-ins > MessageQueue
- Enabled > Yes

```cpp
::fe.add_message_callback("on_message");

function on_message(message) {
    print(message + "\n");
}
```

- With the default settings `MessageQueue` will scan for `.txt` files in `./plugins/MessageQueue/queue/`.
- Upon finding a file it will send its contents to all registered functions, then ***delete*** the file.

## Functions

- `::fe.add_message_callback(environment, function_name)`
- `::fe.add_message_callback(function_name)`

Register a function in your script to handle incoming messages. If there are no registered callbacks the messages will not be processed or deleted.

## Queue Order

If multiple message files are found they will be processed in order:
- 1.txt <-- numbers before letters
- 100.txt <-- not numerically sorted
- 2.txt
- a.txt
- AA.txt <-- capitalization ignored
- aaa.txt

If you require a specific order ensure your message files are named appropriately.

- message-1714705100.txt
- message-1714705101.txt
- message-1714705102.txt
