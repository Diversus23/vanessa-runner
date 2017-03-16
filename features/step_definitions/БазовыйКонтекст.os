﻿// Реализация шагов BDD-фич/сценариев c помощью фреймворка https://github.com/artbear/1bdd

Перем БДД; //контекст фреймворка 1bdd

// Метод выдает список шагов, реализованных в данном файле-шагов
Функция ПолучитьСписокШагов(КонтекстФреймворкаBDD) Экспорт
	БДД = КонтекстФреймворкаBDD;

	ВсеШаги = Новый Массив;

	ВсеШаги.Добавить("ЯПодготовилРепозиторийИРабочийКаталогПроекта");

	Возврат ВсеШаги;
КонецФункции

// Реализация шагов

// Процедура выполняется перед запуском каждого сценария
Процедура ПередЗапускомСценария(Знач Узел) Экспорт
	
КонецПроцедуры

// Процедура выполняется после завершения каждого сценария
Процедура ПослеЗапускаСценария(Знач Узел) Экспорт
	
КонецПроцедуры

//я подготовил репозиторий и рабочий каталог проекта
Процедура ЯПодготовилРепозиторийИРабочийКаталогПроекта() Экспорт
	// TODO удалить после реализации БДД.ВыполнитьСценарий 
    БДД.ВыполнитьШаг("Допустим я выключаю отладку лога с именем ""oscript.app.vanessa-runner""");
    БДД.ВыполнитьШаг("И Я очищаю параметры команды ""oscript"" в контексте");

    БДД.ВыполнитьШаг("Допустим Я создаю временный каталог и сохраняю его в контекст");
    БДД.ВыполнитьШаг("И Я устанавливаю временный каталог как рабочий каталог");
    БДД.ВыполнитьШаг("Допустим Я создаю каталог ""build/out"" в рабочем каталоге");

    БДД.ВыполнитьШаг("И Я установил рабочий каталог как текущий каталог");

    БДД.ВыполнитьШаг("Допустим Я сохраняю каталог проекта в контекст");
КонецПроцедуры

//{ Служебные функции
//}

