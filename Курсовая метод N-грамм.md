{{TOC}}

# Введение

Обработка естественного языка является одной из самых важных областей Computer Science. Быстро растет количество полезных приложений в этой области, одним из которых является поиск информации. Очевидно, что в повседневной жизни человек сталкивается с широким пластом задач, которые решаются поиском и обработкой информации. 
Одной из проблем, связанных с поиском и обработкой информации, является проблема нахождения подстроки в строке. Существует множество алгоритмов поиска подстроки в строке, каждый из которых, безусловно, обладает своими преимуществами и недостатками. Главным недостатком алгоритмов поиска подстроки в строке является то, что во всех подобных алгоритмах предполагается, что подстрока, которую необходимо найти, написана без ошибок, и на практике это выполняется не всегда. Например, вместо подстроки «метод N-грамм» в поисковом заqпросе может быть «метод Nграмм». «Наивные» алгоритмы поиска не учитывают человеческий фактор при обработке запроса , поэтому область их практического применения весьма ограничена.
Всякая поисковая система (например, Google, Yandex) решает проблему поиска по приблизительному совпадению подстроки в строке. Для решения данной проблемы применяется класс алгоритмов нечеткого поиска. Они учитывают то, что запрос может быть написан с ошибками, и таким образом существенно расширяют область результатов поиска. Применение данных алгоритмов не ограничивается только поиском по приблизительному совпадению. Алгоритмы нечеткого поиска также применяются для:
- обнаружения опечаток в полях ввода программ,
-	проверки на плагиат,
-	сравнения генов, белков, хромосом в биоинформатике,
-	для работы с базами данных в системах мониторинга лесопожарной обстановки, 
-	обработки массивов данных в интересах кредитных организаций.

Очевидно, что алгоритмы нечеткого поиска имеют широкое применение в различных предметных областях. Одним из представителей класса алгоритмов нечеткого поиска является метод N-грамм.
Целью данного курсового проекта является экспериментальное исследование метода N-грамм на основании метрик: Qgrams, Cosine Distance, Jacard Distance, Tversky Index.

Для достижения этой цели поставлены следующие задачи:
-	ознакомиться с литературой, описывающей метод N-грамм и метрики QGrams, Cosine Distance, Jacard Distance, Tversky Index;
- разработать программный продукт, реализующий метод N-грамм;
- провести сравнение метрик QGrams, Cosine Distance, Jacard Distance, Tversky Index через эксперимент с различными входными данными;
- проанализировать результат.


+++

# Метод N-грамм

## Основные определения и понятия

**Определение.** Пусть дано множество $X$. Говорят, что на нем определено расстояние (**метрика**), если каждым двум элементам $a$ и $b$ множества $X$ сопоставлено некоторое неотрицательное число $d(a, b)$, причем выполняются следующие три условия:
1. $d(a, b) = 0 \Leftrightarrow a = b$
2. $d(a, b) = d(b, a) \forall a, b \in X$
3. $d(a,c) \le d(a,b) + d(b, c) \forall a, b, c \in X$

Между тем, в большинстве случаев под метрикой подразумевается более общее понятие, не требующее выполнение данных условий. В контексте данного курсового проекта понятие *метрика* не обязательно подразумевает выполнение данных условий.

**Определение.** Алгоритмом нечеткого поиска (fuzzy string search) называется алгоритм, решающий задачу поиска по приблизительному совпадению строки. Задачу нечеткого поиска можно сформировать так:

По заданному слову найти в тексте или словаре размера $n$ слова, находящиеся по метрике $d$ на расстоянии, не превосходящем $k$ от этого слова.

**Определение.** N-граммой называется последовательность из N элементов (звуков, слогов, слов или букв). На практике чаще имеют в виду ряд слов (реже – букв).

Последовательность из двух элементов называют **биграммой**, из трех элементов – **триграммой**.

*Пример разбиения слова на биграммы, триграммы:*
ngram(“крокодил”, 2)
кр ро ок ко од ди ил
ngram(“крокодил”, 3)
кро рок око код оди дил

**Определение.** Методом N-грамм называется алгоритм нечеткого поиска, основанный на построении пространственной структуры на основе индекса, сформированного из N-грамм слов, входящих в словарь, составленный по исходному тексту или списку записей в какой-либо базе данных. На этой пространственной структуре определено расстояние d, описывающее меру сходства между двумя словами.

Для наглядного примера, определим расстояние d, которое считает количество N-грамм в двух словах, которые совпадают:

$$d(t_1, t_2) = | |ngram(t_1)| - |ngram(t_1) \cap ngram(t_2)| |,$$
где $ngram$ – функция разбиения слова на N-граммы.

```
abdcde                        -> abd bdc dcd *cde
abcde                         -> abc bcd *cde
```

$|ngram(t_1)| \rightarrow 4$
$|ngram(t_2)| \rightarrow 3$
$|ngram(t_1) \cap ngram(t_2)| \rightarrow 1$
$||ngram(t_1) - |ngram(t_1) \cap ngram(t_2)|| \rightarrow 3$


