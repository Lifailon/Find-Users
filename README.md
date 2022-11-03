# Find-Users - сканер для поиска пользователей Windows
Можно узнать по фамилии в AD имя пользователя, но как идентифицировать компьютер, на котором он работает.

Скрипт определяет текущий ip-адрес компьютера (в случае, если несколько адресов, скрипт заберет первый в списке), пингует все хосты в текущей подсети, ответивших хостов резолвит имена (что бы отсеять не зарегистрированные машины в dns, значительно сокращает время сканирования), количество хостов отображается в выводе, на последнем этапе проверяет список пользователей по средствам query и читабельном парсингом вывода, а так же фиксирует время сканирования. У меня в среднем занимает от 5 до 6 минут на 120 активных хостов. Вывод можно сохранить в файл и найти пользователя комбинацией клавиш Ctrl+F.

> В начале скрипта указано, как изменить адрес подсети

Пример вывода:

![Image alt](https://github.com/Lifailon/Find-Users/blob/rsa/Interface.jpg)
