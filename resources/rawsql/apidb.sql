-- phpMyAdmin SQL Dump
-- version 4.7.0
-- https://www.phpmyadmin.net/
--
-- Gép: 127.0.0.1
-- Létrehozás ideje: 2018. Jún 04. 08:39
-- Kiszolgáló verziója: 10.1.24-MariaDB
-- PHP verzió: 7.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Adatbázis: `apidb`
--

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `badges`
--

CREATE TABLE `badges` (
  `id` int(10) UNSIGNED NOT NULL,
  `description` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `xp` smallint(5) UNSIGNED NOT NULL DEFAULT '100',
  `filename` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'nopic.png'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- A tábla adatainak kiíratása `badges`
--

INSERT INTO `badges` (`id`, `description`, `name`, `xp`, `filename`) VALUES
(1, 'Badge 1...', 'Badge 1', 1000, 'nopic.png'),
(2, 'Badge 2...', 'Badge 2', 2400, 'img_1528093081.png'),
(3, 'Badge 3...', 'Badge 3', 500, 'nopic.png');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- A tábla adatainak kiíratása `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_resets_table', 1),
(3, '2016_06_01_000001_create_oauth_auth_codes_table', 1),
(4, '2016_06_01_000002_create_oauth_access_tokens_table', 1),
(5, '2016_06_01_000003_create_oauth_refresh_tokens_table', 1),
(6, '2016_06_01_000004_create_oauth_clients_table', 1),
(7, '2016_06_01_000005_create_oauth_personal_access_clients_table', 1);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `oauth_access_tokens`
--

CREATE TABLE `oauth_access_tokens` (
  `id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `client_id` int(11) NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `scopes` text COLLATE utf8mb4_unicode_ci,
  `revoked` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `oauth_auth_codes`
--

CREATE TABLE `oauth_auth_codes` (
  `id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `scopes` text COLLATE utf8mb4_unicode_ci,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `oauth_clients`
--

CREATE TABLE `oauth_clients` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `secret` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `redirect` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `personal_access_client` tinyint(1) NOT NULL,
  `password_client` tinyint(1) NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- A tábla adatainak kiíratása `oauth_clients`
--

INSERT INTO `oauth_clients` (`id`, `user_id`, `name`, `secret`, `redirect`, `personal_access_client`, `password_client`, `revoked`, `created_at`, `updated_at`) VALUES
(1, NULL, 'Laravel Personal Access Client', 'kVxwLqq2It9ruhH9bgLDyPswfwxaZsLmAefLpszM', 'http://localhost', 1, 0, 0, '2018-05-20 16:20:26', '2018-05-20 16:20:26'),
(2, NULL, 'Laravel Password Grant Client', 'BO3ft4ivuVoABOfHWiLcRw7hdtBiK5z32GsIJwvo', 'http://localhost', 0, 1, 0, '2018-05-20 16:20:27', '2018-05-20 16:20:27');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `oauth_personal_access_clients`
--

CREATE TABLE `oauth_personal_access_clients` (
  `id` int(10) UNSIGNED NOT NULL,
  `client_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- A tábla adatainak kiíratása `oauth_personal_access_clients`
--

INSERT INTO `oauth_personal_access_clients` (`id`, `client_id`, `created_at`, `updated_at`) VALUES
(1, 1, '2018-05-20 16:20:26', '2018-05-20 16:20:26');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `oauth_refresh_tokens`
--

CREATE TABLE `oauth_refresh_tokens` (
  `id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `access_token_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `products`
--

CREATE TABLE `products` (
  `id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` int(11) NOT NULL,
  `availability` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- A tábla adatainak kiíratása `products`
--

INSERT INTO `products` (`id`, `created_at`, `updated_at`, `title`, `description`, `price`, `availability`) VALUES
(1, '2018-05-18 13:53:18', '2018-05-18 13:53:18', 'Mr.', 'Voluptatem nulla tenetur est enim incidunt officia sint. Facilis voluptas earum odit aliquam fuga maxime dolorum. Est ipsam sit vitae. Sit minima nemo voluptatem numquam sint vel.', 59, 1),
(2, '2018-05-18 13:53:19', '2018-05-18 13:53:19', 'Dr.', 'Nobis et et dolorum nobis odio quisquam. Eligendi corrupti quos sequi ducimus ut molestiae in. Facilis reiciendis alias quisquam aut. Inventore accusantium qui non.', 65, 1),
(3, '2018-05-18 13:53:19', '2018-05-18 13:53:19', 'Dr.', 'Incidunt ab repellat alias. Quis quisquam quia dolorum exercitationem fugit repudiandae impedit. Illum sunt praesentium est eos quia eius.', 4, 1),
(4, '2018-05-18 13:53:19', '2018-05-18 13:53:19', 'Miss', 'Ut ea atque odit quasi. Numquam quia dolor vitae omnis laudantium qui. Cum officia dolorum optio.', 87, 1),
(5, '2018-05-18 13:53:19', '2018-05-18 13:53:19', 'Miss', 'Perspiciatis quod tempore at non impedit dolore. Ut excepturi molestias ut maxime quisquam laudantium qui. Deserunt reprehenderit qui eaque qui eveniet occaecati.', 99, 1),
(6, '2018-05-18 13:53:19', '2018-05-18 13:53:19', 'Mr.', 'Fugit eos quasi quas ex. Dolorum facere omnis ut nemo omnis dolorum. Alias aliquid accusamus quod qui et. Ducimus voluptas quo laborum illum excepturi voluptas.', 67, 0),
(7, '2018-05-18 13:53:19', '2018-05-18 13:53:19', 'Dr.', 'Et est ipsum labore. Repudiandae modi ipsum eum. Aut nobis unde inventore eveniet eveniet minima rerum temporibus.', 0, 0),
(8, '2018-05-18 13:53:19', '2018-05-18 13:53:19', 'Ms.', 'Nemo voluptas saepe cupiditate perspiciatis omnis deleniti. Qui voluptatum quia et dolor. Voluptatem corrupti omnis possimus omnis sunt. At non similique consectetur incidunt maxime hic.', 51, 0),
(9, '2018-05-18 13:53:19', '2018-05-18 13:53:19', 'Dr.', 'Qui aspernatur enim corporis maxime reiciendis qui. Autem cupiditate tempora atque animi. Earum et dicta recusandae dolor. Voluptatum eaque enim sunt modi eligendi eligendi est ipsa.', 84, 1),
(10, '2018-05-18 13:53:19', '2018-05-18 13:53:19', 'Prof.', 'Labore nam dolor in in nihil inventore asperiores. Qui dolorem sit ea ut cupiditate. Pariatur iusto iste voluptas rem.', 12, 1),
(11, '2018-05-18 13:53:19', '2018-05-18 13:53:19', 'Dr.', 'Molestiae voluptatem nihil quam quis et facere quasi. Dolores quia id autem expedita distinctio consequuntur libero optio. Ut sed id velit.', 3, 1),
(12, '2018-05-18 13:53:19', '2018-05-18 13:53:19', 'Prof.', 'Ad nemo quasi eligendi et ipsam adipisci labore. Et et incidunt ipsam quo. Assumenda nam impedit magni autem earum.', 60, 1),
(13, '2018-05-18 13:53:19', '2018-05-18 13:53:19', 'Mr.', 'Et hic fuga vitae aspernatur veritatis. Eos ipsam iste eos a saepe eos et quia. Officia aut aspernatur veritatis velit aut. Voluptate id natus beatae est a sed consequuntur. Ipsam expedita non sed sed et id at.', 2, 0),
(14, '2018-05-18 13:53:19', '2018-05-18 13:53:19', 'Mr.', 'Quos commodi molestiae voluptas labore ipsum alias. Accusantium nihil numquam magnam autem aperiam quo. Numquam quos pariatur veniam quia blanditiis quis.', 95, 1),
(15, '2018-05-18 13:53:19', '2018-05-18 13:53:19', 'Dr.', 'Sit omnis tempora tenetur aut pariatur. Officia enim quisquam quia impedit necessitatibus. Omnis sunt eligendi et quia corporis aut ullam. Quaerat sunt est ut repellat necessitatibus qui quae.', 37, 1),
(16, '2018-05-18 13:53:19', '2018-05-18 13:53:19', 'Mrs.', 'Beatae voluptas quas voluptas debitis ad labore. Quod minima et rem incidunt. Culpa voluptatem sapiente repellendus voluptas qui eos minima.', 59, 1),
(17, '2018-05-18 13:53:19', '2018-05-18 13:53:19', 'Mrs.', 'Ipsum laudantium sunt sit labore est sit ut id. Sit fugit possimus consequatur provident necessitatibus corrupti. Aspernatur odio totam et quos necessitatibus dicta. Nostrum ut odio minus ut ab.', 29, 1),
(18, '2018-05-18 13:53:19', '2018-05-18 13:53:19', 'Prof.', 'Harum a ratione repellendus provident culpa unde facilis eius. Impedit quis soluta eum quo sit rerum labore. Labore doloribus distinctio dolorum quibusdam. Sit possimus quia atque qui ullam recusandae doloribus.', 21, 0),
(19, '2018-05-18 13:53:19', '2018-05-18 13:53:19', 'Mr.', 'Officiis sit natus nemo ut. Mollitia voluptatum deserunt aut eum illo dolorem. Sit molestiae rerum est illum. Corporis maxime accusamus consequatur labore fuga.', 73, 0),
(20, '2018-05-18 13:53:20', '2018-05-18 13:53:20', 'Ms.', 'Cupiditate sed voluptas quasi maxime delectus autem sit. Vel dicta blanditiis itaque aut iusto doloremque.', 18, 0),
(21, '2018-05-18 13:53:20', '2018-05-18 13:53:20', 'Mr.', 'Placeat aut omnis occaecati est consectetur nulla. Facilis natus incidunt eius et ut perferendis maxime saepe. Facere consequuntur excepturi quo autem consequatur cupiditate in. Similique sit qui deserunt dolore sit. Sed occaecati nam incidunt maxime neque perspiciatis beatae.', 43, 0),
(22, '2018-05-18 13:53:20', '2018-05-18 13:53:20', 'Ms.', 'Corporis est et qui illum et ea. Consequatur mollitia id tenetur aut eum et. Labore temporibus ut fugit commodi aut.', 36, 1),
(23, '2018-05-18 13:53:20', '2018-05-18 13:53:20', 'Mr.', 'Porro reiciendis aut et aut. Nemo repellat ullam ut et quia est. Officia voluptatibus ipsa veniam quis.', 9, 1),
(24, '2018-05-18 13:53:20', '2018-05-18 13:53:20', 'Mr.', 'Aperiam officia vitae pariatur. Quidem porro quia repellat non. Est dicta nam est nesciunt.', 73, 0),
(25, '2018-05-18 13:53:20', '2018-05-18 13:53:20', 'Dr.', 'Et et officiis eveniet ea. Cumque excepturi similique aut dolor itaque. Alias quia accusantium consequatur nisi provident nihil. Ipsa eum officiis accusamus ullam sunt.', 57, 0),
(26, '2018-05-18 13:53:20', '2018-05-18 13:53:20', 'Prof.', 'Non deserunt ullam impedit. Voluptatem praesentium officiis quaerat soluta assumenda. Et vero quisquam non delectus quaerat repellendus perspiciatis fugiat. Earum accusantium officia repudiandae officia molestiae aliquid.', 41, 0),
(27, '2018-05-18 13:53:20', '2018-05-18 13:53:20', 'Mrs.', 'Facilis aut quo sunt qui autem ipsam. Et rerum aspernatur rerum sint distinctio. Natus maiores voluptatem sequi sit adipisci a fuga. Laboriosam sunt quo autem dolor sit aut sequi.', 51, 0),
(28, '2018-05-18 13:53:20', '2018-05-18 13:53:20', 'Ms.', 'Molestias nesciunt odit perferendis et quidem atque dolore. Non in voluptatibus commodi numquam velit. Ut sapiente autem labore tenetur. Et ea et magni rerum.', 69, 0),
(29, '2018-05-18 13:53:20', '2018-05-18 13:53:20', 'Dr.', 'Quia porro maxime ullam voluptas autem unde possimus. Eum voluptas voluptatem nulla odit. Nemo inventore illo aspernatur et. Corrupti aut corrupti eaque sequi voluptatem ut doloribus.', 13, 1),
(30, '2018-05-18 13:53:20', '2018-05-18 13:53:20', 'Dr.', 'Esse deserunt molestiae delectus possimus quidem. Labore nostrum est ut ratione fugit placeat sapiente.', 94, 0),
(31, '2018-05-18 13:53:20', '2018-05-18 13:53:20', 'Prof.', 'Eveniet expedita eligendi corrupti aliquid sed vel iure. Laborum voluptas vero voluptatem accusantium iure. Eligendi dignissimos qui corrupti sed.', 3, 0),
(32, '2018-05-18 13:53:20', '2018-05-18 13:53:20', 'Prof.', 'A ducimus magni quia est magni ratione. Sit excepturi aliquid itaque quidem ea enim sed. Est at ipsum qui.', 21, 1),
(33, '2018-05-18 13:53:20', '2018-05-18 13:53:20', 'Dr.', 'Omnis illum quia sapiente quo. Eos ut tempora facere aut molestiae rerum quis voluptatem. Ipsum dolorum adipisci dolor repudiandae. Illo autem libero eos et quidem odit ut. Vero et est delectus doloremque consequuntur dolorem dolorum possimus.', 80, 0),
(34, '2018-05-18 13:53:20', '2018-05-18 13:53:20', 'Prof.', 'Perspiciatis aut cum ut. Ut aut unde laborum quasi.', 80, 1),
(35, '2018-05-18 13:53:20', '2018-05-18 13:53:20', 'Dr.', 'Totam excepturi harum dolorem. Quibusdam ea aspernatur dolorum et laboriosam nulla. Explicabo placeat totam odit quod.', 29, 1),
(36, '2018-05-18 13:53:20', '2018-05-18 13:53:20', 'Dr.', 'Itaque quibusdam expedita et esse. Eaque voluptate harum ut minima recusandae. Eos eaque omnis quo minima omnis. Ea voluptatibus laudantium praesentium earum.', 52, 1),
(37, '2018-05-18 13:53:20', '2018-05-18 13:53:20', 'Mr.', 'Nihil qui alias nesciunt nihil dolore nam. Inventore non sit quos vel. Molestias hic illum dolorem temporibus molestias provident soluta.', 86, 0),
(38, '2018-05-18 13:53:20', '2018-05-18 13:53:20', 'Miss', 'Ut reiciendis eos animi sed qui. Suscipit provident eum nobis consequatur rem aliquam quam. At quis quasi ea est eos.', 40, 0),
(39, '2018-05-18 13:53:21', '2018-05-18 13:53:21', 'Prof.', 'Quia quidem velit qui beatae eos. Sint quia quaerat sed nihil inventore. Voluptatem expedita tempore facilis. Voluptas consequatur non consequuntur mollitia.', 70, 1),
(40, '2018-05-18 13:53:21', '2018-05-18 13:53:21', 'Prof.', 'Quo minima rerum est odit veniam. Dolores cupiditate enim omnis. Velit a iusto sint id id magni.', 14, 0),
(41, '2018-05-18 13:53:21', '2018-05-18 13:53:21', 'Mrs.', 'Sit suscipit quasi voluptates quos mollitia quidem sequi quisquam. Molestiae omnis nulla exercitationem ut sit consequatur. Omnis officiis et voluptatem. Quibusdam dolores accusantium qui ut.', 56, 0),
(42, '2018-05-18 13:53:21', '2018-05-18 13:53:21', 'Dr.', 'Perferendis iure est molestiae aspernatur esse eligendi quia. Nesciunt inventore sed est et occaecati. Omnis quia hic omnis.', 46, 0),
(43, '2018-05-18 13:53:21', '2018-05-18 13:53:21', 'Miss', 'Ducimus non voluptates expedita at. Nihil et neque magni expedita. Quia illum recusandae rerum vitae consequatur aut. Mollitia a mollitia voluptatem minus delectus autem.', 18, 1),
(44, '2018-05-18 13:53:21', '2018-05-18 13:53:21', 'Dr.', 'Consequatur et aut nobis incidunt molestiae. Maxime repellat consequatur consequatur. Maiores odit est ullam.', 49, 0),
(45, '2018-05-18 13:53:21', '2018-05-18 13:53:21', 'Prof.', 'Ea modi consectetur dolore illum id. Molestiae sequi officiis nemo commodi nisi quasi. Ipsa doloremque perferendis id totam ullam ullam.', 35, 0),
(46, '2018-05-18 13:53:21', '2018-05-18 13:53:21', 'Prof.', 'Itaque fugiat temporibus sunt dolore aliquam aut. Eligendi doloribus qui occaecati nostrum quia. Soluta labore quos a ut rerum labore.', 16, 0),
(47, '2018-05-18 13:53:21', '2018-05-18 13:53:21', 'Miss', 'Sed illum quis ab est ipsa libero necessitatibus. Et officia nobis tenetur cumque reprehenderit et. Minima corrupti iure id consectetur vel consequatur. Omnis et possimus tempore.', 47, 1),
(48, '2018-05-18 13:53:21', '2018-05-18 13:53:21', 'Mr.', 'Aut nesciunt et et. Saepe aspernatur vero veritatis. Quo provident officia error corporis quam. Nihil dignissimos repudiandae tempora enim quo voluptate.', 77, 0),
(49, '2018-05-18 13:53:21', '2018-05-18 13:53:21', 'Mrs.', 'Earum consectetur aliquam eos autem dignissimos nostrum dignissimos. Corporis sapiente consequuntur dignissimos assumenda saepe. Adipisci architecto cumque est aut est dolorum.', 52, 1),
(50, '2018-05-18 13:53:21', '2018-05-18 13:53:21', 'Ms.', 'Voluptatem sint error eum laborum autem odit. Aliquid qui ab facere sit. Dolorem qui ipsum doloremque odit totam harum dicta culpa. Aliquam aliquam quidem corrupti est.', 30, 1),
(51, '2018-05-18 14:53:01', '2018-05-18 14:53:01', 'product', 'leiras', 123, 1),
(52, '2018-05-18 14:54:26', '2018-05-18 14:54:26', 'product1', 'leiras', 123, 1);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `api_token` text COLLATE utf8mb4_unicode_ci,
  `role` tinyint(3) UNSIGNED NOT NULL DEFAULT '2'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- A tábla adatainak kiíratása `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `remember_token`, `created_at`, `updated_at`, `api_token`, `role`) VALUES
(1, 'Test Elek', 'test.elek@test.com', '$2y$10$X4nePAapyUcKL7FDpR7HMuqyuvSdqW8qh1u.03j2xfnPJtzG6K2um', NULL, '2018-06-04 04:15:44', '2018-06-04 04:15:44', NULL, 2),
(2, 'Lapos Elemér', 'lapos.elemer@test.com', '$2y$10$zo/6Bhvs13Sr.e7odJMh9.rC43irciJD.5eTgKTF/FGWaAi4AkNS2', NULL, '2018-06-04 04:15:44', '2018-06-04 04:15:44', NULL, 2),
(3, 'Kiss Pista', 'kis.pista@test.com', '$2y$10$rltB9kSlUFbiN4VcfWzaVuWB4gfFOWfeGjYwMN.rlzH2UTtw0iGWy', NULL, '2018-06-04 04:15:44', '2018-06-04 04:15:44', NULL, 1);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `user_badges`
--

CREATE TABLE `user_badges` (
  `id` int(10) UNSIGNED NOT NULL,
  `badge_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `badges`
--
ALTER TABLE `badges`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `oauth_access_tokens`
--
ALTER TABLE `oauth_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_access_tokens_user_id_index` (`user_id`);

--
-- A tábla indexei `oauth_auth_codes`
--
ALTER TABLE `oauth_auth_codes`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `oauth_clients`
--
ALTER TABLE `oauth_clients`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_clients_user_id_index` (`user_id`);

--
-- A tábla indexei `oauth_personal_access_clients`
--
ALTER TABLE `oauth_personal_access_clients`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_personal_access_clients_client_id_index` (`client_id`);

--
-- A tábla indexei `oauth_refresh_tokens`
--
ALTER TABLE `oauth_refresh_tokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_refresh_tokens_access_token_id_index` (`access_token_id`);

--
-- A tábla indexei `password_resets`
--
ALTER TABLE `password_resets`
  ADD KEY `password_resets_email_index` (`email`);

--
-- A tábla indexei `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

--
-- A tábla indexei `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- A tábla indexei `user_badges`
--
ALTER TABLE `user_badges`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_badges_badge_id_foreign` (`badge_id`),
  ADD KEY `user_badges_user_id_foreign` (`user_id`);

--
-- A kiírt táblák AUTO_INCREMENT értéke
--

--
-- AUTO_INCREMENT a táblához `badges`
--
ALTER TABLE `badges`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT a táblához `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT a táblához `oauth_clients`
--
ALTER TABLE `oauth_clients`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT a táblához `oauth_personal_access_clients`
--
ALTER TABLE `oauth_personal_access_clients`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT a táblához `products`
--
ALTER TABLE `products`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;
--
-- AUTO_INCREMENT a táblához `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT a táblához `user_badges`
--
ALTER TABLE `user_badges`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- Megkötések a kiírt táblákhoz
--

--
-- Megkötések a táblához `user_badges`
--
ALTER TABLE `user_badges`
  ADD CONSTRAINT `user_badges_badge_id_foreign` FOREIGN KEY (`badge_id`) REFERENCES `badges` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `user_badges_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