```
d(“abcde”, abdcde”) -> 3
```

Данное расстояние называется `qgrams` и часто применяется в реляционных базах данных.

Другой пример расстояния, которой мы можем описать меру сходства между двумя словами – **коэффициент Жаккара**, который также называют коэффициентом флористической общности или просто коэффициентом сходства:


$$d^{‘}(t_1, t_2)=|1 - \frac{d(t_1, t_2)}{\text{общее количество N-грамм двух слов}}|$$


## Описание алгоритма

### Входные данные:
словарь для индексации `i`, поисковый запрос `q`, метрика `d`, 

### Выходные данные:
множество слов из словаря, которые находятся на расстоянии, не превосходящем `m`.

1. Строится индекс на основе N-грамм слов, входящих в словарь i. Каждое слово, входящее в словарь, разбивается на N-граммы, и для каждой из них производится последовательный перебор списка слов, содержащих такую подстроку.
2. Запрос `q` разбивается на множество N-грамм `b`.
3. Для каждой N-граммы из множества `b` производится последовательный перебор списка слов `W`, содержащих такую подстроку, полученные слова заносятся во множество `A`.
4. Для сужения выборки для каждого слова `w` из списка `W` рассчитывается расстояние `d` между запросом `q` и словом `w` по заданной метрике.
5. Возвращается множество слов, которые находятся от запроса `q` на расстоянии, не превышающем `m`.

Ясно, что чем больше расстояние между словами, тем меньше их мера сходства. Соответственно, чем больше `m`, тем больше множество слов получаем.

## Пример работы алгоритма


	Строка: триграмма нграмма графика грамм граммовка триграфика грвмм
	триграмма => три риг игр гра рам амм мма
	нграмма   => нгр гра рам амм мма
	графика   => гра раф афи фик ика
	грамм     => гра рам амм
	граммовка => гра рам амм ммо мов овк вка
	триграфика => три риг игр гра раф афи фик ика
	
	грвмм => грв рвм вмм
	
| Nграмма | Слова |
|:--|:--|
| три | триграмма |
| риг | триграмма, триграфика |
| игр | триграмма, триграфика |
| гра | триграмма, триграфика |
| рам | триграмма, нграмма, грамм, граммовка |
| амм | триграмма, нграмма, грамм, граммовка |
| мма | триграмма, нграмма |
| нгр | нграмма |	
| раф | графика, триграфика |
| афи | графика, типографика |
| фик | графика, типографика |
| ика | графика, типографика |
| ммо | граммовка |
| мов | граммовка |
| овк | граммовка |
| вка | граммовка |
| три | триграмма |
| грв | грвмм |
| рвм | грвмм |
| вмм | грвмм |


**Запрос:** `биграмма` $=y$

биграмма => биг игр гра рам амм мма
		
биг => $\varnothing$
игр => триграмма, триграфика
гра => триграмма, триграфика
рам => триграмма, нграмма, граммовка
амм => триграмма, нграмма, грамм, граммовка
мма => триграмма, нграмма

**Выборка будет состоять из:**
триграмма $= x_1$
триграфика $= x_2$
нграмма $= x_3$
граммовка $= x_4$
грамм $= x_5$

Теперь можно применить метрику, чтобы “сузить” выборку:
$|\text{ngram}(триграмма)|\cap|ngram(биграмма)| = 5$
$|\text{ngram}(триграфика)|\cap|ngram(биграмма)| = 2$
$|\text{ngram}(нграмма)|\cap|ngram(биграмма)| = 4$
$|\text{ngram}(граммовка)|\cap|ngram(биграмма)| = 2$
$|\text{ngram}(грамм)|\cap|ngram(биграмма)| = 3$
$\text{d}(x,y)=|\text{ngram}(y)|-|\text{ngram}(x)\cap|\text{ngram}(y)|$

$d(y, x_1)=1$
$d(y, x_2)=4$
$d(y, x_3)=2$
$d(y, x_4)=4$
$d(y, x_5)=3$

$d \le 3: \text{триграмма, грамм, нграмма}$
$d \le 2: \text{нграмма, триграмма}$

## Анализ метрик

В рамках данного курсового проекта будут рассмотрены следующие четыре метрики: QGrams, Cosine Distance, Tversky Index, Jacard Distance.

### QGrams:

Метрика QGrams считает количество N-грамм, которые не совпадают. Часто применяется в реляционных базах данных. 

$d(w_1, w_2)=\frac{disagreement}{total}$

**Пример.**

```
крокодил <-> theкрокодил
кро рок око код оди дил
*the *hek *ekр кро рок око код оди дил
```

3 триграммы не совпадают

$\frac{disagreement}{total}=\frac{max(|X|, |Y|)-|X\cap Y|}{max(|X|,|Y|)+|X\cap Y|}=\frac{3}{9+6}=0.2$

### Cosine Distance

