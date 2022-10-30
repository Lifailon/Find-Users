# Find-Users - сканер для поиска пользователей Windows
Можно узнать по фамилии в AD имя пользователя, но как индентификировать компьютер, на котором он работает.

Скрипт определяет текущий ip-адрес, пингует все хосты в текущей подсети, ответивших хостов резолвит имена, что бы отсеять не зарегистрированные машины в dns (значительно сокращает время сканирования) и проверяет на них пользователей по средствам query, а так же фиксирует время сканирования. У меня в среднем занимает 5 минут на 100 активных хостов. Вывод команды можно скопировать в txt-файл (Ctrl+A и Ctrl+C) и найти пользователя по логину (Ctrl+F).

Пример вывода:

![Image alt](https://github.com/Lifailon/Find-Users/blob/rsa/interface-out.jpg)
