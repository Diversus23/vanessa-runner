///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Выполнение команды выгрузки файла поставки конфигурации
//
// Служебный модуль с набором методов работы с командами приложения
//
// Структура модуля реализована в соответствии с рекомендациями
// oscript-app-template (C) EvilBeaver
//
///////////////////////////////////////////////////////////////////////////////////////////////////

#Использовать logos
#Использовать v8runner

Перем Лог;
Перем МенеджерКонфигуратора;
Перем МенеджерВерсий;

// Параметры команды
Перем ИмяФайлаПоставки;
Перем КаталогИсходников;
Перем НомерСборки;
Перем ЗагружатьВТекущую;

///////////////////////////////////////////////////////////////////////////////////////////////////
// Прикладной интерфейс

Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт

	ТекстОписания =
		"     Выгрузка файла поставки конфигурации из ИБ.";

	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды,
		ТекстОписания);

	Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, "cfpath",
		"Путь к результату - выгружаемому файлу поставки конфигурации (*.cf)
		|В пути файла можно указать шаблонную переменную $version для подстановки в нее версии конфигурации
		|Пример: 1Cv8_$version.cf выгрузит файл вида 1Cv8_1.2.3.4.cf");

	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--src", "Каталог с исходниками конфигурации");
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--build-number", "Номер сборки");
	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "--current", "Флаг загрузки в указанную базу или -с");
	Парсер.ДобавитьПараметрФлагКоманды(ОписаниеКоманды, "-c", "Флаг загрузки в указанную базу, краткая форма от --current");

	Парсер.ДобавитьКоманду(ОписаниеКоманды);

КонецПроцедуры // ЗарегистрироватьКоманду

// Выполняет логику команды
//
// Параметры:
//   ПараметрыКоманды - Соответствие - Соответствие ключей командной строки и их значений
//   ДополнительныеПараметры - Соответствие - дополнительные параметры (необязательно)
//
Функция ВыполнитьКоманду(Знач ПараметрыКоманды, Знач ДополнительныеПараметры = Неопределено) Экспорт

	Лог = ДополнительныеПараметры.Лог;

	ДанныеПодключения = ПараметрыКоманды["ДанныеПодключения"];

	ИмяФайлаПоставки = ОбщиеМетоды.ПолныйПуть(ПараметрыКоманды["cfpath"]);
	КаталогИсходников = ОбщиеМетоды.ПолныйПуть(ПараметрыКоманды["--src"]);
	НомерСборки = ПараметрыКоманды["--build-number"];
	ЗагружатьВТекущую = ОбщиеМетоды.ЕстьФлагКоманды(ПараметрыКоманды, "-c", "--current");

	МенеджерКонфигуратора = Новый МенеджерКонфигуратора;
	МенеджерВерсий = Новый МенеджерВерсийФайлов1С;
	
	Если ЗагружатьВТекущую Или ЗначениеЗаполнено(ИмяФайлаПоставки) Тогда
		МенеджерКонфигуратора.Конструктор(ДанныеПодключения, ПараметрыКоманды);
	Иначе
		МенеджерКонфигуратора.КонструкторДляНеобязательнойСтрокиСоединения(ДанныеПодключения, ПараметрыКоманды);
	КонецЕсли;

	Попытка
		СоздатьФайлПоставки();
	Исключение
		МенеджерКонфигуратора.Деструктор();
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;

	МенеджерКонфигуратора.Деструктор();

	Возврат МенеджерКомандПриложения.РезультатыКоманд().Успех;

КонецФункции // ВыполнитьКоманду

Процедура СоздатьФайлПоставки()

	Если ЗначениеЗаполнено(КаталогИсходников) Тогда
		СобратьИзИсходниковТекущуюКонфигурацию();
	КонецЕсли;

	ИмяФайлаПоставкиСВерсией = МенеджерВерсий.ПодставитьНомерВерсии(КаталогИсходников, ИмяФайлаПоставки);
	МенеджерКонфигуратора.СоздатьФайлПоставки(ИмяФайлаПоставкиСВерсией);

КонецПроцедуры

Процедура СобратьИзИсходниковТекущуюКонфигурацию()

	Если ЗначениеЗаполнено(НомерСборки) Тогда
		ИзменитьНомерСборкиВИсходникахКонфигурации();
	КонецЕсли;

	МенеджерКонфигуратора.СобратьИзИсходниковТекущуюКонфигурацию(КаталогИсходников, "", Ложь, Ложь);
	МенеджерКонфигуратора.ОбновитьКонфигурациюБазыДанных(Ложь);

КонецПроцедуры

Процедура ИзменитьНомерСборкиВИсходникахКонфигурации()

	Лог.Информация("Изменяю номер сборки в исходниках конфигурации 1С на %1", НомерСборки);
	
	СтарыеВерсии = МенеджерВерсий.УстановитьНомерСборкиДляКонфигурации(КаталогИсходников, НомерСборки);

	Для каждого КлючЗначение Из СтарыеВерсии Цикл
		Лог.Информация("    Старая версия %1, файл - %2", КлючЗначение.Значение, КлючЗначение.Ключ);
	КонецЦикла;

КонецПроцедуры