Косинусное сходство – это мера сходства между двумя векторами, которая используется для измерения косинуса угла между ними.

Если даны два вектора признаков, A и B, то косинусное сходство может быть представлено используя скалярное произведение и модули векторов

Применяется в кластеризации документов, когда присутствие параграфов в тексте может быть расценено как координата вектора, затем на основе косинусного сходства создаются группы документов.

**Пример...**

### Tversky Index



### Jacard Distance




https://upload.wikimedia.org/wikipedia/commons/2/2d/Intersection_over_Union_-_object_detection_bounding_boxes.jpg

https://www.researchgate.net/publication/320914786/figure/fig2/AS:558221849841664@1510101868614/The-difference-between-Euclidean-distance-and-cosine-similarity.png

Cколько элементов множества принимают участие в этой операции

# Разработка КП

Данная программа предназначена для генерации текста и проведения эксперимента по поиску по заданному тексту с применением метрик.

## Архитектура КП

Для проведения экспериментального исследования необходимо разработать КП, состоящую из модулей:
1. Основной модуль
	1. Модуль генерации текста
	2. Модуль экспериментального исследования

**Основной модуль** предоставляет возможность перейти к генерации текста, либо к окну выбора файлов с текстами для анализа.

**Модуль генерации текста** позволяет создать файл с текстом, по которому в дальнейшнем будет выполняться поиск.

**Модуль экспериментального исследования** позволяет выбрать файл с текстом для проведения эксперимента, а также ввести поисковый запрос и выбрать метрики для анализа. Выполняет нечеткий поиск по заданному запросу в тексте из файла, подсчитывая данные для анализа, проводя сужение выборки по заданным метрикам. Выводит результаты поиска по заданным метрикам, а также графики по собранным в ходе анализа данным

- Количество операций
- Количество результатов для каждой из метрик
- Время выполнения сужения выборки для каждой метрики


## Требования к КП



## Требования к данным модуле в генерации текста

## *Входные данные:* 

1. Слово
2. Число грамм
3. Минимальное количество ошибок
4. Максимальное количество ошибок
5. Число слов в тексте


## *Выходные данные:* 
\\[\\]

Файл, содержащий текст с заданным числом слов. Файл имеет свое уникальное имя вида: `<имя>.<расширение>`.
`<имя> :== <words>.<min>.<max>`
`<расширение> :== txt`
`<words>` $\in \mathbb{N}$
`<min>` $\in \mathbb{N}$
`<max>` $\in \mathbb{N}$

## Функциональные требования для модуля генерации текста
1. КП должна позволять вводить: число слов в тексте, минимальную длину слова, максимальную длину.
2. КП должна уметь генерировать текст нескольких выбранных видов за один запрос.
3. КП должна сообщать пользователю об ошибке, если вводные данные не удовлетворяют предусловию.
4. КП должна сохранять сгенерированные тексты в файлы с автоматически генерируемым именем.
5. КП должна проверять наличие файлов с одинаковыми названиями и, если они существуют, перезаписывать оригинал.

## Требования к данным в модуле экспериментального исследования

## *Входные данные:*
Список файлов, каждый из которых:
1. Является текстовым файлом, количество слов в файле не может быть меньше $1$ и превышать $10^7$.
2. Имеет свое уникальное имя вида аналогичного виду имени файла, создаваемого модулем генерации текста.

## *Выходные данные:*
1. Гистограммы
	2. Зависимость времени выполнения сужения выборки от выбранной метрики
	3. Зависимость количества операций при выполнении сужения выборки от выбранной метрики (**количество элементов, которые принимали участие в пересечении/объединении)**
	4. Зависимость числа слов в результатах поиска от выбранной метрики
5. Результаты поиска с возможностью фильтрации их по выбранной метрике

## Функциональные требования для модуля экспериментального исследования 

1. КП должна позволять выбирать файл с текстом для эксперимента.
2. КП должна уметь выполнять алгоритм нечеткого поиска.
3. КП должна уметь засекать время сужения выборки при выполнения каждой метрики.
4. КП должна производить подсчет числа операций, выполненных во время алгоритмов сужения выборки (метрик)
5. КП должна уметь производить подсчет числа слов в результатах поиска при применении заданной метрики.

**Требования к удобству КП:**
1. КП должна быть предназначена для любого человека, который имеет навык работы на компьютере.
2. КП должна выдававть все сообщенния на русском языке, за исключением некоторых имен файлов и папок.
3. Интерфейс КП должен быть понятен и дружелюбен.
4. Процедура запуска КП должна быть понятна и проста для пользователя.

**Требования к мобильности КП**
КП должна быть переносимой без изменений из одной среды в другую в рамках macOS Catalina.


# Список литературы

1. Васильев Н., Метрические Пространства, Журнал "Квант", 1990 г., №1
2. https://habr.com/en/post/114997/
3. https://chappers.github.io/web%20micro%20log/2015/04/29/comparison-of-ngram-fuzzy-matching-approaches/


